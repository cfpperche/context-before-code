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

### Media types and body rules

Answer all four. A second engineer cannot write the tests without them.

- Response content type:
- Required request content type, and what a wrong one returns:
- Unknown fields in a request body: rejected or ignored?
- Body size cap, and what exceeding it returns:

### Response shapes

- Single resource:
- Collection:
- Errors: the envelope below, and nothing else

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

Fill the table for every response the service can emit, including the ones
your HTTP kit writes by default:

| Situation | HTTP | code |
| --- | --- | --- |
| Validation | TODO | TODO |
| Not found (resource) | TODO | TODO |
| Unknown route | TODO | TODO |
| Wrong method on a known path | TODO | TODO |
| Body too large | TODO | TODO |
| Unsupported content type | TODO | TODO |
| Server timeout | TODO | TODO |
| Panic / unknown | TODO | TODO |

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
4. TODO (compare / invariant — one case per domain status you defined)
5. TODO (the error rows your HTTP kit would otherwise answer in plain text)
6. TODO (concurrency, if the store is in-memory)

Coverage floor: **TODO%**, measured with `TODO`. This is where the number is
defined; `QUALITY-GATE.md` copies it.

## Out of scope

This table is the single list. The ADR that records the refusal policy points
here instead of repeating the rows.

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
