---
name: data-layer
description: >
  In-memory catalog store rules. Use when implementing or reviewing the
  data layer.
---

# Data layer (Go)

## Store API

One concrete type. No interface — there is one implementation and the tests
use it directly (ADR 001).

```go
type Memory struct {
    mu   sync.RWMutex
    data map[string]map[string]Product // source -> sku -> product
}

func NewMemory() *Memory
func (m *Memory) Upsert(ctx context.Context, p Product) error
func (m *Memory) Get(ctx context.Context, source, sku string) (Product, error)
func (m *Memory) List(ctx context.Context, source string) ([]Product, error)
```

`List` is the snapshot. Compare calls it twice; there is no separate
`Snapshot` method for the same bytes.

Sentinels: `ErrNotFound`, `ErrInvalid`.

## In-memory rules

- `NewMemory()` allocates the outer map
- `RLock` on Get/List; `Lock` on Upsert
- Get returns a copy of the struct (value, not pointer into the map)
- List returns a new slice of values, sorted by sku so callers are stable
- Compare: `left, _ := store.List(ctx, leftSrc)`, same for right, then diff
  **without** the lock
- Never return `m.data` or an inner map

## Do not

- An interface "for later" (ADR 001) or a second implementation
- `sync.Map` (harder to snapshot consistently)
- Lock in `compare.go` around the diff
- Hold the lock while encoding JSON

## Tests that must exist

- Get missing → `ErrNotFound`
- Upsert same `(source, sku)` replaces fields
- List of an unknown source → empty slice, no error (ADR 005)
- Concurrent upserts: `-race` clean
