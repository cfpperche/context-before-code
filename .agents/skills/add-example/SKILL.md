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
  CLAUDE.md.tmpl    # filled
  RESEARCH.md
  TECHSPEC.md
  QUALITY-GATE.md   # commands for this stack
  AGENTS.md.tmpl    # pointer to CLAUDE.md, nothing duplicated
  GROK.md.tmpl
  adrs/             # same five decisions, restated for this stack
  skills/           # filled, no TODO left
```

The three agent files keep the `.tmpl` suffix: an agent operating the
playbook must not load an example packet as its own rules. The gate enforces
it, and it will also need the new ADR filenames added to its required list.

Add a row to `examples/README.md`.

## Rules

- No application source.
- Same refusals (spec out-of-scope table + ADR 004) unless the language
  forces a different one.
- Gate commands must be real commands for that toolchain — a row that reads
  as a sentence instead of a command is not filled.
- Every status the domain defines needs sample data that reaches it, and the
  spec's error table must cover what that stack's HTTP kit emits by default
  for an unknown route, a wrong method, and a timeout.
- Run `./scripts/gate.sh` when you are done.
