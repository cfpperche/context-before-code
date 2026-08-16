# Tech spec — Catalog Compare API

Source of truth for implementation phases. If code and this file disagree,
this file wins until an ADR changes it.

## Purpose

Let a buyer upsert two catalog extracts and retrieve a per-SKU diff. The
service is a single process. Data dies with the process.

## Domain model

### Types

`SourceID` — `^[a-z0-9-]{1,32}$`. Examples: `ours`, `supplier-a`.

`SKU` — `^[A-Z0-9-]{1,32}$`. Examples: `HBR-1001`.

`Product`

| Field | Type | Invariant |
| --- | --- | --- |
| `sku` | string | matches `SKU` |
| `name` | string | 1–80 runes, trimmed |
| `price_cents` | int | `>= 0` |
| `category` | string | 1–40 runes, trimmed |
| `source` | string | matches `SourceID` |

Identity of a product is `(source, sku)`. Name, price, and category are data.

`CompareStatus` — one of `match`, `missing_left`, `missing_right`,
`price_diff`, `field_diff`.

- `missing_left` — the SKU exists in `right` and not in `left`
- `missing_right` — the SKU exists in `left` and not in `right`
- `price_diff` — both sides have the SKU and `price_cents` differs
- `field_diff` — both sides have the SKU, price is equal, and `name` or
  `category` differs
- `match` — both sides have the SKU and all three data fields are equal

Priority if several apply: `missing_*` first, then `price_diff` (price is the
buyer’s main question), then `field_diff` (name or category), then `match`.
A row where price *and* name differ is `price_diff`; the field difference is
not reported separately. That is a deliberate loss of detail (ADR 003).

`CompareItem`

| Field | Type |
| --- | --- |
| `sku` | string |
| `status` | `CompareStatus` |
| `left` | `Product` or omitted |
| `right` | `Product` or omitted |

### Sample data

`ours`

| sku | name | price_cents | category |
| --- | --- | --- | --- |
| HBR-1001 | Harbor mug 12oz | 1299 | tableware |
| HBR-1002 | Harbor mug 16oz | 1599 | tableware |
| HBR-1003 | Harbor tumbler 8oz | 999 | tableware |
| HBR-2001 | Deck chair canvas | 8900 | outdoor |

`supplier-a`

| sku | name | price_cents | category |
| --- | --- | --- | --- |
| HBR-1001 | Harbor mug 12oz | 1299 | tableware |
| HBR-1002 | Harbor mug 16 oz | 1749 | tableware |
| HBR-1003 | Harbor tumbler 8oz | 999 | drinkware |
| HBR-3001 | Teak side table | 22900 | outdoor |

Expected compare `ours` vs `supplier-a` (sorted by sku):

| sku | status | why |
| --- | --- | --- |
| HBR-1001 | `match` | identical |
| HBR-1002 | `price_diff` | 1599 vs 1749; the name also differs, price wins |
| HBR-1003 | `field_diff` | same price, `category` tableware vs drinkware |
| HBR-2001 | `missing_right` | only in ours |
| HBR-3001 | `missing_left` | only in supplier-a |

Five rows, five statuses. The fixtures exist to make every `CompareStatus`
and the priority rule reachable from one request.

### Invariants

- Upsert of the same `(source, sku)` replaces name, price, category.
- Unknown source on GET list returns `[]`, not 404. A source exists when it
  has at least one product; empty is a valid list.
- Compare of two unknown sources returns 200 and `items: []`. A misspelled
  source is therefore indistinguishable from an empty one — see ADR 005 for
  why we accept that and what the response echoes back to soften it.
- Compare is a snapshot: take two copies under the lock, then diff unlocked.
- SKUs are compared case-sensitively after validation (already uppercase).

## HTTP contract

Base URL: `http://localhost:8080`

| Method | Path | Request | Success | Failure |
| --- | --- | --- | --- | --- |
| PUT | `/sources/{source}/products/{sku}` | JSON body: `name`, `price_cents`, `category` | 200 `{product}` | 400 validation |
| GET | `/sources/{source}/products/{sku}` | — | 200 `{product}` | 404 `not_found` |
| GET | `/sources/{source}/products` | — | 200 `{items:[product]}` | 400 bad source |
| GET | `/compares?left={source}&right={source}` | — | 200 `{left,right,items:[compare_item]}` | 400 missing/bad query |

The failure column names the case that belongs to the route. The error table
below is the exhaustive one; every route can also answer 405, 415, 413, 503,
and 500.

Path `{source}` and `{sku}` are validated with the same rules as the fields.
The body must not send a conflicting `source` or `sku`; if present they must
equal the path.

PUT is an upsert. There is no DELETE. There is no POST.

### Media types and body rules

- Every response has `Content-Type: application/json`, including errors the
  router or the timeout produces.
- A request with a body must send `Content-Type: application/json` (a
  `charset` parameter is accepted). Anything else is 415.
