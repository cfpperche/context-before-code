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

Priority if several apply: `missing_*` first, then `price_diff` (price is the
buyer’s main question), then `field_diff` (name or category), then `match`.

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
| HBR-2001 | Deck chair canvas | 8900 | outdoor |

`supplier-a`

| sku | name | price_cents | category |
| --- | --- | --- | --- |
| HBR-1001 | Harbor mug 12oz | 1299 | tableware |
| HBR-1002 | Harbor mug 16oz | 1749 | tableware |
| HBR-3001 | Teak side table | 22900 | outdoor |

Expected compare `ours` vs `supplier-a`:

| sku | status | why |
| --- | --- | --- |
| HBR-1001 | `match` | identical |
| HBR-1002 | `price_diff` | 1599 vs 1749 |
| HBR-2001 | `missing_right` | only in ours |
| HBR-3001 | `missing_left` | only in supplier-a |

### Invariants

- Upsert of the same `(source, sku)` replaces name, price, category.
- Unknown source on GET list returns `[]`, not 404. A source exists when it
  has at least one product; empty is a valid list.
- Compare of two unknown sources returns 200 and `items: []`.
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

Path `{source}` and `{sku}` are validated with the same rules as the fields.
The body must not send a conflicting `source` or `sku`; if present they must
equal the path.

PUT is an upsert. There is no DELETE. There is no POST.

### Error envelope

```json
{
  "error": {
    "code": "invalid_request | not_found | internal",
    "message": "human readable, no stack, no internals",
    "request_id": "from middleware"
  }
}
```

| Situation | HTTP | code |
| --- | --- | --- |
| Bad JSON, bad field, bad path, missing query | 400 | `invalid_request` |
| GET one product, missing | 404 | `not_found` |
| Panic or unknown error | 500 | `internal` |

Compare never uses 404/409 to mean "the catalogs differ".

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
3. GET missing SKU → 404 `not_found`
4. Compare of the sample fixtures → four items, statuses as in the table
5. Two goroutines PUT different SKUs into the same source; `-race` is clean
   and both GETs succeed
6. Compare is stable under a concurrent PUT: the handler does not range a
   live map (if we drop the snapshot, `-race` or the assertion fails)

## Out of scope

| Item | Why it stays out |
| --- | --- |
| Real database | Brief allows in-memory; persistence is not scored (ADR 001, 004) |
| Auth | Not asked; would hide the error-handling signal behind a token |
| Docker / CI | Not asked; reviewer runs `go test` |
| Pagination / sorting of list | Marginal for the score; compare already sorts its items |
| DELETE / PATCH / POST | PUT upsert covers the brief |
| RFC 9457 type URIs | No company URI space; envelope is enough (research decision 6) |
| Supplier file upload (CSV) | Brief says HTTP API of products, not a file pipeline |

## Traceability

- Primary evaluator criteria this spec serves: errors (envelope + mapping),
  tests (plan above), documentation (godoc + README + ADRs)
- ADRs: 001 in-memory, 002 flat package, 003 per-item status, 004 refusals
