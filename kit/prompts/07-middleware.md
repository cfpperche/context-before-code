# Prompt — middleware

Attach `skills/middleware`.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, and skills/middleware/SKILL.md.

Current phase: middleware. Add only what the spec or CLAUDE.md asked for.
Typical set for a small HTTP take-home:
- request ID
- recover from panic → 500 + envelope
- log method, path, status, duration, request ID
- max body size
- timeout via context

Order matters: request ID is the outermost layer, so the recover layer can
put the id in the 500 envelope and the timeout layer cannot swallow it.

Whatever the HTTP kit answers by default for an unmatched route, a wrong
method, an over-sized body, and a timeout must be replaced by the envelope in
the spec's error table.

Do not add auth, CORS wildcards, metrics, or tracing unless the spec says so.
Do not change handler business logic.
```

## Gate (you)

- [ ] Panic becomes a 500 with the envelope, not a crashed process
- [ ] Request ID is in logs and in the error envelope, including the 500
- [ ] `curl` an unknown route, a wrong method, and a slow request: all three
      come back as the envelope, not as the framework's plain text
- [ ] Existing contract tests still green
- [ ] Commit: `feat: http middleware`
