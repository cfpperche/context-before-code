# Prompts

Paste one file per phase. Do not combine them.

| File | Phase | Attach |
| --- | --- | --- |
| [01-crash-course.md](01-crash-course.md) | crash course | none |
| [02-research.md](02-research.md) | research | none |
| [03-techspec.md](03-techspec.md) | tech spec, then ADR drafts | none |
| [04-failing-tests.md](04-failing-tests.md) | failing tests | `skills/testing` |
| [05-models.md](05-models.md) | models | `idiomatic-code`, `data-layer` |
| [06-handlers.md](06-handlers.md) | handlers | `http-handlers`, `idiomatic-code` |
| [07-middleware.md](07-middleware.md) | middleware | `middleware` |
| [08-docs.md](08-docs.md) | docs | `documentation` |
| [09-quality-gate.md](09-quality-gate.md) | gate (repair only) | `quality-gate` |

Two steps of the method have no prompt on purpose:

- **Write context** (`CLAUDE.md`) is yours. If you cannot write the
  constraints, generating them defeats the point of the file.
- **Record decisions** happens in the tech-spec phase: the second prompt in
  `03-techspec.md` drafts the ADRs once you accept the spec.

Every gate in these files is run by you.
