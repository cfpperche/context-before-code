# Prompt — HTTP handlers

Attach `skills/http-handlers` and `skills/idiomatic-code`.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, adrs/, skills/http-handlers/SKILL.md, and
skills/idiomatic-code/SKILL.md.

Current phase: handlers. Implement the HTTP contract. Map domain errors to
the error envelope. Do not invent extra endpoints.

Handlers decode, validate, call the store/domain, encode. No extra business
rules that are not in the spec.

Do not add a framework unless CLAUDE.md named one.
Do not add middleware in this phase.

Stop when the HTTP contract tests are green.
```

## Gate (you)

- [ ] Contract tests green
- [ ] Status codes match the spec, including per-item compare status if any
- [ ] No new endpoints
- [ ] Commit: `feat: http handlers`
