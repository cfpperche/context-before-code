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
3. GET missing SKU → 404 `not_found`
4. Sample compare → four items, exact statuses
5. Concurrent PUTs of different SKUs, then GET both; run under `-race`
6. Compare does not range a live map (snapshot): concurrent PUT during
   compare must not race

## Fail for the right reason

First commit: handlers/store missing, tests compile against stubs
(`type Memory struct{}` + method signatures returning `ErrNotImplemented`
or similar). Failures are `not implemented` / assertion, not `undefined:
Product`.

## Do not

- `testify`
- `time.Sleep`
- `t.Parallel` on tests that share one `Memory` unless you mean to
- Golden files for the whole compare body (assert the four statuses)
