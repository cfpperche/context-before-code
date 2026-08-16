# Prompt — crash course

Use after you have picked a target language. Do not attach implementation
skills. Do not open the solution files.

## Prompt

```
I need a crash course in {{LANGUAGE}}. I am not building the take-home yet.

My home language is {{HOME_LANGUAGE}}. I last wrote {{LANGUAGE}} in {{WHEN}}.

Teach only what I need in order to review agent output for a small HTTP API:

1. types and zero values
2. error return, wrap, and compare
3. concurrency and what is unsafe
4. package layout and naming
5. tests (table tests, helpers, race or equivalent)
6. HTTP handlers in the standard library or the default kit
7. the four sharpest differences from {{HOME_LANGUAGE}}

For each topic: 15 lines of good code, 15 lines of bad code, and a one-line
rejection test I can paste into CLAUDE.md.

Then quiz me with four short snippets. Wait for my answers. Do not write any
file from the take-home.
```

## Gate (you)

- [ ] Four rejection tests are written under "Language bar" in `CLAUDE.md`
- [ ] You marked four snippets without asking "is this okay?"
- [ ] No take-home file was created
