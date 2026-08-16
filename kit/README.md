# Kit

Copy this directory into a new working tree. Do not clone this whole
repository as the submission. The playbook is not the delivery.

`CLAUDE.md.tmpl`, `AGENTS.md.tmpl`, and `GROK.md.tmpl` are named so agents
operating *this* repository do not load them as project rules.
`copy-kit.sh` renames them to `CLAUDE.md`, `AGENTS.md`, and `GROK.md` at
the destination.

```sh
# from the playbook root
./scripts/copy-kit.sh ~/work/acme-takehome
```

## Fill order

1. `CLAUDE.md` — after the crash course and the stack decision
2. `RESEARCH.md` — three passes, then decisions
3. `TECHSPEC.md` — contract, domain, out of scope
4. `adrs/` — one file per decision, starting at `001-…`
5. `skills/` — replace every `TODO` with target-language law
6. `prompts/` — only if you must adapt a filename or a gate command
7. `QUALITY-GATE.md` — commands for this stack

`AGENTS.md` and `GROK.md` stay as pointers. Do not fork the rules into them.

## What you submit

Whatever the brief asked for. Usually the service repo, not this kit's
unfilled templates. Keep `CLAUDE.md`, `TECHSPEC.md`, `adrs/`, and the
quality-gate notes in the submission if the company asked you to use AI:
they are evidence of judgment.

If the company forbade AI, you should not have copied this kit.
