#!/usr/bin/env bash
# Copy the blank kit into a new working directory.
# Usage: ./scripts/copy-kit.sh DEST
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:-}"

if [[ -z "${dest}" ]]; then
  echo "usage: $0 DEST" >&2
  exit 2
fi

if [[ -e "${dest}" ]] && [[ -n "$(ls -A "${dest}" 2>/dev/null || true)" ]]; then
  echo "refusing to copy into a non-empty path: ${dest}" >&2
  exit 1
fi

mkdir -p "${dest}"
cp -R "${root}/kit/." "${dest}/"

# kit/README.md documents the kit for a reader of the playbook. The working
# tree gets its own README below, so remove the copy instead of shipping two.
rm -f "${dest}/README.md"

# Templates are *.md.tmpl in the playbook so root agents do not load them.
# A copied working tree needs the real names.
for name in CLAUDE AGENTS GROK; do
  if [[ -f "${dest}/${name}.md.tmpl" ]]; then
    mv "${dest}/${name}.md.tmpl" "${dest}/${name}.md"
  fi
done

mkdir -p "${dest}/adrs"

# The checklist is ticked while you work, so it travels with the working tree.
cp "${root}/checklists/before-you-open-the-repo.md" "${dest}/CHECKLIST.md"

playbook_commit="unknown"
if command -v git >/dev/null 2>&1 && git -C "${root}" rev-parse --short HEAD >/dev/null 2>&1; then
  playbook_commit="$(git -C "${root}" rev-parse --short HEAD)"
fi

cat > "${dest}/README.md" <<EOF
# Working tree

Copied from context-before-code.

- Playbook: \`${root}\`
- Playbook commit: \`${playbook_commit}\`
- The method pages (\`method/\`) live in the playbook, not here. Keep that
  directory open beside this one.

## Fill order

1. \`CLAUDE.md\` — after the crash course and the stack decision
2. \`RESEARCH.md\` — three passes, then decisions
3. \`TECHSPEC.md\` — contract, domain, out of scope, coverage floor
4. \`adrs/\` — one file per decision, starting at \`001-…\`
5. \`skills/\` — replace every \`TODO\` with target-language law
6. \`prompts/\` — only if you must adapt a filename or a gate command
7. \`QUALITY-GATE.md\` — commands for this stack

\`AGENTS.md\` and \`GROK.md\` stay as pointers to \`CLAUDE.md\`. Do not fork
the rules into them.

## Before the first implementation prompt

Tick \`CHECKLIST.md\`. Then paste \`prompts/04-failing-tests.md\`.

Do not ask the agent to "build the API" in one shot.

## What you submit

Whatever the brief asked for — usually the service, with this packet linked
from its README as supporting material.

If the brief forbids AI, do not point an agent at this tree. The routine is
still yours to run by hand.
EOF

if command -v git >/dev/null 2>&1 && ! git -C "${dest}" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "${dest}" init -q
  echo "initialized a git repository (phase commits are part of the routine)"
fi

echo "copied kit -> ${dest}"
echo "next: fill CLAUDE.md; do not open an implementation prompt yet"
