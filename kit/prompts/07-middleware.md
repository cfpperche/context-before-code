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

Do not add auth, CORS wildcards, metrics, or tracing unless the spec says so.
Do not change handler business logic.
```

## Gate (you)

- [ ] Panic becomes a 500 with the envelope, not a crashed process
- [ ] Request ID is in logs and in the error envelope
- [ ] Existing contract tests still green
- [ ] Commit: `feat: http middleware`
