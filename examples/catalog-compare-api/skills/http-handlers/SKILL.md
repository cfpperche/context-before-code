---
name: http-handlers
description: >
  HTTP adapter rules for Catalog Compare. Handlers decode, validate, call
  domain, encode. Nothing else.
---

# HTTP handlers (Go)

## Shape

`ServeMux` from the stdlib (Go 1.22 patterns):

```
PUT /sources/{source}/products/{sku}
GET /sources/{source}/products/{sku}
GET /sources/{source}/products
GET /compares
```

`Server(store Store) http.Handler` wires mux + middleware.

```
decode → validate → store/compare → encode
```

## Status codes

Follow the contract table. Compare is **always 200** on a valid query
(ADR 003). Item `status` lives in JSON.

Path values are the identity. If the body includes `source` or `sku` and
they disagree with the path → 400 `invalid_request`.

## Errors

| Domain | HTTP | code |
| --- | --- | --- |
| `ErrInvalid` | 400 | `invalid_request` |
| `ErrNotFound` | 404 | `not_found` |
| anything else | 500 | `internal` |

500 `message` is `"internal error"`. Do not send `err.Error()`.

## Do not

- `chi`, `gin`, `echo`, `gorilla/mux`
- Business rules that only exist in the handler (status priority lives in
  `compare.go`)
- Extra endpoints
- Read `r.Body` after `json.Decoder` without `http.MaxBytesReader`
  (middleware installs the limit; handlers may assume it)
