---
name: middleware
description: >
  Process-wide HTTP middleware for Catalog Compare. Use only in the
  middleware phase.
---

# Middleware (Go)

## Allowed list

1. **Request ID** — honor `X-Request-ID` if it matches `^[a-zA-Z0-9-]{1,64}$`,
   otherwise generate `strconv.FormatInt(time.Now().UnixNano(), 36)` (no UUID
   library). Put it on the response and in `context`.
2. **Recover** — panic → log + 500 envelope. Process lives.
3. **Access log** — `log/slog` to stdout: method, path, status, duration_ms,
   request_id.
4. **Max body** — `http.MaxBytesReader(w, r.Body, 1<<20)` (1 MiB).
5. **Timeout** — `http.TimeoutHandler` at 3s, or `context.WithTimeout` in a
   wrapper. Prefer `TimeoutHandler` for a single stdlib line.

Order (outer to inner): recover → request ID → log → timeout → mux.
Max body is applied in the PUT handler wrapper or as a mux middleware that
wraps `r.Body`.

## Do not

- Auth, CORS, pprof, Prometheus, OpenTelemetry
- `logrus` / `zap` / `zerolog`
- A middleware framework

## Tests

- Handler `panic("boom")` → 500 `internal`, process continues
- Client `X-Request-ID: abc` is echoed on success and on error
- Missing header still produces a non-empty `request_id` in the envelope
