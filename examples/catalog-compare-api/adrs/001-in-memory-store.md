# ADR 001: In-memory store

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

The brief says in-memory storage is acceptable and the service will not be
deployed. A database would dominate the timebox and is not a primary score.

## Decision

Keep products in process memory in one concrete type, `*Memory`. Protect the
map with `sync.RWMutex`. Copy slices and structs on read. Compare works on
two snapshots taken under `RLock`.

No `Store` interface. There is one implementation, the tests use it directly,
and the language bar in `CLAUDE.md` bans premature interfaces. An interface
with a single implementation and no fake is a seam we would have to defend
without being able to say what is on the other side of it.

## Alternatives

- SQLite or Postgres — real durability, zero score, extra moving parts
- A global `var store = map[...]` — races and untestable handlers
- Channel-serialized "actor" store — correct, heavier than a mutex for this
- `Store` interface + `Memory` implementation — the shape we would want on
  day 30. On day 1 it is one caller, one implementation, and a doc comment we
  have to write for an abstraction nobody asked for. `Server` takes `*Memory`;
  extracting the interface later is a mechanical change

## Consequences

- Good: tests are fast; race detector is meaningful; crash-course bar is
  enough to review the locking
- Bad: data dies with the process; two instances do not share state
- Bad: handlers name a concrete type, so a future second backend touches
  `Server`'s signature. Accepted: that edit is smaller than the interface we
  would carry until then
- Follow-up we are explicitly *not* doing: a second store backend

## Not in this decision

Schema, migrations, transactions, TTL.
