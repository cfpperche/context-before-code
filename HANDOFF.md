# Handoff

Last session: adversarial review of the whole tree, then the fixes it found.

Current state:

- Routine lives in `method/`
- Blank kit lives in `kit/` (`CLAUDE.md` / `AGENTS.md` / `GROK.md` are `.tmpl`)
- Filled example: `examples/catalog-compare-api/` (no Go code, by design).
  Its three agent files are now `.tmpl` too, so an agent working in this
  repository cannot load a take-home's phase plan as its own rules
- Operator source of truth: `AGENTS.md`
- Gate: `./scripts/gate.sh`

What the review changed, in case it looks surprising:

- `AGENTS.md` and `GROK.md` are pointers everywhere, in the kit and in the
  example. The rules live in `CLAUDE.md` only, which is what `method/02`
  always said
- The spec template and the example now cover what an HTTP kit emits by
  default (unknown route, wrong method, over-sized body, timeout), media
  types, and unknown JSON fields. Those were the holes that made the example
  fail its own "a second engineer could write the tests from this" bar
- The example fixtures reach all five compare statuses; `field_diff` had no
  fixture and no test
- ADR 001 dropped the single-implementation `Store` interface; ADR 005 is new
  (an unknown source is an empty source). ADR 004 no longer keeps a second
  copy of the out-of-scope table
- The coverage floor is defined in the spec and copied by the gate file, not
  the other way round
- `scripts/gate.sh` now checks every method page, prompt, skill, checklist and
  example ADR, the `.tmpl` naming, leftover placeholders, and internal links.
  The old one could pass with `method/` deleted
- Forbidden terms moved to `scripts/forbidden-terms.txt`; personal names go in
  the untracked `scripts/forbidden-terms.local.txt`. Note that git history
  before this change still contains the old list

Not started in this tree: an implementation of Catalog Compare. That is a
separate working directory via `scripts/copy-kit.sh`.
