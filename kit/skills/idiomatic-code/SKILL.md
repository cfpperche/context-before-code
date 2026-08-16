---
name: idiomatic-code
description: >
  Language-bar for this take-home. Use when writing or reviewing domain,
  store, or handler code. Reject snippets that fail the crash-course tests.
---

# Idiomatic code ({{LANGUAGE}})

## Do

- TODO: error style (wrap, sentinel vs typed, what the caller sees)
- TODO: naming (files, types, packages)
- TODO: comments (when, on what)
- TODO: context / cancellation (first arg? required on I/O?)
- TODO: packages (flat vs layered — must match the ADR)

## Do not

- TODO: the crash-course rejection tests, copied here as hard bans
- Panic in request paths
- Swallow errors
- Add a dependency that is not in `CLAUDE.md`

## Review checklist

- [ ] Errors match the language bar in `CLAUDE.md`
- [ ] No package-level mutable state unless the data-layer skill allows it
- [ ] No premature interfaces
