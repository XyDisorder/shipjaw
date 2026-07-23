#!/usr/bin/env bash
# LLM eval: does a real model route paraphrased prompts to the right skill?
# Unlike eval-skill-routing.sh (substring match, offline, deterministic),
# this calls `claude -p` with the skill catalog + a realistic user message
# that avoids the literal trigger words, and checks the model's answer.
# Slower, costs a real API call, non-deterministic — run before a skill
# release, not on every commit.
#
# Cases mirrored from evals/routing-cases.yml (`prompt` field) — keep in sync.
#
# Run: ./scripts/eval-skill-routing-llm.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="$ROOT/.claude/skills"
MODEL="${EVAL_MODEL:-haiku}"
FAIL=0

if ! command -v claude >/dev/null 2>&1; then
  echo "SKIP: claude CLI not found on PATH"
  exit 0
fi

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; FAIL=1; }

desc_of() {
  grep -E '^description:' "$SKILLS/$1/SKILL.md" | sed 's/^description:[[:space:]]*//' | head -n1
}

build_catalog() {
  local name
  for name in shipjaw shipjaw-adopt shipjaw-ask shipjaw-build shipjaw-challenge shipjaw-prompt shipjaw-upgrade; do
    printf -- '- %s: %s\n' "$name" "$(desc_of "$name")"
  done
}

CATALOG="$(build_catalog)"

classify() {
  local user_message="$1"
  local classify_prompt
  classify_prompt="$(cat <<EOF
You are a routing classifier. Given the list of available skills below
(name: description), decide which single skill would be invoked for the
user message. Reply with ONLY the skill name (or "none" if no skill fits)
— no explanation, no punctuation.

Skills:
${CATALOG}

User message: "${user_message}"
EOF
)"
  claude -p "$classify_prompt" --model "$MODEL" --allowedTools "" < /dev/null 2>/dev/null \
    | tr -d '\r' | tr '[:upper:]' '[:lower:]' | xargs
}

check_case() {
  local id="$1" expected="$2" anti="$3" prompt="$4"
  local got
  got="$(classify "$prompt")"
  if [[ "$got" == "$expected" ]]; then
    ok "$id → $expected (got: $got)"
  elif [[ "$got" == "$anti" ]]; then
    bad "$id: routed to anti_skill $anti instead of $expected"
  else
    bad "$id: expected $expected, got '$got'"
  fi
}

echo "== skill routing eval (LLM, model=$MODEL) =="

check_case entry-new-project shipjaw shipjaw-ask \
  "Je veux démarrer un tout nouveau projet avec Shipjaw, j'ai encore aucun dossier ni code, juste besoin d'un point de départ propre."

check_case prompt-vague-idea shipjaw-prompt shipjaw-build \
  "J'ai juste un brouillon d'idée dans la tête pour une appli, rien de concret encore, tu peux m'aider à structurer ça avant qu'on code quoi que ce soit ?"

check_case build-greenfield shipjaw-build shipjaw-ask \
  "Mon brief produit est prêt et détaillé, on peut lancer le scaffold complet de l'appli maintenant."

check_case adopt-legacy shipjaw-adopt shipjaw-build \
  "Mon app a été codée par un pote avant que je connaisse Shipjaw, je veux que ce soit maintenant dans les clous du framework."

check_case ask-continue-fr shipjaw-ask shipjaw-build \
  "On reprend le projet de la semaine dernière, il me faut un filtre supplémentaire sur la liste."

check_case ask-after-compact shipjaw-ask shipjaw-prompt \
  "Nouvelle session après un compact, où est-ce que j'en étais sur cette appli déjà scaffoldée ?"

check_case upgrade-stamps shipjaw-upgrade shipjaw-ask \
  "Le skill a changé de version depuis la dernière fois, je veux juste remettre mes docs à jour, je n'ajoute pas de feature aujourd'hui."

check_case challenge-plan shipjaw-challenge shipjaw-ask \
  "Avant qu'on implémente cette phase un peu lourde, je veux un vrai avis contradictoire écrit sur le plan, pas juste une relecture rapide."

if [[ "$FAIL" -ne 0 ]]; then
  echo "eval-skill-routing-llm FAILED"
  exit 1
fi
echo "eval-skill-routing-llm PASSED"
