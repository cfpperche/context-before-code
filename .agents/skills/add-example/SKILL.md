---
name: add-example
description: >
  Add a filled language pack under examples/ for the Catalog Compare brief.
  Use when the user wants a Java, TypeScript, or other filled kit; a second
  language example; or runs /add-example.
---

# Add a filled example

Do not invent a second brief. Reuse `examples/catalog-compare-api/brief.md`.

## Layout

```
examples/<lang>-catalog-compare/
  README.md
  brief.md          # copy, note the language choice
  CLAUDE.md         # filled
  RESEARCH.md
  TECHSPEC.md
  QUALITY-GATE.md   # commands for this stack
  AGENTS.md         # pointer to CLAUDE.md (example packet, not repo rules)
  GROK.md
  adrs/             # same four decisions, restated for this stack
  skills/           # filled, no TODO left
```

Add a row to `examples/README.md`.

## Rules

- No application source.
- Same refusals (ADR 004) unless the language forces a different one.
- Gate commands must be real commands for that toolchain.
- Run `./scripts/gate.sh` when you are done.
