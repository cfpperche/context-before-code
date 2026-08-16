# Bibliography

This routine does not rest on a personal anecdote. It composes published
methods. Each step maps to a method; the kit is the working file set.

## Methods, by step

| Step | Method | What we take from it |
| --- | --- | --- |
| 0 Crash course | Deliberate practice on a narrow skill (rejection tests, not coverage of the language) | Enough vocabulary to review output. Not expertise. |
| 1 Stack choice | Fit to the target runtime, not to the author's comfort | Confirm what the reviewers actually ship. |
| 2 Context file | Single source of constraints the agent must load | If a rule is only in chat, it does not exist. |
| 3 Research | Three-pass inquiry: market, large-org practice, this org | Later passes override earlier ones. Cite sources. |
| 4 Tech spec | Requirements specification with an explicit out-of-scope list | ISO/IEC/IEEE 29148-style: contract, invariants, exclusions. |
| 5 Phased implementation | Test-first, then one surface at a time | Red contract tests before models; a gate between phases. |
| 6 Decisions | Architecture Decision Records | One decision per file, including refusals. |
| 7 Quality gate | Definition of Done as an objective checklist | Format, static analysis, race, coverage, docs. Not "it runs". |

## Primary documents

- [ISO/IEC/IEEE 29148:2018](https://www.iso.org/standard/72089.html) — *Systems and software engineering — Life cycle processes — Requirements engineering*. Spec before construction; exclusions are part of the spec.
- [Architecture Decision Records](https://adr.github.io/) — one decision, context, consequences. Refusals belong here.
- [The Scrum Guide](https://scrumguides.org/scrum-guide.html) — Definition of Done as a shared, inspectable bar.
- [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) — HTTP semantics. Status codes describe the request, not a row inside a 200 body.
- [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html) — Problem Details for HTTP APIs. A published error shape; the example uses a smaller envelope on purpose (see the example research file).
- [Google API Improvement Proposals](https://google.aip.dev/) — resource layout, errors, pagination defaults used in research pass 1–2.
- Extreme Programming practices — **test-first** and **YAGNI**. Extra endpoints, databases, and CI that the brief does not score stay out.

## Stack documents (Go example)

Used in `examples/catalog-compare-api/RESEARCH.md` and the filled skills:

- [Effective Go](https://go.dev/doc/effective_go)
- [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
- [Go Race Detector](https://go.dev/doc/articles/race_detector)
- [Go blog: routing enhancements](https://go.dev/blog/routing-enhancements)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md) — error wrapping, as a large-org style document

## Where these methods disagree

They are not one school, and the routine does not pretend they are.

- **29148-style specification before construction vs XP's emergent design.**
  One says write the contract and the exclusions first; the other says the
  design is discovered by writing tests and code. This routine takes the spec
  from the first and the test-first cascade from the second, because the thing
  being controlled here is an agent, not a team: an agent will produce a whole
  service from a vague sentence in seconds, and the spec is the only artifact
  that makes the output reviewable. On a long-lived codebase with a human team,
  that trade looks different.
- **Definition of Done vs YAGNI.** A gate invites ceremony; YAGNI cuts it. The
  gate here only holds rows the brief scores, which is why "add CI so it looks
  official" is a refusal and not a row.
- **The time budget** in `method/README.md` is a heuristic from using this
  routine, not a finding from any document above. It is labelled as such
  there.

## What this file is not

A list of people. Cite the method or the document. If a source is a style
guide hosted on GitHub, cite the guide, not the authors.
