# ADR 002: Flat package

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

Four routes, one store, one binary, one day. Layered layouts (`internal/
handler`, `internal/service`, `internal/repo`) read as seniority theatre on a
surface this small and fight the language bar ("no stutter, no
`models/models.go`").

## Decision

One package `catalog` for domain, store, handlers, and middleware. `cmd/catalogd`
is a thin `main` that calls `catalog.Server()`.

## Alternatives

- `cmd` + `internal/{domain,http,store}` — fine at 20 files; we will not
  have 20 files
- Hexagonal ports and adapters — the `Store` interface is the only port we
  need; it can live next to the memory implementation

## Consequences

- Good: reviewers see the whole design without a tree tour
- Bad: the package will need a split if this became a real service
- Follow-up we are explicitly *not* doing: pre-emptive `internal/` split

## Not in this decision

Module path. Use `github.com/example/catalog` until the candidate's GitHub
path is known.
