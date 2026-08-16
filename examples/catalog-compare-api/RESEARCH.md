# Research

## Brief restated

HTTP API to upsert products into named sources, fetch and list them, and
compare two sources per SKU. Primary scores: errors, tests, docs. Language
free. Company runs Go and Java. In-memory allowed. One day.

## Pass 1 — market patterns

| Topic | What we found | Source |
| --- | --- | --- |
| Error envelope | RFC 9457 problem+json is the current interop default (`type`, `title`, `status`, `detail`). Stripe-style `{error: {type, message}}` is still widely copied in take-homes. | [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html) |
| Status codes | 200 for a successful retrieve/compare; 201 create if we distinguished create from upsert (we will not); 400 validation; 404 missing resource; 405 method; 413 body too large; 500 unknown. Do not overload HTTP status with per-row compare outcomes. | [RFC 9110 §15](https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes) |
| Compare / diff | GitHub's compare API and JSON Patch (RFC 6902) both return **200 + a body that describes each change**. The HTTP status is about the request, not about whether row 17 differs in price. | [GitHub compare commits](https://docs.github.com/en/rest/commits/commits#compare-two-commits), [RFC 6902](https://www.rfc-editor.org/rfc/rfc6902) |
| Upsert | PUT on a concrete resource identity is idempotent. POST-to-collection for upsert is common and weaker. We have a natural identity: `(source, sku)`. | [RFC 9110 §9.3.4 PUT](https://www.rfc-editor.org/rfc/rfc9110.html#name-put) |
| Idempotency | PUT retries must not create duplicates. Compare is a pure read. | same |
| Pagination | Cursor pagination is the mature default. For a one-day in-memory take-home it is marginal unless the brief asks. | [Google AIP-158](https://google.aip.dev/158) |

## Pass 2 — large-company practice

| Topic | What we found | Source |
| --- | --- | --- |
| Errors as values | Go at scale: wrap, keep types, no panic in libraries. Uber and Google's review comments agree. | [Uber Go Style Guide — errors](https://github.com/uber-go/guide/blob/master/style.md#error-wrapping), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments) |
| HTTP kit | `net/http` is enough under ~15 routes. Routers appear when middleware graphs get large. A take-home with four routes does not need one. | [net/http](https://pkg.go.dev/net/http), [Go blog: ServeMux](https://go.dev/blog/routing-enhancements) |
| In-memory + mutex | Standard pattern: `sync.RWMutex`, copy on read, never return the live map. Race detector is the test, not a code comment. | [Go blog: Race Detector](https://go.dev/doc/articles/race_detector) |
| Compare as a read | Treat compare as a snapshot query, not as a job with 202. No queue. | (derived from pass 1 + timebox) |
| Over-build | Mature orgs do not put Docker, CI, and Postgres on a spike that will be thrown away. They write the reason down. | (judgment; see ADR 004) |

## Pass 3 — this company

The employer is fictional, so there is no real style guide to scrape. We
simulate the honest version of this pass:

| Topic | What we found | Source |
| --- | --- | --- |
| Language / HTTP kit | Brief + recruiter: production is Go and Java. No public Go module to copy. | brief.md |
| Error style | No published API guide. We do **not** pretend they use problem+json internally. We pick a small envelope and document it. | brief.md |
| Testing culture | Primary criterion is tests. That is the only signal. We will run `-race` because the store is shared memory. | brief.md |

Conflicts: pass 1 prefers RFC 9457. Pass 3 gives us nothing. We still use a
small `{error:{code,message,request_id}}` envelope because it is enough to
score error handling and does not require a `type` URI we do not own. Noted
so a reviewer can ask "why not 9457?" and we have an answer.

## Decisions

1. **Go 1.22+, stdlib only** — company stack + four routes + crash-course bar.
2. **PUT `/sources/{source}/products/{sku}`** — identity is in the URL, upsert
   is idempotent.
3. **Compare is GET `/compares?left=&right=` returning 200** with a per-item
   `status` field — HTTP status describes the request; item status describes
   the row. See ADR 003.
4. **In-memory store + `sync.RWMutex`** — brief allows it; database is
   over-engineering for the timebox. See ADR 001.
5. **Flat package `catalog`** — one day, one binary, no layer theatre.
   See ADR 002.
6. **Small error envelope, not RFC 9457** — no company URI space; primary
   score is handling, not spec compliance.
7. **No pagination, auth, Docker, CI, or extra endpoints** — not asked,
   marginal for the score. See ADR 004.

## Still open

None that block the spec. Clock source (`time.Now` for logs only) stays
implicit: we do not persist timestamps on products.
