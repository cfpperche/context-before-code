# ADR 003: Compare returns HTTP 200 with per-item status

- Status: accepted
- Date: 2026-03-31
- Phase: techspec

## Context

A naïve reading of "report missing / price_diff" is to return 409 or 404
when the catalogs are not identical. That collapses four item outcomes into
one request outcome and makes the happy-path test ("I compared these two
names") look like a failure.

Market practice (GitHub compare, JSON Patch) keeps HTTP status about the
request and puts the diff in the body.

## Decision

`GET /compares?left=&right=` returns **200** whenever the query is valid.
Each item has a `status` field. Differences are data, not errors.

Invalid source IDs or missing query params are 400. The compare itself does
not 404.

## Alternatives

- 409 when any item is not `match` — unusable: every interesting compare
  would be a "failure"
- 200 only on all-`match`, 409 otherwise — same problem, plus clients must
  parse two shapes
- 404 if either source has zero products — treats "empty extract" as
  missing resource; buyers will compare against an empty ours during onboarding

## Consequences

- Good: error handling stays reserved for actual errors; tests are stable
- Bad: a sloppy reviewer skimming status codes may think we ignored diffs
  (README must say this in one sentence)
- Follow-up we are explicitly *not* doing: a `?strict=true` that 409s

## Not in this decision

Item sort order (spec already says sku ascending). Priority when price *and*
name differ (spec already says price_diff wins).
