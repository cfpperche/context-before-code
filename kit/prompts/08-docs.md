# Prompt — documentation

Attach `skills/documentation`.

## Prompt

```
Read CLAUDE.md, TECHSPEC.md, adrs/, and skills/documentation/SKILL.md.

Current phase: docs. Document every exported/public symbol in the language's
idiom (godoc, docstrings, …).

Write or update README.md so a reviewer can:
- run the service
- run the tests, including race/coverage commands
- understand what is out of scope (link the ADRs)

Do not add architecture essays that repeat the ADRs. Link them.
Do not add badges, CI, or screenshots.
```

## Gate (you)

- [ ] Every exported symbol has a doc comment
- [ ] README has one-command test instructions
- [ ] Out-of-scope list is visible without opening the spec
- [ ] Commit: `docs: exported symbols and README`
