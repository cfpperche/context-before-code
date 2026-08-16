# Project context

Read this file before any task. If a later file conflicts with this one, stop
and ask. Do not expand scope.

## What this is

A one-day take-home HTTP API: ingest two product catalogs and compare them
per SKU. Reviewers will read errors, tests, and docs first. They will not
deploy this.

## Stack

- Language: Go 1.22+
- HTTP: `net/http` (stdlib only)
- Store: in-memory, process-local
- Test runner: `go test`
- Forbidden libraries: routers, ORMs, log frameworks, UUID libs, testify
- Allowed libraries: standard library only

## Why this stack

The brief is language-free. The company runs Go and Java. Go is the closer
fit for a small HTTP service and matches what every team there ships. AI is
allowed. Home language is TypeScript; last real Go was 2015. We are not
submitting TypeScript because the evaluator's daily stack is not TypeScript.

## Evaluator criteria

Primary (optimize these):

1. Error handling
2. Tests
3. Documentation

Secondary (do not sacrifice a primary for these):

- Package structure
- API taste
- Concurrency safety of the in-memory store

## Language bar (rejection tests)

- Errors: return `error`, wrap with `%w`, do not panic on request paths, do
  not stringify and lose the type
- Concurrency: no map write without the store mutex; never range a live map
  the handler can still mutate
- Naming / packages: one flat package `catalog` (see ADR 002); no
  `models/models.go`; mixedCaps; no stutter (`catalog.CatalogStore`)
- Tests: table-driven; `httptest`; `-race` must be clean; no `time.Sleep`

## Hard constraints

- Timebox: one working day
- Persistence: in-memory, lost on process exit
- Auth: none
- Deploy / Docker / CI: none
- Dependencies: standard library only

## Out of scope (preview)

Full list and reasons: `TECHSPEC.md` and `adrs/004-what-we-left-out.md`.
No database, auth, Docker, CI, pagination, sorting, or extra endpoints.

## How the agent may work

- Do not write implementation code until `TECHSPEC.md` exists and the current
  phase prompt says so.
- One phase per turn. Touch only the files the phase prompt names.
- Do not add dependencies.
- Do not refactor passing phases "while here".
- If the spec is wrong, stop. Propose a spec edit. Do not silently patch code.

## Current phase

`techspec` (accepted). Next: `failing-tests`.

## Definition of done

- `QUALITY-GATE.md` is fully checked
- README tells a reviewer how to run tests in one command
- You can explain every ADR without opening the agent chat
