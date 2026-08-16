---
name: operate-playbook
description: >
  Operate the context-before-code repository. Use when editing the routine,
  kit, example, bibliography, or agent files; when the user says playbook,
  method, kit, or "how this repo works"; or when running /operate-playbook.
---

# Operate the playbook

Read `AGENTS.md` first. Then `README.md` if you do not already know the
routine.

## You are editing a routine, not a service

- No application code in this tree.
- `kit/*.md.tmpl` are templates for a *copied* working tree.
- `examples/` is filled documentation.

## Edit map

| Change | Also touch |
| --- | --- |
| A method step | matching `kit/prompts/`, skill shell, filled example if it demonstrates that step |
| A kit template field | `examples/catalog-compare-api/` counterpart if that field is filled |
| Acceptance criteria language | `checklists/evaluator-criteria.md` |
| A cited method | `BIBLIOGRAPHY.md` only — not README prose |

## Citations

Methods and documents only. No personal names as origin. No social URLs.

## Before you finish

```sh
./scripts/gate.sh
```

Update `HANDOFF.md` if the session changed what the next agent should know.
