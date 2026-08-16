# Prompt — failing tests

Attach `skills/testing`. `TECHSPEC.md` is accepted.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, and skills/testing/SKILL.md.

Current phase: failing-tests. You may only add or edit test files and the
minimum stub types/signatures required for those tests to compile.

Write the contract tests listed in the TECHSPEC test plan:
- happy paths
- validation errors
- not-found
- compare / domain invariants
- concurrency if the store is shared in-memory

Every test must fail for the right reason (assertion or missing behavior),
not because the test file is broken.

Do not implement handlers or the store. Do not add dependencies.
Do not create CI, Docker, or README features.
```

## Gate (you)

- [ ] Tests compile — a suite that does not build is not red, it is broken
- [ ] Suite is red
- [ ] Failures match the spec (not `undefined: main`)
- [ ] Error cases assert the envelope, not only the status number
- [ ] Commit: `test: contract is red`
