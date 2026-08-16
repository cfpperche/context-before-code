# Evaluator criteria

The agent will optimize whatever you write here. Copy the brief. Do not
copy the example.

## Primary (replace if your brief differs)

| Criterion | How this kit makes it visible |
| --- | --- |
| Error handling | Envelope in the spec; mapping table in the HTTP skill; 500 does not leak |
| Tests | Test plan in the spec; red-first phase; race row in the gate |
| Documentation | Docs phase; godoc / equivalent on every export; ADRs |

## Secondary

Write the ones the brief hinted at. Do not invent a cleanliness rubric the
reviewer did not name.

| Criterion | Allowed to spend time? |
| --- | --- |
| Package structure | Only as far as one ADR |
| Concurrency | Yes, if the store is in-memory |
| Performance | No, unless the brief has numbers |

## Hidden rubrics you will not chase

- Dockerfile
- Kubernetes
- 90% coverage when you wrote 70%
- A blog-quality architecture essay

If a reviewer grades those silently, the packet still did its job: it served
the criteria they printed.
