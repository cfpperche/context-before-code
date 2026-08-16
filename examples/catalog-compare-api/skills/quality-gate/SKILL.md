---
name: quality-gate
description: >
  Repair rules for a failed Catalog Compare quality gate. Use only when
  QUALITY-GATE.md has failing rows.
---

# Quality gate (Go)

## Commands

```sh
gofmt -l .
go vet ./...
staticcheck ./...
staticcheck -checks 'ST1000,ST1020,ST1021,ST1022' ./...
go test -count=1 ./...
go test -race -count=10 ./...
go test -coverprofile=cover.out ./catalog/... && go tool cover -func=cover.out | grep total:
```

Coverage floor: 70% of `catalog`, as defined in `TECHSPEC.md`. This file does
not get to hold a different number.

## Repair policy

- `gofmt -l` not empty → `gofmt -w .`
- `vet` / `staticcheck` → fix the diagnostic. No `//nolint` without an ADR
- Race → fix the store snapshot. Do not skip the test
- Coverage < 70% → add tests for uncovered *spec* branches (validation
  cases, envelope mapping). Do not delete tests. Do not test `main()`
  wallpaper
- Missing docs → add the comment. Do not unexport `Server` to dodge it

## Do not

- Add GitHub Actions so the gate "looks official"
- Drop the floor
- Introduce testify to make assertions shorter during repair
