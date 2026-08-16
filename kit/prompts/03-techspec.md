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

- [ ] You can write the first failing tests from the contract section alone —
      including content type, unknown fields, body cap, unknown route, wrong
      method, and timeout
- [ ] Every domain status the spec defines is reachable from the sample data
- [ ] Out of scope has reasons, not a shrug
- [ ] Sample data looks like production, not `foo`/`bar`
- [ ] The coverage floor is a number in the spec, not in the gate file

## Prompt — draft the ADRs (same phase)

Run this only after you have edited and accepted the spec.

```
Read CLAUDE.md and TECHSPEC.md. Write one ADR per file in adrs/, using
adrs/000-template.md, numbered from 001.

One decision per file. Include the decisions we refused as much as the ones
we took: persistence, package layout, status-code policy, and one ADR for
what we are not building.

Do not restate the spec. An ADR says what force made the choice necessary,
what we chose, what we rejected and why, and what we accept as the downside.
Do not copy the out-of-scope table; point at it.

Do not write code.
```

## Gate (you)

- [ ] One decision per file, numbered in the order they were taken
- [ ] Every ADR names an alternative you actually considered
- [ ] The refusal ADR points at the spec table instead of duplicating it
- [ ] Current phase in `CLAUDE.md` is now `techspec` (done) / ready for tests
