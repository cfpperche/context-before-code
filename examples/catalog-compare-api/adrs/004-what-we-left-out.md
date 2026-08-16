# ADR 004: What we left out

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

Primary scores are error handling, tests, and documentation. Training data
will push a database, Docker, CI, auth, and pagination because that is what
"a real service" looks like. Each of those steals clock from the things that
are actually scored.

## Decision

Refusal is the default. Anything the brief did not ask for and the printed
criteria do not score stays out, and the refusal is written down instead of
being built "just in case".

The list itself lives in one place: the **Out of scope** table in
`TECHSPEC.md`. This ADR is the policy and the argument; it does not keep a
second copy of the rows. When we refuse something new, it goes in the spec
table and, if the reasoning is not obvious, gets its own ADR.

## Alternatives

- Build them "just in case the reviewer expects production" — that is how
  take-homes become unreviewable
- Mention them as TODOs in the README — reads as unfinished, not as refused

## Consequences

- Good: the packet is small enough to read; refusals are visible
- Bad: a reviewer who grades with a hidden "has Dockerfile" rubric will
  ding us; we accept that
- Follow-up we are explicitly *not* doing: a "next steps" essay longer than
  five lines

## Not in this decision

Quality-gate tools (`gofmt`, `vet`, `staticcheck`, `-race`) are in scope.
They are how we prove tests and error handling, not extra product.
