# What not to build

Default refusals for a one-day HTTP take-home. Delete a row if the brief
asked for it. Every kept row becomes a line in ADR 004.

| Item | Usual excuse | Why it is still a refusal |
| --- | --- | --- |
| Real database | "They should see I can do persistence" | Not scored; eats the test and error budget |
| Auth | "Production APIs have auth" | Hides the envelope behind a token |
| Docker / Compose | "Reproducible" | Reviewer has Go or the named toolchain |
| CI workflow | "Professional" | Gate is a local checklist |
| Pagination | "Lists must scale" | Marginal until fixtures are huge |
| Sorting knobs | "Buyers will want it" | Compare already needs one stable order |
| Extra endpoints | "While I'm here" | Dilutes the contract tests |
| Router / ORM / testify | "Everyone uses X" | Extra surface you must defend in a language you just crashed-coursed |
| CSV / file upload | "The buyer pastes a file" | Brief is an HTTP product API unless it says otherwise |

If you feel guilty, write the refusal. Do not build the feature to soothe
the guilt.
