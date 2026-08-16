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

## Do not

- Auth
- CORS `*`
- Metrics / tracing / OpenTelemetry
- Feature flags
- "Just a little" gzip

## Tests

- Panic in a handler becomes 500 + envelope, process lives
- Request ID from the client is echoed
- Generated request ID is present when the client omitted it
