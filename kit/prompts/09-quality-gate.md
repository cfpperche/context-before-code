# Prompt — quality gate (repair only)

You run `QUALITY-GATE.md` first. Use this prompt only for rows that failed.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, QUALITY-GATE.md, and skills/quality-gate/SKILL.md.

The following gate rows failed:

{{PASTE_FAILED_ROWS}}

Fix only what those rows require. Do not add features. Do not "improve"
package layout. Do not drop tests to raise coverage percentage by deletion
unless a test is invalid against the spec — if so, say so and stop.

Re-run the failed commands and report the new output.
```

## Gate (you)

- [ ] Every row in `QUALITY-GATE.md` is checked
- [ ] Coverage ≥ floor
- [ ] You can explain every ADR without the chat
- [ ] Commit: `chore: quality gate`
