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

We will not build:

| Item | Why |
| --- | --- |
| Real database | Brief allows in-memory. Persistence is not scored. |
| Auth | Not asked. A token in front of the envelope hides the error signal. |
| Docker / CI | Not asked. Reviewer runs `go test ./...`. |
| Pagination / list sort | Marginal. Compare already sorts. |
| DELETE / PATCH / POST | PUT upsert covers the brief. |
| CSV upload | Brief is an HTTP product API, not a file pipeline. |
| Router, ORM, testify | Crash-course bar is stdlib. Extra kits add surface we cannot defend. |

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