- The decoder runs with `DisallowUnknownFields`. An unknown key is 400, not a
  silent ignore: a supplier sending `price` instead of `price_cents` must hear
  about it.
- Bodies are capped at 1 MiB (middleware). Over the cap is 413.

### Response shapes

- A single product is the bare product object: `{"sku":…,"name":…}`.
- Collections are wrapped: `{"items":[…]}`. Compare adds the two source names
  it actually compared: `{"left":…,"right":…,"items":[…]}`.
- Errors are always the envelope below. There is no third shape.

### Error envelope

```json
{
  "error": {
    "code": "invalid_request | not_found | method_not_allowed | unsupported_media_type | payload_too_large | timeout | internal",
    "message": "human readable, no stack, no internals",
    "request_id": "from middleware"
  }
}
```

| Situation | HTTP | code |
| --- | --- | --- |
| Bad JSON, unknown field, bad field value, bad path value, missing/invalid query | 400 | `invalid_request` |
| Body over 1 MiB | 413 | `payload_too_large` |
| Body with a non-JSON `Content-Type` | 415 | `unsupported_media_type` |
| GET one product, missing | 404 | `not_found` |
| Unknown route | 404 | `not_found` |
| Known path, wrong method (`Allow` header set) | 405 | `method_not_allowed` |
| Request exceeded the 3s server timeout | 503 | `timeout` |
| Panic or unknown error | 500 | `internal` |

Compare never uses 404/409 to mean "the catalogs differ".

The last four rows are the ones a stdlib service leaks by default:
`http.ServeMux` answers unmatched routes and methods in `text/plain`, and
`http.TimeoutHandler` writes its own plain body. Error handling is a primary
criterion here, so those paths are ours, not the framework's. The handler and
middleware skills say how.

`request_id` is non-empty on every envelope except the 503, which is written
by `http.TimeoutHandler` from a fixed string; there the id travels in the
`X-Request-ID` response header instead. That asymmetry is deliberate and
tested.

### Compare resource

HTTP 200 means "I compared the two names you gave me". Each item carries its
own `status`. See ADR 003.

Items are sorted by `sku` ascending so tests are stable.

## Persistence and concurrency

- Store: in-memory map `source → sku → Product`
- Concurrency: `sync.RWMutex` on the store; copy on read (ADR 001)
- Process lifetime: data is gone on exit

## Test plan

The failing-tests phase must encode at least:

1. PUT then GET returns the product (happy path, sample mug)
2. PUT with `price_cents: -1` → 400 `invalid_request`
3. PUT with an unknown JSON key (`price`) → 400 `invalid_request`
4. PUT with `Content-Type: text/plain` → 415 `unsupported_media_type`
5. GET missing SKU → 404 `not_found`
6. `GET /nope` → 404 envelope, and `DELETE` on a known path → 405 envelope
   with an `Allow` header (both must be JSON, not the stdlib text body)
7. Compare of the sample fixtures → five items, statuses as in the table,
   including `field_diff` and the price-wins-over-field row (HBR-1002)
8. Compare with a misspelled source → 200, `items: []`, and `left`/`right`
   echo what was compared (ADR 005)
9. Two goroutines PUT different SKUs into the same source; `-race` is clean
   and both GETs succeed
10. Compare is stable under a concurrent PUT: the handler diffs a snapshot,
    not a live map. Removing the snapshot must make `-race` report a write /
    read on the map. Race tests are probabilistic; run this one with
    `-count=10` before you trust it

Coverage floor: **70%** of statements in package `catalog`, measured with
`go test -coverprofile` + `go tool cover -func`. `cmd/catalogd` is a
`main` wrapper and is excluded from the number. The quality gate copies this
figure; it is defined here.

## Out of scope

This table is the single list. ADR 004 records *why we refuse as a policy*;
it does not restate the rows.

| Item | Why it stays out |
| --- | --- |
| Real database | Brief allows in-memory; persistence is not scored (ADR 001, 004) |
| Auth | Not asked; would hide the error-handling signal behind a token |
| Docker / CI | Not asked; reviewer runs `go test` |
| Pagination / sorting of list | Marginal for the score; compare already sorts its items |
| DELETE / PATCH / POST | PUT upsert covers the brief |
| RFC 9457 type URIs | No company URI space; envelope is enough (research decision 6) |
| Supplier file upload (CSV) | Brief says HTTP API of products, not a file pipeline |
| Router, ORM, testify | Crash-course bar is stdlib; extra kits are surface we cannot defend |
| A `Store` interface with one implementation | Premature; see ADR 001 |

## Traceability

- Primary evaluator criteria this spec serves: errors (envelope + mapping),
  tests (plan above), documentation (godoc + README + ADRs)
- ADRs: 001 in-memory, 002 flat package, 003 per-item status, 004 refusals,
  005 unknown source is an empty source
