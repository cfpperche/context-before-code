---
name: middleware
description: >
  Process-wide HTTP middleware for the take-home. Use only in the middleware
  phase. Do not sneak this into handlers.
---

# Middleware ({{LANGUAGE}})

## Allowed list (delete any the spec did not ask for)

1. Request ID (incoming header or generate)
2. Recover → 500 + envelope
3. Access log: method, path, status, duration, request ID
4. Max body size
5. Timeout on the request context

## Order

```
request ID → recover → log → timeout → router
```

Request ID is outermost. If it is injected below the recover layer, the 500
envelope written by recover has no request id — the one field that ties the
response to the log line. Same reason it sets the id on the response *before*
delegating: a timeout layer discards whatever the inner handler buffered.

## The framework's default error pages are yours

Check what your HTTP kit emits for an unmatched route, a wrong method, a body
over the limit, and a timeout. Most emit plain text outside your envelope.
If errors are a scored criterion, those responses are part of the contract —
put them in the spec's error table and override them here.

## Do not

- Auth
- CORS `*`
- Metrics / tracing / OpenTelemetry
- Feature flags
- "Just a little" gzip

## Tests

- Panic in a handler becomes 500 + envelope **with a non-empty request id**,
  process lives
- Request ID from the client is echoed
- Generated request ID is present when the client omitted it
- Unmatched route, wrong method, and timeout all return the envelope, not the
  framework's default body
