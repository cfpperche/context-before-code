---
name: data-layer
description: >
  In-memory catalog store rules. Use when implementing or reviewing the
  data layer.
---

# Data layer (Go)

## Store API

```go
type Store interface {
    Upsert(ctx context.Context, p Product) error
    Get(ctx context.Context, source, sku string) (Product, error)
    List(ctx context.Context, source string) ([]Product, error)
    Snapshot(ctx context.Context, source string) ([]Product, error)
}
```

`List` and `Snapshot` may be the same implementation. Keep both names only
if compare wants to say "I am taking a snapshot" in the call.

Sentinels: `ErrNotFound`, `ErrInvalid`.

## In-memory rules

- `type Memory struct { mu sync.RWMutex; data map[string]map[string]Product }`
- `NewMemory() *Memory` allocates the outer map
- `RLock` on Get/List/Snapshot; `Lock` on Upsert
- Get returns a copy of the struct (value, not pointer into the map)
- List/Snapshot return a new slice of values
- Compare: `left := Snapshot(leftSrc); right := Snapshot(rightSrc)` then
  diff **without** the lock
- Never return `m.data` or an inner map

## Do not

- A second implementation "for later"
- `sync.Map` (harder to snapshot consistently)
- Lock in `compare.go` around the diff
- Hold the lock while encoding JSON

## Tests that must exist

- Get missing → `ErrNotFound`
- Upsert same `(source, sku)` replaces fields
- Concurrent upserts: `-race` clean
