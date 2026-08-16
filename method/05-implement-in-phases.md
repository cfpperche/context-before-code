# 5. Implement in phases

## Goal

Code that follows the spec, one surface at a time, with a human gate between
surfaces.

## Default cascade (small project)

This is test-first, then one surface at a time. Keep the cascade for a
small project.

1. **Failing tests** — the contract, all red
2. **Models / domain + store** — tests for the domain start to go green
3. **HTTP handlers** — contract tests go green
4. **Middleware** — request ID, recover, log, limits
5. **Documentation** — exported symbols, README
6. **Quality gate** — the checklist, not "it runs"

Each phase has a prompt in `kit/prompts/` and a skill in `kit/skills/`.
The prompt names the skill, the files the agent may touch, and the gate.

## Rules for every phase

- One phase, one prompt. Do not combine "models and handlers" to save a turn.
- The agent does not change tests from a later-looking phase unless the spec
  was wrong. If the spec was wrong, you edit the spec first and record an ADR.
- You run the gate. You do not ask the agent "are we good?"
- Commits are per phase. Each commit should be readable as a story:
  `test: contract for compare is red`, then `feat: in-memory catalog store`.

## Tests first means tests first

The first implementation prompt writes tests that fail for the right reason
(not found, compile-missing type, assertion on the error envelope). If they
fail because the test file does not compile due to sloppiness, that is not a
red suite. Fix the tests until they are honest red. Then move.

## Stop condition

You only enter the next phase when the current gate in the prompt file is
green. The last implementation phase hands off to [Quality gate](07-quality-gate.md).

## Do not

- Say "build the API" and hope the skills file saves you
- Let the agent add a router framework, an ORM, or a CI workflow that the spec
  did not name
- Rewrite passing tests to match sloppy handlers
