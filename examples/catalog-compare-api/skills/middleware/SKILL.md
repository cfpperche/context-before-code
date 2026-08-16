---
name: middleware
description: >
  Process-wide HTTP middleware for Catalog Compare. Use only in the
  middleware phase.
---

# Middleware (Go)

## Allowed list

1. **Request ID** — honor `X-Request-ID` if it matches `^[a-zA-Z0-9-]{1,64}$`,
   otherwise generate 8 bytes from `crypto/rand` as hex (stdlib, no UUID
   library). Put it in the `context`, and set the `X-Request-ID` response
   header **before** calling the next handler so it survives a timeout.
2. **Recover** — panic → log + 500 envelope. Process lives.
3. **Access log** — `log/slog` to stdout: method, path, status, duration_ms,
   request_id.
4. **Max body** — `http.MaxBytesReader(w, r.Body, 1<<20)` (1 MiB). The
   handler turns the resulting `*http.MaxBytesError` into 413.
5. **Timeout** — `http.TimeoutHandler` at 3s.

## Order

```
request ID → recover → log → timeout → mux
```

Request ID is **outermost** on purpose. The recover middleware writes the 500
envelope from the request it was handed; if the id were injected below it, the
panic envelope would carry an empty `request_id` — which is exactly the field
a reviewer greps for when they read the log next to the response.

## The timeout body is not free

`http.TimeoutHandler` writes its own message with 503 and discards whatever
the inner handler had buffered. Pass the envelope as that message:

```go
const timeoutBody = `{"error":{"code":"timeout","message":"request timed out","request_id":""}}`
h = http.TimeoutHandler(h, 3*time.Second, timeoutBody)
```

`request_id` is empty there because the string is fixed at wiring time. The
id is still on the response, in the `X-Request-ID` header the outermost
middleware set. `TimeoutHandler` does not set a content type, so the request
ID middleware also sets `Content-Type: application/json` up front — every
response in this service is JSON.

## Do not

- Auth, CORS, pprof, Prometheus, OpenTelemetry
- `logrus` / `zap` / `zerolog`
- A middleware framework
- `time.Now().UnixNano()` as an id: monotonic, guessable, and two requests in
  the same clock tick collide

## Tests

- Handler `panic("boom")` → 500 `internal`, **non-empty `request_id`**,
  process continues
- Client `X-Request-ID: abc` is echoed on success and on error
- Missing header still produces a non-empty `request_id` in the envelope
- A handler that sleeps past 3s → 503 with the envelope body and the
  `X-Request-ID` header set
