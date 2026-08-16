---
name: testing
description: >
  Contract tests for this take-home. Use in the failing-tests phase and when
  adding tests later. Tests encode the spec; they do not chase implementation.
---

# Testing ({{LANGUAGE}})

## Style

- Table-driven tests unless the language makes that ugly
- One behavior per case name
- Helpers for HTTP request/response, not for assertions that hide status codes
- TODO: how to name files and suites

## Contract tests must cover

Copy the test plan from `TECHSPEC.md`. Do not invent extra suites that the
evaluator criteria do not score.

## Fail for the right reason

Red means "behavior missing". Red does not mean "test does not compile"
or "imported a package we have not written on purpose without a stub".

## Concurrency

If the store is shared in-memory, include a test the race detector can catch
if the lock is removed.

## Do not

- Assert on log strings unless logs are in the contract
- Snapshot entire JSON blobs if one field is the behavior
- Use `sleep` to "wait for" handlers
- Mark tests skipped to go green
