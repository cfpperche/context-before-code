# 3. Research

## Goal

Decisions with sources, written down *before* the spec. The agent is a
research assistant here. You still choose.

## Three passes, in this order

1. **Market.** How do public APIs of this shape look? Status codes, error
   envelopes, idempotency, comparison/diff resources, pagination defaults.
2. **Large-company practice.** How do mature engineering orgs solve the same
   problem when they are not trying to impress a take-home reviewer?
3. **This company.** Official docs, engineering blog, public GitHub, job
   descriptions, API style if they have one.

Pass 3 overrides pass 2, which overrides pass 1, which overrides the agent's
default taste.

## How

Use [`../kit/prompts/02-research.md`](../kit/prompts/02-research.md).
Require citations (URLs, doc titles). Reject "everyone does X" with no source.

After the three passes, you write a **Decisions** section. That section is the
only input the tech-spec prompt is allowed to treat as settled.

## What research is for

Research is how you avoid two failure modes:

- The agent emits a generic CRUD tutorial
- You over-build (real database, auth, Docker, CI, pagination) because that is
  what "serious" looks like in training data

## Stop condition

`RESEARCH.md` has:

- the three passes, each with sources
- a decisions list
- an explicit "still open" list (if something is still open, the spec must not
  pretend it is closed)

## Do not

- Let the agent write the spec in the same turn as the research
- Research after you have already generated handlers
- Treat a single blog post as "how the company does it"
