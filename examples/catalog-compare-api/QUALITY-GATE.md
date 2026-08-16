# Quality gate

Run every row yourself. Paste output summaries. The agent does not tick boxes.

Coverage floor (defined in `TECHSPEC.md`, test plan): **70%** of statements
in package `catalog`.

| # | Check | Command | Result | Notes |
| --- | --- | --- | --- | --- |
| 1 | Format | `gofmt -l .` |  | empty list = pass |
| 2 | Vet / compile | `go vet ./...` |  |  |
| 3 | Lint | `staticcheck ./...` |  | install: `go install honnef.co/go/tools/cmd/staticcheck@latest` |
| 4 | Tests | `go test -count=1 ./...` |  |  |
| 5 | Race | `go test -race -count=10 ./...` |  | 10 runs: the race cases are probabilistic |
| 6 | Coverage | `go test -coverprofile=cover.out ./catalog/... && go tool cover -func=cover.out \| grep total:` |  | must be ≥ 70%; `cmd/catalogd` is excluded by the spec |
| 7 | Exported docs | `staticcheck -checks 'ST1000,ST1020,ST1021,ST1022' ./...` |  | exit 0 = every exported name is documented |
| 8 | README smoke | follow README on a clean shell |  |  |

## Sign-off

- Date:
- Suite: `_` tests, `_` failures, `_` skipped
- Coverage:
- I can explain every ADR without the chat log: yes / no

This example folder has no Go code yet, so the table is what you would run
in the **implementation** repository after phase 6. Do not expect these
commands to mean anything here.
