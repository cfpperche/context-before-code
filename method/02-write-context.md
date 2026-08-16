# 2. Write context

## Goal

A single file the agent reads before every task. If a constraint is only in
your head, it does not exist.

## What goes in `CLAUDE.md`

Use [`../kit/CLAUDE.md.tmpl`](../kit/CLAUDE.md.tmpl). Fill every section. The
ones that matter most:

1. **What this is** — one paragraph, no vision speech
2. **Stack** — language, HTTP kit, store, test runner, forbidden libraries
3. **Evaluator criteria** — primary vs secondary, copied from the brief
4. **Language bar** — rejection tests from the crash course
5. **Hard constraints** — timebox, no auth, no Docker, in-memory OK, etc.
6. **Definition of done** — what "submit" means
7. **How the agent is allowed to work** — phases, no extra files, no
   drive-by refactors

If the agent does not know what will be scored, it optimizes for what does
not matter. Copy *your* brief. Do not copy the example's primary list.

## Agent entry files

After `CLAUDE.md` is filled:

- `AGENTS.md` and `GROK.md` only point at it
- Do not maintain three copies of the same rules

Different tools look at different filenames. The pointers exist so you do not
care which tool you opened.

## Stop condition

An agent that can only see the repo (no chat history) would know:

- what to build
- what not to build
- what "good" means for the person grading it
- which phase it is allowed to work on

## Do not

- Write a novel. One screen per section is plenty
- Put the API contract in `CLAUDE.md` (that belongs in `TECHSPEC.md`)
- Soften criteria ("tests are nice") when the brief said they are primary
