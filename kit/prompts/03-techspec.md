# Prompt — tech spec

`RESEARCH.md` Decisions section is accepted by you.

## Prompt

```
Read CLAUDE.md and RESEARCH.md. Write TECHSPEC.md from the template in this
repo. Do not write code. Do not invent decisions that are still open.

The spec must include:
- domain types, invariants, realistic sample data
- HTTP contract table (method, path, request, success, failure)
- error envelope
- compare/special-resource semantics, including status-code policy
- persistence and concurrency assumptions
- a test plan the failing-tests phase can implement verbatim
- an out-of-scope table with a reason for every row
- traceability back to the primary evaluator criteria

Keep the surface small. Every extra endpoint needs a sentence that says which
primary criterion it serves. If it serves none, delete it.

After the spec, list the ADRs we should open. Do not write the ADR files until
I say so.
```

## Gate (you)

- [ ] You can write the first failing tests from the contract section alone
- [ ] Out of scope has reasons, not a shrug
- [ ] Sample data looks like production, not `foo`/`bar`
- [ ] Current phase in `CLAUDE.md` is now `techspec` (done) / ready for tests
