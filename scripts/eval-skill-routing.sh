#!/usr/bin/env bash
# Static eval: skill descriptions cover routing triggers (discovery hygiene).
# Does not call an LLM. Pure bash (no python).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="$ROOT/.claude/skills"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; FAIL=1; }

desc_of() {
  grep -E '^description:' "$SKILLS/$1/SKILL.md" | sed 's/^description:[[:space:]]*//' | head -n1
}

contains_ci() {
  # $1 haystack, $2 needle — case insensitive
  local hay="$1" needle="$2"
  local hay_l needle_l
  hay_l=$(printf '%s' "$hay" | tr '[:upper:]' '[:lower:]')
  needle_l=$(printf '%s' "$needle" | tr '[:upper:]' '[:lower:]')
  [[ "$hay_l" == *"$needle_l"* ]]
}

check_case() {
  local id="$1" expected="$2"
  shift 2
  local desc
  desc="$(desc_of "$expected")"
  local t
  for t in "$@"; do
    if [[ "$t" == "--" ]]; then break; fi
    if contains_ci "$desc" "$t"; then
      :
    else
      bad "$id: $expected missing trigger: $t"
      return
    fi
  done
  ok "$id → $expected triggers"
}

check_anti() {
  local id="$1" anti="$2"
  shift 2
  local desc
  desc="$(desc_of "$anti")"
  local t
  for t in "$@"; do
    if contains_ci "$desc" "$t"; then
      :
    else
      bad "$id: $anti missing anti-needle: $t"
      return
    fi
  done
  ok "$id anti via $anti"
}

echo "== skill routing eval (static) =="

# Cases mirrored from evals/routing-cases.yml — keep in sync.
check_case entry-new-project shipjaw "/shipjaw" "nouveau projet Shipjaw"
check_anti entry-new-project shipjaw-ask "knowledge-base"

check_case prompt-vague-idea shipjaw-prompt "idée vague" "source-prompt.md"
check_anti prompt-vague-idea shipjaw-build "knowledge-base"

check_case build-greenfield shipjaw-build "greenfield" "source-prompt.md"
check_anti build-greenfield shipjaw-ask "knowledge-base"

check_case adopt-legacy shipjaw-adopt "adopter Shipjaw" "legacy Next"
check_anti adopt-legacy shipjaw-build "greenfield"

check_case ask-continue-fr shipjaw-ask "reprendre le projet" "ajouter une feature"
check_anti ask-continue-fr shipjaw-build "greenfield"

check_case ask-after-compact shipjaw-ask "resume after compact" "INDEX.md"
check_anti ask-after-compact shipjaw-prompt "knowledge-base"

check_case upgrade-stamps shipjaw-upgrade "upgrade Shipjaw" "scaffolded-with"
check_anti upgrade-stamps shipjaw-ask "shipjaw-upgrade"

check_case challenge-plan shipjaw-challenge "challenge this plan" "contester ce plan"
check_anti challenge-plan shipjaw-ask "shipjaw-challenge"

if [[ "$FAIL" -ne 0 ]]; then
  echo "eval-skill-routing FAILED"
  exit 1
fi
echo "eval-skill-routing PASSED"
