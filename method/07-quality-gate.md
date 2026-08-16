# 7. Quality gate

## Goal

An objective checklist. Not "run it and see if it works".

## Minimum bar (adapt to the language)

Copy [`../kit/QUALITY-GATE.md`](../kit/QUALITY-GATE.md) and fill the commands
for your stack. This is a Definition of Done, not a demo:

| Check | Passes when |
| --- | --- |
| Format | Tool reports no diffs (`gofmt`, `ruff format --check`, …) |
| Static analysis | Vet / linter exits 0 |
| Race / concurrency | Race detector or equivalent is on and clean |
| Coverage | Above the number you wrote in the spec (70% was the example) |
| Docs | Every exported / public symbol has a doc comment |
| Tests | Full suite green, including the contract tests from phase 1 |

If the brief named other primary criteria (load, CLI UX, SQL migrations), they
join this table. Do not invent extra ceremony the brief will not score.

## Who runs it

You. Paste the prompt in [`../kit/prompts/09-quality-gate.md`](../kit/prompts/09-quality-gate.md)
only to *repair* failures. The agent does not get to tick its own boxes.

## Stop condition

Every row in `QUALITY-GATE.md` is checked, with the command output saved or
summarized. Then you read the README as if you were the reviewer on a laptop
you have never seen.

## Do not

- Lower coverage by deleting tests that were awkward
- Disable the race detector because a test is flaky — that test is the finding
- Add Docker or CI at this stage to look complete. If it was out of scope in
  the spec, it stays out
