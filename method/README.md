# Method

This is the working routine. Walk the steps in order. Each page names the
file you produce and the condition that lets you continue.

Do not skip ahead because the agent "can just start coding". The whole point is
that the agent will start coding the moment you let it.

| # | Page | You produce |
| --- | --- | --- |
| 0 | [Crash course](00-crash-course.md) | Vocabulary notes in `CLAUDE.md` |
| 1 | [Choose the stack](01-choose-the-stack.md) | One written language decision |
| 2 | [Write context](02-write-context.md) | `CLAUDE.md` the agent must read first |
| 3 | [Research](03-research.md) | `RESEARCH.md` |
| 4 | [Tech spec](04-techspec.md) | `TECHSPEC.md` |
| 5 | [Implement in phases](05-implement-in-phases.md) | Code, one phase at a time |
| 6 | [Record decisions](06-record-decisions.md) | `adrs/*.md` |
| 7 | [Quality gate](07-quality-gate.md) | A signed-off `QUALITY-GATE.md` |

Copy the blank files from [`../kit/`](../kit/README.md). Use
[`../examples/catalog-compare-api/`](../examples/catalog-compare-api/README.md)
as the picture of "filled enough".

## The shape of a phase

Every implementation phase uses the same loop:

1. Attach the skill for that phase.
2. Paste the prepared prompt. Do not improvise a new one mid-flight.
3. The agent may only touch files named in that prompt.
4. You run the validation gate yourself.
5. If the gate fails, you stay in the phase. You do not "fix it later".

For a small take-home, a cascade is correct: tests → models → handlers →
middleware → docs → gate. Parallel work is how the packet rots.

## Time

Budget most of the clock *before* the first passing test. A common split on an
8-hour take-home:

| Block | Hours |
| --- | --- |
| Crash course + stack decision | 1.0 |
| Context, research, spec, ADRs, prompts | 2.5–3.5 |
| Implementation phases | 3.0–4.0 |
| Quality gate + README pass | 0.5–1.0 |

This split is a working heuristic, not something the methods in
[`../BIBLIOGRAPHY.md`](../BIBLIOGRAPHY.md) prescribe. Treat it as a starting
budget and adjust it to your brief.

If you invert this (code first, docs later), you are vibe coding with extra
files.
