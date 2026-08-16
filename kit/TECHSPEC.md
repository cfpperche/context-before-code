# Tech spec

Source of truth for implementation phases. If code and this file disagree,
this file wins until an ADR changes it.

## Purpose

TODO: one paragraph.

## Domain model

### Types

TODO: name, fields, invariants.

### Sample data

Realistic rows, not `foo` / `bar`. Reviewers read fixtures.

```
TODO
```

### Invariants

- TODO

## HTTP contract

Base URL: `TODO`

| Method | Path | Request | Success | Failure |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

### Error envelope

```json
{
  "error": {
    "code": "TODO",
    "message": "TODO",
    "request_id": "TODO"
  }
}
```

### Compare / special resources

TODO: if a resource returns per-item status instead of one HTTP status, say so
here and point at the ADR.

## Persistence and concurrency

- Store:
- Concurrency:
- Process lifetime:

## Test plan

The failing-tests phase must encode at least:

1. TODO (happy path)
2. TODO (validation)
3. TODO (not found)
4. TODO (compare / invariant)
5. TODO (concurrency, if the store is in-memory)

## Out of scope

| Item | Why it stays out |
| --- | --- |
| Real database | TODO |
| Auth | TODO |
| Docker / CI | TODO |
| Pagination / sorting | TODO |
| Extra endpoints | TODO |

## Traceability

- Primary evaluator criteria this spec serves:
- ADRs that close decisions:
