---
name: documentation
description: >
  Docs rules for Catalog Compare. Exported symbols and a reviewer-grade
  README. ADRs stay in adrs/.
---

# Documentation (Go)

## Code

Every exported name gets a comment that starts with that name:

```go
// Server returns an HTTP handler for the catalog compare API.
func Server(store *Memory) http.Handler
```

Required comments: `Server`, `Memory`, `NewMemory`, `Product`, `CompareItem`,
`CompareStatus`, `ErrNotFound`, `ErrInvalid`.

Unexported helpers stay silent unless the algorithm is non-obvious
(compare status priority).

## README must include

- Five lines: what it is, Go version, stdlib only
- `go test -race -count=1 ./...`
- `go test -coverprofile=cover.out ./... && go tool cover -func=cover.out`
- `go run ./cmd/catalogd`
- One sentence on ADR 003 (compare is 200 + per-item status)
- One sentence on ADR 005 (an empty diff can mean an unknown source)
- Bullet list of what we refused, linking ADR 004
- Links to `TECHSPEC.md` and `adrs/`

## Do not

- Architecture novels
- CI badges
- "Powered by Claude"
- Generated static sites
