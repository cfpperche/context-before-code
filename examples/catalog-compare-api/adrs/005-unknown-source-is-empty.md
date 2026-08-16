# ADR 005: An unknown source is an empty source

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

Sources are created by writing to them. There is no registry, no
`POST /sources`, and no list-of-sources endpoint. So the service cannot tell
`supplier-a` (typed correctly, nothing uploaded yet) from `suplier-a`
(typo).

That matters more here than it looks. The whole product is a comparison, and
the failure is silent: `GET /compares?left=ours&right=suplier-a` answers 200
with `items: []`, which a buyer reads as "the catalogs agree".

## Decision

An unknown source behaves as an empty source. List returns `[]`, compare
returns 200 with `items: []`.

The compare response echoes the two names it used (`left`, `right`) so the
caller can see what was actually compared, and the README says in one line
that an empty result may mean an empty source.

## Alternatives

- 404 when a source has no products — breaks onboarding, where you compare a
  supplier file against an `ours` you have not uploaded yet (this is the case
  ADR 003 already refused)
- A registry of known sources (`PUT /sources/{source}`) — a second resource,
  a second contract, and validation state to keep; the brief asked for four
  operations
- `warnings: ["left source is empty"]` in the compare body — cheap and honest.
  Rejected only because it adds a field the brief did not name and the tests
  would then have to pin its wording. First thing to add in week two

## Consequences

- Good: no state to bootstrap; the four endpoints stay closed over their own
  contract; onboarding compares work
- Bad: a typo returns a confident empty diff. We accept it for one day and say
  so out loud
- Follow-up we are explicitly *not* doing: a sources registry

## Not in this decision

Whether `left` and `right` may name the same source (they may; every row is
`match`).
