---
name: quality-gate
description: >
  Repair rules for a failed quality gate. Use only when QUALITY-GATE.md has
  failing rows. Do not add features.
---

# Quality gate ({{LANGUAGE}})

## Commands

Paste the exact commands from `QUALITY-GATE.md`. Do not invent a different
linter mid-repair.

## Repair policy

- Format diffs: run the formatter, nothing else
- Vet / lint: fix the diagnostic, do not disable it
- Race: fix the race. Do not skip the test
- Coverage below floor: add tests for uncovered *spec* behavior. Do not
  delete tests. Do not write tests that only exist to bump the number
- Missing docs: add the comment, do not unexport to dodge it

## Do not

- `//nolint` without a reason in the same line and an ADR
- Drop the coverage floor
- Add CI so the gate "looks official"
