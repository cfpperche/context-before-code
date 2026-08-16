---
name: http-handlers
description: >
  HTTP adapter rules. Use when implementing or reviewing handlers. Handlers
  decode, validate, call domain, encode. Nothing else.
---

# HTTP handlers ({{LANGUAGE}})

## Shape

```
decode → validate → domain/store → encode
```

If a rule is not in `TECHSPEC.md`, it does not belong in a handler.

## Status codes

Follow the contract table. If compare returns **per-item** status inside a
200, do not "simplify" it to 409 for the whole response.

## Errors

Map known domain errors to the envelope. Unknown errors are 500 and must not
leak internals. One helper writes every error body, including the ones the
router produces for unknown routes and wrong methods — a reviewer finds those
with two `curl`s.

Decide and write down: required request content type, what happens to unknown
fields in the body, and what an over-sized body returns.

## Do not

- Add a framework not named in `CLAUDE.md`
- Business rules that only exist in the handler
- Extra endpoints
- Read the body twice
- Ignore `Context` / cancellation
