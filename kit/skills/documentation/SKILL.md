---
name: documentation
description: >
  Docs rules for the take-home. Use in the docs phase. Exported symbols and
  a reviewer-grade README. ADRs stay in adrs/.
---

# Documentation ({{LANGUAGE}})

## Code

- Every exported / public symbol has a doc comment in the language idiom
- TODO: the exact comment shape (sentence starting with the name, …)
- Do not narrate what the next line does

## README must include

- What the service does in five lines
- How to run tests (including race and coverage)
- How to run the server
- Link to `TECHSPEC.md` and `adrs/`
- Out of scope, copied short from the spec

## Do not

- Architecture novels
- Generated godoc sites
- CI badges
- "Powered by AI" unless the brief asked you to disclose
