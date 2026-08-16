---
name: idiomatic-code
description: >
  Go language bar for the Catalog Compare take-home. Use when writing or
  reviewing domain, store, or handler code.
---

# Idiomatic code (Go)

## Do

- Return `error`. Wrap with `fmt.Errorf("get %s/%s: %w", source, sku, err)`.
- Sentinel vars at package level: `var ErrNotFound = errors.New("not found")`.
  Compare with `errors.Is`.
- `context.Context` is the first argument on store methods that could block.
  The memory store still accepts it so the signature survives a later impl.
- MixedCaps. File names are lowercase: `store.go`, `handler.go`, `compare.go`.
- Doc comments are sentences that start with the name.
- Pass the concrete `*Memory`. Interfaces are for a caller that has two
  things to pass; we have one (ADR 001).

## Do not

- Panic on request paths. `Must` helpers are forbidden outside `main`.
- `if err != nil { return nil }` — never drop the error.
- `log.Fatal` inside handlers or the store.
- Stutter: `catalog.CatalogStore`, `catalog.NewCatalog`.
- `any` / `interface{}` for JSON when a struct exists.
- Third-party packages.

## Review checklist

- [ ] Every error that leaves a public function is wrapped or is a sentinel
- [ ] No package-level `var products = map...`
- [ ] No premature interfaces: every interface here has two implementations
      or a fake in a test. Today that means zero interfaces
- [ ] Package is `catalog` (ADR 002)
