---
name: data-layer
description: >
  Persistence and concurrency rules for the take-home store. Use when
  implementing or reviewing the data layer.
---

# Data layer ({{LANGUAGE}})

## Store API

TODO: type name, methods, error values (`NotFound`, `Conflict`, …).

One concrete type until a second implementation exists. An interface with a
single implementation and no fake is surface you have to document and defend
for nothing. If the ADR says otherwise, the ADR wins — but it has to say it.

## In-memory rules (if that is the ADR)

- One mutex (or equivalent) per store, documented
- Lock discipline: TODO (RLock for reads, Lock for writes)
- Never return a live internal map or slice
- Copy on read
- Compare operates on snapshots, not on a map that can mutate mid-loop

## Do not

- Hide a database "to be ready for production"
- Use a global store
- Lock around HTTP encode
- Leak the mutex to handlers

## Tests that must exist

- Get missing → not found
- Upsert is idempotent on the same identity
- Concurrent upserts do not race (race detector clean)
