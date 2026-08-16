# 0. Crash course

## Goal

Enough vocabulary to review agent output. Not expertise. Not a portfolio in the
language.

If you cannot point at a wrong error wrap, a data race, or a handler that
swallows context, you are not ready to submit.

## What to cover

Match this list to the target language. The Go version is in the example.

1. How you declare types and zero values
2. How errors are returned, wrapped, and compared
3. How concurrency is expressed, and what is unsafe
4. How packages are organized, and what "idiomatic" means here
5. How tests are written (table tests, helpers, race detector)
6. How HTTP handlers are structured in the standard library or the chosen kit
7. The three or four ways this language is *not* your home language

You are not collecting trivia. You are collecting rejection tests: things you
will refuse if the agent emits them.

## How

Use the prompt in [`../kit/prompts/01-crash-course.md`](../kit/prompts/01-crash-course.md).
Sit with the agent as a tutor, not as a coder. Ask it to quiz you. Ask it to
show a bad snippet and a good snippet for each topic.

Write the rejection tests into `CLAUDE.md` under "Language bar". Those lines
become law for later phases.

## Stop condition

You can take an 80-line file in the target language and mark:

- one error-handling mistake
- one concurrency or ownership mistake
- one naming or package mistake
- one test smell

If you cannot do that without asking the agent "is this okay?", do not proceed.

## Do not

- Ask the agent to "teach me Go by building the take-home"
- Treat the crash course as optional because "the agent knows the language"
- Skip this step when the brief allows any language and you picked a new one
  on purpose
