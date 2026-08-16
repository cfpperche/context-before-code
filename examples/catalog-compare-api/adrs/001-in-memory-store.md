# ADR 001: In-memory store

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

The brief says in-memory storage is acceptable and the service will not be
deployed. A database would dominate the timebox and is not a primary score.

## Decision

Keep products in process memory behind a `Store` interface with one
in-memory implementation. Protect the map with `sync.RWMutex`. Copy slices
and structs on read. Compare works on two snapshots taken under `RLock`.

## Alternatives

- SQLite or Postgres — real durability, zero score, extra moving parts
- A global `var store = map[...]` — races and untestable handlers
- Channel-serialized "actor" store — correct, heavier than a mutex for this

## Consequences

- Good: tests are fast; race detector is meaningful; crash-course bar is
  enough to review the locking
- Bad: data dies with the process; two instances do not share state
- Follow-up we are explicitly *not* doing: a second implementation of `Store`

## Not in this decision

Schema, migrations, transactions, TTL.
