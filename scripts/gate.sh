#!/usr/bin/env bash
# Repository gate for context-before-code (the playbook, not a take-home).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "${root}"
fail=0

note() { printf '%s\n' "$*"; }
die() { printf 'FAIL %s\n' "$*"; fail=1; }
ok() { printf 'OK   %s\n' "$*"; }

required=(
  README.md
  AGENTS.md
  CLAUDE.md
  GROK.md
  BIBLIOGRAPHY.md
  CONTRIBUTING.md
  LICENSE
  method/README.md
  kit/README.md
  kit/CLAUDE.md.tmpl
  kit/AGENTS.md.tmpl
  kit/GROK.md.tmpl
  examples/catalog-compare-api/TECHSPEC.md
  scripts/copy-kit.sh
)

for f in "${required[@]}"; do
  if [[ -f "${f}" ]]; then
    ok "exists ${f}"
  else
    die "missing ${f}"
  fi
done

# Templates must not use the live agent filenames inside kit/.
for name in CLAUDE AGENTS GROK; do
  if [[ -e "kit/${name}.md" ]]; then
    die "kit/${name}.md must be kit/${name}.md.tmpl"
  else
    ok "kit/${name}.md is templated"
  fi
done

# Forbidden origin stories and social hosts. Skip LICENSE (Apache boilerplate).
# rg is preferred; fall back to grep -R.
search() {
  local pattern="$1"
  if command -v rg >/dev/null 2>&1; then
    rg -n --hidden -g '!.git' -g '!LICENSE' -g '!scripts/gate.sh' -g '!*.git/*' -i -e "${pattern}" . || true
  else
    grep -RIn --exclude-dir=.git --exclude=LICENSE --exclude=gate.sh -e "${pattern}" . || true
  fi
}

forbidden=(
  'Bruno'
  'Bertolini'
  'brunobertolini'
  'x\.com'
  'twitter\.com'
  't\.co/'
)

for pat in "${forbidden[@]}"; do
  hits="$(search "${pat}")"
  if [[ -n "${hits}" ]]; then
    die "forbidden pattern /${pat}/"
    printf '%s\n' "${hits}"
  else
    ok "no /${pat}/"
  fi
done

# copy-kit smoke
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT
if ./scripts/copy-kit.sh "${tmp}/takehome" >/dev/null; then
  for name in CLAUDE AGENTS GROK; do
    if [[ -f "${tmp}/takehome/${name}.md" && ! -f "${tmp}/takehome/${name}.md.tmpl" ]]; then
      ok "copy-kit produced ${name}.md"
    else
      die "copy-kit did not produce ${name}.md"
    fi
  done
else
  die "copy-kit.sh failed"
fi

if [[ "${fail}" -ne 0 ]]; then
  note "gate failed"
  exit 1
fi
note "gate passed"
