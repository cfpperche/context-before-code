# Quality gate

Run every row yourself. Paste output summaries. The agent does not tick boxes.

Coverage floor (from spec): **TODO%**

| # | Check | Command | Result | Notes |
| --- | --- | --- | --- | --- |
| 1 | Format | TODO e.g. `gofmt -l .` |  | empty list = pass |
| 2 | Vet / compile | TODO e.g. `go vet ./...` |  |  |
| 3 | Lint | TODO e.g. `staticcheck ./...` |  |  |
| 4 | Tests | TODO e.g. `go test -count=1 ./...` |  |  |
| 5 | Race / concurrency | TODO e.g. `go test -race -count=1 ./...` |  |  |
| 6 | Coverage | TODO e.g. `go test -cover ./...` |  | must be ≥ floor |
| 7 | Exported docs | TODO e.g. grep for undocumented exports |  |  |
| 8 | README smoke | follow README on a clean shell |  |  |

## Sign-off

- Date:
- Suite: `_` tests, `_` failures, `_` skipped
- Coverage:
- I can explain every ADR without the chat log: yes / no
