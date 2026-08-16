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
PUT  /sources/{source}/products/{sku}
GET  /sources/{source}/products/{sku}
GET  /sources/{source}/products
GET  /compares
```

`Server(store *Memory) http.Handler` wires mux + middleware (ADR 001: the
concrete type, not an interface).

```
decode → validate → store/compare → encode
```

## The router's own errors are ours

A bare `ServeMux` answers an unknown route and a wrong method in
`text/plain`. The spec promises the envelope on every response, and error
handling is a primary criterion, so register both fallbacks:

```go
mux.HandleFunc("/", notFound)                            // unknown route → 404 envelope
mux.HandleFunc("/sources/{source}/products/{sku}", methodNotAllowed("GET", "PUT"))
mux.HandleFunc("/sources/{source}/products", methodNotAllowed("GET"))
mux.HandleFunc("/compares", methodNotAllowed("GET"))
```

A pattern that names a method matches a strict subset of the same pattern
without one, so `GET /compares` still wins for GET and only the other verbs
fall through to our handler. `methodNotAllowed` sets `Allow` and writes the
405 envelope.

## Status codes

Follow the contract table. Compare is **always 200** on a valid query
(ADR 003). Item `status` lives in JSON.

Path values are the identity. If the body includes `source` or `sku` and
they disagree with the path → 400 `invalid_request`.

## Decoding

```go
if !strings.HasPrefix(ct, "application/json") { → 415 unsupported_media_type }
dec := json.NewDecoder(r.Body)
dec.DisallowUnknownFields()
```

- Decode error → 400 `invalid_request`
- `*http.MaxBytesError` (the middleware installed the 1 MiB cap) → 413
  `payload_too_large`, checked with `errors.As` before the generic 400

## Errors

| Domain | HTTP | code |
| --- | --- | --- |
| `ErrInvalid` | 400 | `invalid_request` |
| `ErrNotFound` | 404 | `not_found` |
| anything else | 500 | `internal` |

500 `message` is `"internal error"`. Do not send `err.Error()`.

One `writeError(w, r, status, code, msg)` helper owns the envelope, pulls the
request id out of the context, and is the only place that writes an error
body. Router fallbacks call it too.

## Do not

- `chi`, `gin`, `echo`, `gorilla/mux`
- Business rules that only exist in the handler (status priority lives in
  `compare.go`)
- Extra endpoints
- Read `r.Body` after `json.Decoder` without `http.MaxBytesReader`
  (middleware installs the limit; handlers may assume it)
