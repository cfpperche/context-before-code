# Agent instructions

This file is the canonical instruction file for Claude Code, Codex, Grok, and
other agents. `CLAUDE.md` and `GROK.md` point here. Do not duplicate content
in those files.

## What this repository is

A **working routine** plus a copyable kit. It is not an application. There is
no service to implement in this tree.

Read `README.md` for the routine. Read `BIBLIOGRAPHY.md` for the methods.
Read `CONTRIBUTING.md` before you change shape.

## Hard rules

1. Do not implement the Catalog Compare API (or any other service) in this
   repository. Implementation belongs in a directory created by
   `scripts/copy-kit.sh`.
2. Do not cite people, social posts, or hiring anecdotes as the origin of
   this routine. Cite methods and documents. Put new citations in
   `BIBLIOGRAPHY.md`.
3. Do not add social-post URLs or personal attribution files.
4. `CLAUDE.md.tmpl`, `AGENTS.md.tmpl`, and `GROK.md.tmpl` under `kit/` and
   under an example packet are **templates for a copied working tree**. They
   are not operator rules for this repository — an agent that loaded them
   would start following a take-home's phase plan. `copy-kit.sh` renames the
   `kit/` ones to `CLAUDE.md` / `AGENTS.md` / `GROK.md` at the destination.
   The gate fails if a live agent filename appears inside an example packet.
5. Files under `examples/` are filled documentation. Do not turn them into
   an app.
6. One source of truth per fact. Do not copy the same rule into README,
   method, and a skill.
7. `site/` is the published wiki, not an exception to rule 1. It is a static
   Astro site that **renders** `method/`, `kit/`, `examples/` and
   `checklists/` through content collections; it must not restate a rule in
   its own words. Prose written directly in a page is limited to framing,
   captions, and the design notes. If a fact belongs to the routine, it lives
   in the repository markdown and the site reads it.

## How to work

- Edit the smallest set of files that keeps the cascade consistent
  (`method/` ↔ `kit/` ↔ `examples/` ↔ `checklists/`).
- If you change a phase, update its prompt, its skill shell, and the filled
  example when the example is about that phase.
- English only in repository text. Conventional Commits: `type(scope): subject`.
- Run `./scripts/gate.sh` before you commit. Do not commit if it fails.
- Do not push to `main` unless the owner asked for a publish. Prefer a branch
  and a pull request.
- Do not commit secrets.

## The wiki

```sh
cd site && npm install && npm run dev     # local
npm run build                             # dist/ + the Pagefind index
```

Published to GitHub Pages from `.github/workflows/deploy.yml` on every push to
`main`. Diagrams are hand-authored inline SVG components under
`site/src/components/diagrams/`; there is no diagramming library and no
client-side rendering. Design tokens and the benchmark notes live in
`site/src/styles/tokens.css` and the `/design/` page, which reads that file at
build time.

## Skills

Project skills live in `.agents/skills/` (also linked from `.claude/skills`
and `.grok/skills`).

| Skill | Use when |
| --- | --- |
| `operate-playbook` | Any edit to this repository |
| `add-example` | Adding a filled language pack |
| `run-gate` | Before commit, or when the user asks to check the repo |

## Gate

```sh
./scripts/gate.sh
```

It checks every method page, prompt, skill, checklist and example ADR; the
`.tmpl` naming in `kit/` and `examples/`; leftover kit placeholders in a
filled example; that internal markdown links resolve; the forbidden-term
list; and a copy-kit smoke run that must produce a working tree with its own
README and checklist.

Forbidden terms live in `scripts/forbidden-terms.txt` (structural bans, e.g.
social hosts). Personal names go in `scripts/forbidden-terms.local.txt`,
which is untracked: a committed denylist of names publishes the names.
