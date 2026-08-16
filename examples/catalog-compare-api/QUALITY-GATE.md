# Quality gate

Run every row yourself. Paste output summaries. The agent does not tick boxes.

Coverage floor (from spec): **70%**

| # | Check | Command | Result | Notes |
| --- | --- | --- | --- | --- |
| 1 | Format | `gofmt -l .` |  | empty list = pass |
| 2 | Vet / compile | `go vet ./...` |  |  |
| 3 | Lint | `staticcheck ./...` |  | install: `go install honnef.co/go/tools/cmd/staticcheck@latest` |
| 4 | Tests | `go test -count=1 ./...` |  |  |
| 5 | Race | `go test -race -count=1 ./...` |  |  |
| 6 | Coverage | `go test -cover ./...` |  | must be ≥ 70% |
| 7 | Exported docs | every exported name in `catalog` has a doc comment |  | `Server`, `Store`, `Memory`, `Product`, error vars |
| 8 | README smoke | follow README on a clean shell |  |  |

## Sign-off

- Date:
- Suite: `_` tests, `_` failures, `_` skipped
- Coverage:
- I can explain every ADR without the chat log: yes / no

This example folder has no Go code yet, so the table is what you would run
in the **implementation** repository after phase 6. Do not expect these
commands to mean anything here.
