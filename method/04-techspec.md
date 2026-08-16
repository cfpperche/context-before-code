# 4. Tech spec

## Goal

A contract the implementation phases are not allowed to invent around.

## What goes in `TECHSPEC.md`

Use [`../kit/TECHSPEC.md`](../kit/TECHSPEC.md).

- Domain model (types, invariants, realistic sample data)
- HTTP contract (paths, methods, request/response bodies, status codes)
- Error envelope
- Concurrency and persistence assumptions
- Test plan (what the first failing tests will assert)
- **Out of scope**, with a reason for each item
- Open questions that will become ADRs if you close them

Two things most specs skip, and this routine does not:

1. Why each decision was taken
2. What did not go in, and why

ISO/IEC/IEEE 29148 treats exclusions as part of the specification.
Documenting the refusal is the seniority signal. Database, Docker, CI, auth,
pagination, and sorting are the usual refusals on a small brief. Only refuse
them if the brief did not ask and the acceptance criteria do not reward them.

## Order

Research file exists → you accept or edit the Decisions section → only then
run the tech-spec prompt.

You review the spec as an architect. The agent drafted it. You own it.

## Stop condition

You can implement from this file without asking a new product question.
A second engineer could write the failing tests from the contract section
alone.

Prepare the phase prompts now, while you still have the spec in your head.
Do not wait until you are mid-code to invent the next prompt.

## Do not

- Leave example payloads as `// ...`
- Hide out-of-scope items in a footnote
- Add "nice to have" endpoints "while we are here"
