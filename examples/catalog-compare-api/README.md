# Example — Catalog Compare API (Go)

A **filled** kit for a fictional take-home. There is no service implementation
in this folder on purpose. Read these files as the packet you would finish
*before* the first `func Test`.

The brief is invented so `kit/` is not a folder of empty `TODO`s.

## Story we are pretending

Language-free take-home. The employer runs Go and Java. Primary scores:
error handling, tests, documentation. Last real Go was years ago. Go is
still the stack choice. Fluency is not the claim; the packet is.

## Read in this order

1. [`brief.md`](brief.md) — the assignment
2. [`CLAUDE.md.tmpl`](CLAUDE.md.tmpl) — what the agent is required to know
3. [`RESEARCH.md`](RESEARCH.md) — three passes and the decisions
4. [`TECHSPEC.md`](TECHSPEC.md) — the contract
5. [`adrs/`](adrs/) — in-memory store, flat package, per-item compare,
   refusals, unknown source
6. [`skills/`](skills/) — Go law for each phase
7. [`QUALITY-GATE.md`](QUALITY-GATE.md) — the checklist you will run later

`CLAUDE.md`, `AGENTS.md`, and `GROK.md` carry a `.tmpl` suffix here for the
same reason they do in `kit/`: they are a *filled example* of a working
tree's rules, and an agent operating this playbook must not load them as its
own instructions. In a real working tree they have their live names.

Then go back to [`../../kit/prompts/`](../../kit/prompts/) and run the phases
against a **new** directory. Do not turn this example folder into the app.
