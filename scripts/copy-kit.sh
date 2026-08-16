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

# Templates are *.md.tmpl in the playbook so root agents do not load them.
# A copied working tree needs the real names.
for name in CLAUDE AGENTS GROK; do
  if [[ -f "${dest}/${name}.md.tmpl" ]]; then
    mv "${dest}/${name}.md.tmpl" "${dest}/${name}.md"
  fi
done

mkdir -p "${dest}/adrs"

cat > "${dest}/README.md" <<'EOF'
# Working tree

Copied from context-before-code.

1. Walk the method in the playbook (`method/`) — not this folder.
2. Fill `CLAUDE.md` before any implementation prompt.
3. Do not ask the agent to "build the API" in one shot.

When the brief forbids AI, delete this tree and stop.
EOF

echo "copied kit -> ${dest}"
echo "next: fill CLAUDE.md; do not open an implementation prompt yet"
