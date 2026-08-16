#!/usr/bin/env bash
# Repository gate for context-before-code (the playbook, not a take-home).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "${root}"
fail=0

note() { printf '%s\n' "$*"; }
die() { printf 'FAIL %s\n' "$*"; fail=1; }
ok() { printf 'OK   %s\n' "$*"; }

# ---------------------------------------------------------------- structure

required=(
  README.md
  AGENTS.md
  CLAUDE.md
  GROK.md
  BIBLIOGRAPHY.md
  CONTRIBUTING.md
  HANDOFF.md
  LICENSE
  method/README.md
  kit/README.md
  kit/CLAUDE.md.tmpl
  kit/AGENTS.md.tmpl
  kit/GROK.md.tmpl
  kit/RESEARCH.md
  kit/TECHSPEC.md
  kit/QUALITY-GATE.md
  kit/adrs/000-template.md
  kit/prompts/README.md
  kit/skills/README.md
  checklists/before-you-open-the-repo.md
  checklists/evaluator-criteria.md
  checklists/what-not-to-build.md
  examples/README.md
  examples/AGENTS.md
  examples/catalog-compare-api/README.md
  examples/catalog-compare-api/brief.md
  examples/catalog-compare-api/RESEARCH.md
  examples/catalog-compare-api/TECHSPEC.md
  examples/catalog-compare-api/QUALITY-GATE.md
  scripts/copy-kit.sh
  scripts/forbidden-terms.txt
  site/package.json
  site/package-lock.json
  site/astro.config.mjs
  site/src/content.config.ts
  site/src/styles/tokens.css
  .github/workflows/deploy.yml
)

# The routine is the product: every step page, prompt, and skill is required.
for n in 00-crash-course 01-choose-the-stack 02-write-context 03-research \
         04-techspec 05-implement-in-phases 06-record-decisions 07-quality-gate; do
  required+=("method/${n}.md")
done

for n in 01-crash-course 02-research 03-techspec 04-failing-tests 05-models \
         06-handlers 07-middleware 08-docs 09-quality-gate; do
  required+=("kit/prompts/${n}.md")
done

skills=(idiomatic-code testing data-layer http-handlers middleware documentation quality-gate)
for s in "${skills[@]}"; do
  required+=("kit/skills/${s}/SKILL.md")
  required+=("examples/catalog-compare-api/skills/${s}/SKILL.md")
done

for n in 001-in-memory-store 002-flat-package 003-compare-status-per-item \
         004-what-we-left-out 005-unknown-source-is-empty; do
  required+=("examples/catalog-compare-api/adrs/${n}.md")
done

missing=0
for f in "${required[@]}"; do
  [[ -f "${f}" ]] || { die "missing ${f}"; missing=1; }
done
if [[ "${missing}" -eq 0 ]]; then ok "all ${#required[@]} required files exist"; fi

# Project skills, and the per-tool symlinks that expose them.
for d in .agents/skills/operate-playbook .agents/skills/add-example .agents/skills/run-gate; do
  [[ -f "${d}/SKILL.md" ]] || die "missing ${d}/SKILL.md"
done
for link in .claude/skills .grok/skills; do
  if [[ -L "${link}" && -d "${link}" ]]; then
    ok "${link} resolves"
  else
    die "${link} must be a symlink to ../.agents/skills"
  fi
done

# ---------------------------------------------------------------- templates

# Live agent filenames must not exist inside kit/ or inside an example packet:
# an agent operating this repository would load them as its own rules.
for name in CLAUDE AGENTS GROK; do
  if [[ -e "kit/${name}.md" ]]; then
    die "kit/${name}.md must be kit/${name}.md.tmpl"
  else
    ok "kit/${name}.md is templated"
  fi
done

while IFS= read -r hit; do
  die "${hit} must carry a .tmpl suffix (agents load it as project rules)"
done < <(find examples -mindepth 2 \( -name CLAUDE.md -o -name AGENTS.md -o -name GROK.md \) 2>/dev/null)
ok "example packets carry .tmpl agent files"

# A filled example with an unfilled field is not an example.
if grep -rn -e 'TODO:' -e '| TODO' examples/ >/dev/null 2>&1; then
  die "examples/ still contains kit placeholders"
  grep -rn -e 'TODO:' -e '| TODO' examples/
else
  ok "no placeholders left in examples/"
fi

# ---------------------------------------------------------------- links

broken=0
while IFS= read -r -d '' file; do
  dir="$(dirname "${file}")"
  while IFS= read -r target; do
    case "${target}" in http*|mailto:*|'') continue ;; esac
    target="${target%%#*}"
    [[ -z "${target}" ]] && continue
    if [[ ! -e "${dir}/${target}" ]]; then
      die "broken link in ${file}: ${target}"
      broken=1
    fi
  done < <(grep -o '](\([^)]*\))' "${file}" 2>/dev/null | sed 's/^](//; s/)$//')
done < <(find . \( -path ./.git -o -path '*/node_modules' -o -path '*/dist' -o -path '*/.astro' \) -prune \
  -o \( -name '*.md' -o -name '*.tmpl' \) -print0)
if [[ "${broken}" -eq 0 ]]; then ok "internal markdown links resolve"; fi

# ---------------------------------------------------------------- forbidden

# Structural bans live in scripts/forbidden-terms.txt (tracked). An operator
# may add a private list in scripts/forbidden-terms.local.txt, which is
# untracked on purpose: a denylist of personal names publishes the very names
# it exists to keep out of the repository.
search() {
  local pattern="$1"
  if command -v rg >/dev/null 2>&1; then
    rg -n --hidden -g '!.git' -g '!LICENSE' -g '!scripts/forbidden-terms*' -i -e "${pattern}" . || true
  else
    grep -RIni --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist \
      --exclude-dir=.astro --exclude=LICENSE --exclude='forbidden-terms*' -e "${pattern}" . || true
  fi
}

forbidden=()
for list in scripts/forbidden-terms.txt scripts/forbidden-terms.local.txt; do
  [[ -f "${list}" ]] || continue
  while IFS= read -r line; do
    [[ -z "${line}" || "${line}" == \#* ]] && continue
    forbidden+=("${line}")
  done < "${list}"
done

if [[ "${#forbidden[@]}" -eq 0 ]]; then
  die "no forbidden patterns loaded (scripts/forbidden-terms.txt)"
fi

dirty=0
for pat in "${forbidden[@]}"; do
  hits="$(search "${pat}")"
  if [[ -n "${hits}" ]]; then
    die "forbidden pattern /${pat}/"
    printf '%s\n' "${hits}"
    dirty=1
  fi
done
if [[ "${dirty}" -eq 0 ]]; then ok "no forbidden patterns (${#forbidden[@]} checked)"; fi

# ---------------------------------------------------------------- copy-kit

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
  for f in README.md CHECKLIST.md TECHSPEC.md prompts/04-failing-tests.md skills/testing/SKILL.md; do
    [[ -f "${tmp}/takehome/${f}" ]] || die "copy-kit did not produce ${f}"
  done
  grep -q 'Fill order' "${tmp}/takehome/README.md" \
    || die "copy-kit README lost the fill order"
else
  die "copy-kit.sh failed"
fi

if [[ "${fail}" -ne 0 ]]; then
  note "gate failed"
  exit 1
fi
note "gate passed"
