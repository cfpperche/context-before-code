---
name: run-gate
description: >
  Run the playbook repository gate. Use before every commit, after editing
  method/kit/example files, when the user asks if the repo is clean, or
  when they run /run-gate.
---

# Run the gate

```sh
./scripts/gate.sh
```

If it fails:

1. Missing file — restore it from git or recreate it. Do not delete a
   required file to "simplify". If you deliberately added or removed a
   method page, prompt, skill, or example ADR, update the lists in
   `scripts/gate.sh` in the same commit.
2. Live `CLAUDE.md` (or AGENTS/GROK) under `kit/` or an example packet —
   rename back to `*.md.tmpl`.
3. Placeholders left in `examples/` — a filled example has no `TODO:` and no
   `| TODO` rows.
4. Broken link — fix the path; do not delete the link.
5. Forbidden pattern — remove the social host or personal name. Put method
   citations in `BIBLIOGRAPHY.md`.
6. `copy-kit.sh` — fix the script until a temp dest has `CLAUDE.md`, no
   `CLAUDE.md.tmpl`, a `README.md` with the fill order, and `CHECKLIST.md`.

Do not weaken the forbidden list. Do not add exceptions for LICENSE;
the script already skips it. Personal patterns belong in the untracked
`scripts/forbidden-terms.local.txt`, never in the tracked list.

Do not commit while the gate is red.
