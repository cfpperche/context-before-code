# Before you open the solution repository

Tick these before the first implementation prompt. If one is empty, you are
still in preparation.

- [ ] Crash-course rejection tests are in `CLAUDE.md`
- [ ] Stack decision is written, with a reason
- [ ] AI policy of the brief is known (allowed / required / forbidden)
- [ ] If forbidden, stop. Do not use this kit
- [ ] Primary evaluator criteria are copied from the brief, not from memory
- [ ] `RESEARCH.md` has three passes and a Decisions section you accepted
- [ ] `TECHSPEC.md` has a contract table, sample data, and an out-of-scope table
- [ ] The spec answers content type, unknown fields, body cap, unknown route,
      wrong method, and timeout — not just the happy paths
- [ ] Every state your domain can report has sample data that reaches it
- [ ] The coverage floor is a number in the spec
- [ ] ADRs 001+ exist for persistence, layout, status policy, and refusals
- [ ] Skills have no remaining `TODO` in the sections you will attach
- [ ] Phase prompts are in the working tree
- [ ] `CLAUDE.md` current phase is `failing-tests`, not `not-started`

Only then: open the module and paste the failing-tests prompt
(`prompts/04-failing-tests.md` in the working tree).
