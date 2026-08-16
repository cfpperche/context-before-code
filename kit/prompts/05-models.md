# Prompt — models and store

Attach `skills/idiomatic-code` and `skills/data-layer`.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, adrs/, skills/idiomatic-code/SKILL.md, and
skills/data-layer/SKILL.md.

Current phase: models. You may implement domain types and the store.
You may edit domain tests. You may not implement HTTP handlers.

Follow the language bar in CLAUDE.md. The store must match the concurrency
ADR. Do not return internal maps. Copy on read.

Stop when the domain/store tests from the test plan are green and the HTTP
contract tests are still red (handlers do not exist yet).
```

## Gate (you)

- [ ] Domain / store tests green
- [ ] HTTP contract tests still red
- [ ] Race detector clean on store tests
- [ ] Commit: `feat: domain and store`
