# Context Before Code

A working routine for small greenfield work with an AI coding agent.

Write context, research, and a spec before any implementation prompt. Use it
for a take-home, a spike, or a one-day service. The routine is the product.
The kit is just the files that make the routine executable.

## The thesis

An agent does not know what you want if you cannot explain what you want.
Explaining well takes experience. That experience has to become files the
agent is required to read.

If the agent does not know what will be scored, it optimizes for the wrong
thing.

## The routine

| Step | Artifact | Stop condition |
| --- | --- | --- |
| 0. Crash course | notes in `CLAUDE.md` | You can read ~80 lines of the target language and say if they are wrong |
| 1. Choose the stack | one paragraph in `CLAUDE.md` | The runtime the reviewers actually use is confirmed |
| 2. Write context | `CLAUDE.md` | Acceptance criteria are written as primary vs secondary |
| 3. Research | `RESEARCH.md` | Market, large-org, and *this* org notes exist, plus decisions |
| 4. Tech spec | `TECHSPEC.md` | Contract, domain, realistic data, and an explicit out-of-scope list |
| 5. Implement in phases | prompts + skills | Each phase has a prompt, a skill, and a gate before the next |
| 6. Record decisions | `adrs/` | Every non-obvious choice, including what you refused to build |
| 7. Quality gate | `QUALITY-GATE.md` | Format, static analysis, race detector, coverage, docs on exported symbols |

Do not open the solution tree until steps 0–4 exist as files. Do not paste an
implementation prompt until the spec is written.

The methods this sequence instantiates are listed in [BIBLIOGRAPHY.md](BIBLIOGRAPHY.md).

## How to use

```sh
git clone git@github.com:cfpperche/context-before-code.git
cd context-before-code
./scripts/copy-kit.sh ~/work/acme-takehome
cd ~/work/acme-takehome
```

Then walk [`method/`](method/README.md) in order. Fill `CLAUDE.md` before you
paste a single implementation prompt.

Read [`examples/catalog-compare-api/`](examples/catalog-compare-api/README.md)
to see a filled kit. That example is invented for this repository.

## Repository map

```
method/      why each step exists, and what "done" means
kit/         blank files you copy (agent templates are *.md.tmpl)
examples/    one filled kit for a fictional Catalog Compare API in Go
checklists/  before-you-open-the-repo, evaluator criteria, what not to build
scripts/     copy-kit.sh, gate.sh
```

Agents that operate *this* repository read [`AGENTS.md`](AGENTS.md).

## Rules that are not optional

1. **Follow the brief you were given.** If the brief forbids AI, do not use this kit.
2. **Crash course first.** If you cannot review the output, you cannot submit it.
3. **Do not claim fluency you do not have.** Using this kit in Go does not make you a Go engineer.
4. **Judgment is the product.** A reviewer can still ask why the compare endpoint returns per-item status, why there is no database, and what you would change in week two. If you cannot answer, the packet failed.

## What this is not

- A prompt that says "build me an API"
- A completed service you can turn in
- Advice to hide AI use
- A substitute for architecture experience. Empty templates do not write the constraints.

## License

Apache-2.0. See [LICENSE](LICENSE).
