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
   required file to "simplify".
2. Live `kit/CLAUDE.md` (or AGENTS/GROK) — rename back to `*.md.tmpl`.
3. Forbidden pattern — remove the personal name or social host. Put
   method citations in `BIBLIOGRAPHY.md`.
4. `copy-kit.sh` — fix the script until a temp dest has `CLAUDE.md` and
   no `CLAUDE.md.tmpl`.

Do not weaken the forbidden list. Do not add exceptions for LICENSE;
the script already skips it.

Do not commit while the gate is red.
