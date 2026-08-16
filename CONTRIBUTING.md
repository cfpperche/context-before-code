# Contributing

This repository is a working routine, not an application.

Useful contributions:

- Tighter stop conditions in `method/`
- Better validation gates in `kit/prompts/`
- A new *filled* language pack under `examples/` (not an empty template)
- Fixes that make a file something you can paste into an agent today
- Bibliography entries that are methods or documents, not personal citations

Not useful:

- Generic "best practices" with no stop condition
- A second fictional brief that repeats Catalog Compare
- Implementing the example API inside this repo
- Anecdotes, social posts, or named-person origin stories

## Agent workflow

Read `AGENTS.md`. Run `./scripts/gate.sh` before you commit.

Open a pull request against `main`. Keep the English direct. Match the
existing file shape: short sections, checklists, explicit "do not proceed if".
