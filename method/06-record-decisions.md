# 6. Record decisions

## Goal

A short ADR for every choice a reviewer might poke. Especially the things you
did not build.

## When to write them

Draft ADRs as soon as the spec is stable, *before* handlers exist. Fill in
consequences after the gate if they changed.

Do not wait until Friday night to invent reasons for an in-memory map.

## What always deserves an ADR on a take-home

- Persistence (in-memory vs database)
- Package layout (flat vs layered)
- Error and status-code policy (one HTTP status vs per-item status)
- What you left out: auth, Docker, CI, pagination, sorting, real clock, etc.

An ADR that only lists what you built is incomplete. Documenting what you
chose *not* to do shows you know the trade-off (YAGNI, plus the ADR method
on [adr.github.io](https://adr.github.io/)).

## Shape

Use [`../kit/adrs/000-template.md`](../kit/adrs/000-template.md). The drafting
prompt is the second block of
[`../kit/prompts/03-techspec.md`](../kit/prompts/03-techspec.md) — ADRs are
written in the tech-spec phase, not in a phase of their own.

Keep each ADR to one decision. "We kept the design simple" is not a decision.

The refusal ADR records the *policy* and the argument. The list of refused
items lives in the spec's out-of-scope table. Two copies drift, and the drift
is what a reviewer notices.

## Stop condition

A reviewer can read `adrs/` and know why the obvious "production" pieces are
missing, without asking you on a call.

## Do not

- Write ADRs that only restate the spec
- Use ADRs to hide missing tests
- Number them after the fact in random order
