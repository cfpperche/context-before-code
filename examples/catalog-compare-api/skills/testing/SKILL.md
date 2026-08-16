---
name: testing
description: >
  Contract tests for Catalog Compare. Use in the failing-tests phase and
  when adding tests later.
---

# Testing (Go)

## Style

- Table-driven: `tests := []struct{ name string; ... }{ ... }`
- `t.Run(tt.name, ...)`
- `httptest.NewRecorder` + `http.NewRequestWithContext`
- Compare JSON with `encoding/json` into structs, not string equality
- Helper: `func putProduct(t *testing.T, srv http.Handler, src, sku string, body any)`
  marked `t.Helper()`

## Contract tests must cover

Exactly the test plan in `TECHSPEC.md`:

1. PUT + GET mug `HBR-1001`
2. PUT `price_cents: -1` → 400 `invalid_request`
3. PUT with an unknown key → 400 `invalid_request`
4. PUT with `Content-Type: text/plain` → 415 `unsupported_media_type`
5. GET missing SKU → 404 `not_found`
6. `GET /nope` → 404 envelope; `DELETE` a known path → 405 envelope + `Allow`
7. Sample compare → five items, exact statuses, including `field_diff`
   (HBR-1003) and price-beats-field (HBR-1002)
8. Compare with a misspelled source → 200, `items: []`, `left`/`right` echoed
9. Concurrent PUTs of different SKUs, then GET both; run under `-race`
10. Compare does not range a live map (snapshot): concurrent PUT during
    compare must not race

Assert the envelope on every error case: status **and** `error.code` **and** a
non-empty `error.request_id`. A test that only checks the status number would
pass against the stdlib's plain-text 404.

## Fail for the right reason

First commit: handlers/store missing, tests compile against stubs
(`type Memory struct{}` + method signatures returning `ErrNotImplemented`
or similar). Failures are `not implemented` / assertion, not `undefined:
Product`. A suite that does not build is not red; it is broken.

## Do not

- `testify`
- `time.Sleep`
- `t.Parallel` on tests that share one `Memory` unless you mean to
- Golden files for the whole compare body (assert the five statuses)
- Trusting a single run of a race test: the two concurrency cases run with
  `-count=10 -race` before you call the row green
