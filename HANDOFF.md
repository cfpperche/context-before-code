# Handoff

Last session: rewrite as a working routine (methods + bibliography), remove
personal and social-origin citations, add Claude / Codex / Grok operator
files, publish a clean history.

Current state:

- Routine lives in `method/`
- Blank kit lives in `kit/` (`CLAUDE.md` / `AGENTS.md` / `GROK.md` are `.tmpl`)
- Filled example: `examples/catalog-compare-api/` (no Go code, by design)
- Operator source of truth: `AGENTS.md`
- Gate: `./scripts/gate.sh`

Not started in this tree: an implementation of Catalog Compare. That is a
separate working directory via `scripts/copy-kit.sh`.
