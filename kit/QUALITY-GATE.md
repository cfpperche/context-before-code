# Quality gate

Run every row yourself. Paste output summaries. The agent does not tick boxes.

Coverage floor: **TODO%** — copy the number and the measuring command from
the test plan in `TECHSPEC.md`. If the spec does not state one, go back and
write it there first.

| # | Check | Command | Result | Notes |
| --- | --- | --- | --- | --- |
| 1 | Format | TODO e.g. `gofmt -l .` |  | empty list = pass |
| 2 | Vet / compile | TODO e.g. `go vet ./...` |  |  |
| 3 | Lint | TODO e.g. `staticcheck ./...` |  |  |
| 4 | Tests | TODO e.g. `go test -count=1 ./...` |  |  |
| 5 | Race / concurrency | TODO e.g. `go test -race -count=1 ./...` |  |  |
| 6 | Coverage | TODO e.g. `go test -coverprofile=cover.out ./... && go tool cover -func=cover.out \| grep total:` |  | must be ≥ floor |
| 7 | Exported docs | TODO — a **command** that exits non-zero on an undocumented export, not a sentence |  |  |
| 8 | README smoke | follow README on a clean shell |  |  |

## Sign-off

- Date:
- Suite: `_` tests, `_` failures, `_` skipped
- Coverage:
- I can explain every ADR without the chat log: yes / no
