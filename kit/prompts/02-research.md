# Prompt — research

`CLAUDE.md` must already have the brief, the stack, and the evaluator criteria.

## Prompt

```
Read CLAUDE.md. Do not write TECHSPEC.md. Do not write code.

Research this take-home in three passes. Write RESEARCH.md using the template
already in the repo.

Pass 1 — market: how public APIs of this shape look (resources, errors,
compare/diff semantics, status codes, idempotency). Cite URLs.

Pass 2 — large-company practice: how a mature org would solve the same
problem without performing for a reviewer. Cite URLs or named docs.

Pass 3 — this company: official docs, style guides, public repos, engineering
blog, job posts. Cite URLs. If pass 3 conflicts with 1 or 2, pass 3 wins and
you must say so.

End with:
- Decisions (settled, each with "because")
- Still open (must not be treated as settled)

Do not recommend a database, auth, Docker, CI, or pagination unless the brief
or this company's public practice makes them mandatory. Prefer the smallest
design that serves the primary evaluator criteria.
```

## Gate (you)

- [ ] Each pass has at least one real source
- [ ] Decisions do not include items still listed as open
- [ ] You edited the Decisions section. The agent drafted, you accepted
