#!/usr/bin/env bash
# Structural smoke check for shipjaw / shipjaw-prompt / shipjaw-build /
# shipjaw-adopt / shipjaw-ask.
# Run from repo root: ./scripts/smoke-check.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL="$ROOT/.claude/skills/shipjaw-build"
ASK="$ROOT/.claude/skills/shipjaw-ask"
PROMPT="$ROOT/.claude/skills/shipjaw-prompt"
ADOPT="$ROOT/.claude/skills/shipjaw-adopt"
ENTRY="$ROOT/.claude/skills/shipjaw"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; FAIL=1; }

echo "== skill layout =="
for f in \
  "$ENTRY/SKILL.md" \
  "$PROMPT/SKILL.md" \
  "$PROMPT/references/prompt-craft.md" \
  "$PROMPT/templates/source-prompt.md" \
  "$ASK/SKILL.md" \
  "$ADOPT/SKILL.md" \
  "$SKILL/SKILL.md" \
  "$SKILL/VERSION" \
  "$SKILL/references/skill-principles.md" \
  "$SKILL/references/migration.md" \
  "$SKILL/references/tech-choices.md" \
  "$SKILL/references/regression-and-business-rules.md" \
  "$SKILL/references/workflow.md" \
  "$SKILL/references/doc-structure.md" \
  "$SKILL/references/project-structure.md" \
  "$SKILL/references/security.md" \
  "$SKILL/references/modern-extras.md" \
  "$SKILL/templates/scaffold/README.md" \
  "$SKILL/templates/scaffold/tsconfig.base.json" \
  "$SKILL/templates/scaffold/eslint.config.mjs" \
  "$SKILL/templates/scaffold/vitest.config.ts" \
  "$SKILL/templates/scaffold/playwright.config.ts" \
  "$SKILL/templates/scaffold/next.config.ts" \
  "$SKILL/templates/scaffold/middleware.ts" \
  "$SKILL/templates/scaffold/src/env.ts" \
  "$SKILL/templates/scaffold/src/lib/logger.ts" \
  "$SKILL/templates/scaffold/Dockerfile" \
  "$SKILL/templates/scaffold/AGENTS.md" \
  "$SKILL/templates/scaffold/shipjaw.cursor-rule.mdc" \
  "$SKILL/templates/business-rule.md" \
  "$SKILL/scripts/copy-continuation-contract.sh" \
  "$SKILL/scripts/stamp-provenance.sh" \
  "$SKILL/scripts/init-docs-skeleton.sh" \
  "$SKILL/scripts/validate-docs.sh" \
  "$SKILL/scripts/run-gate.sh" \
  "$SKILL/scripts/survey-adopt-state.sh" \
  "$ROOT/.cursor/skills/shipjaw" \
  "$ROOT/.cursor/skills/shipjaw-prompt" \
  "$ROOT/.cursor/skills/shipjaw-build" \
  "$ROOT/.cursor/skills/shipjaw-adopt" \
  "$ROOT/.cursor/skills/shipjaw-ask" \
  "$ROOT/scripts/smoke-check.sh"
do
  if [[ -e "$f" ]]; then ok "$(basename "$f")"
  else bad "missing $f"
  fi
done

echo "== VERSION =="
VER="$(tr -d '[:space:]' < "$SKILL/VERSION" || true)"
if [[ "$VER" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}[a-z]?$ ]]; then ok "VERSION=$VER"
else bad "VERSION must be YYYY.MM.DD or YYYY.MM.DDb (got: ${VER:-empty})"
fi

echo "== frontmatter descriptions =="
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$ASK/SKILL.md"; do
  name="$(basename "$(dirname "$skill_md")")"
  desc="$(grep -E '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//' | head -n1)"
  if [[ -z "$desc" ]]; then bad "$name missing description"
  elif (( ${#desc} < 500 )); then bad "$name description too thin (${#desc}; keep ≥500 for discovery)"
  elif (( ${#desc} > 1024 )); then bad "$name description too long (${#desc}; Cursor max 1024)"
  else ok "$name description ${#desc} chars"
  fi
  if grep -qiE 'do not use|not for|instead|Do not ' <<<"$desc"; then
    ok "$name anti-trigger in description"
  else
    bad "$name description needs anti-trigger (Do not / do not use / not for)"
  fi
  if grep -qiE 'Use when|Use for' <<<"$desc"; then
    ok "$name has Use when/for triggers"
  else
    bad "$name description needs Use when / Use for"
  fi
  # bilingual discovery: at least one FR cue across pipeline skills
done

echo "== bilingual discovery cues =="
FR_HITS=0
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$ASK/SKILL.md"; do
  desc="$(grep -E '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//' | head -n1)"
  if grep -qiE 'projet|idée|reprendre|continuer|adopter|après|prêt|créer|nouveau|corriger|ajouter|ramener|notes produit' <<<"$desc"; then
    FR_HITS=$((FR_HITS + 1))
    ok "$(basename "$(dirname "$skill_md")") FR trigger cue"
  else
    bad "$(basename "$(dirname "$skill_md")") missing FR discovery cue in description"
  fi
done
if [[ "$FR_HITS" -ge 5 ]]; then ok "all skills carry FR discovery cues"
else bad "expected FR cues on all 5 skills (got $FR_HITS)"
fi

echo "== invocation control =="
if grep -q 'disable-model-invocation: true' "$ENTRY/SKILL.md"; then
  ok "shipjaw slash-only invocation"
else
  bad "shipjaw should set disable-model-invocation: true"
fi
if grep -q 'disable-model-invocation: true' "$SKILL/SKILL.md"; then
  ok "shipjaw-build slash-only invocation"
else
  bad "shipjaw-build should set disable-model-invocation: true"
fi
if grep -q 'disable-model-invocation: true' "$ASK/SKILL.md"; then
  bad "shipjaw-ask should stay auto-invokable (no disable-model-invocation)"
else
  ok "shipjaw-ask auto-invokable"
fi
if grep -q 'disable-model-invocation: true' "$ADOPT/SKILL.md"; then
  bad "shipjaw-adopt should stay auto-invokable (no disable-model-invocation)"
else
  ok "shipjaw-adopt auto-invokable"
fi

echo "== checklists =="
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$ASK/SKILL.md"; do
  name="$(basename "$(dirname "$skill_md")")"
  if grep -q '\- \[ \]' "$skill_md"; then ok "$name has checklist"
  else bad "$name missing copiable checklist (- [ ])"
  fi
done

echo "== utility scripts executable =="
for s in \
  copy-continuation-contract.sh \
  stamp-provenance.sh \
  init-docs-skeleton.sh \
  validate-docs.sh \
  run-gate.sh \
  survey-adopt-state.sh
do
  path="$SKILL/scripts/$s"
  if [[ -x "$path" ]]; then ok "$s executable"
  else bad "$s missing or not executable"
  fi
done

echo "== ask stays cheap =="
if grep -qi 'Binding defaults' "$ASK/SKILL.md" \
  && grep -qi 'never.*skill-principles\|skill-principles.md.*default' "$ASK/SKILL.md"; then
  ok "shipjaw-ask inlines defaults / avoids principles preload"
else
  bad "shipjaw-ask should inline binding defaults and avoid principles preload"
fi

echo "== pipeline phrases =="
PRINCIPLES="$SKILL/references/skill-principles.md"
for phrase in \
  "Entrypoint" \
  "shipjaw-prompt" \
  "shipjaw-build" \
  "shipjaw-adopt" \
  "shipjaw-ask" \
  "Dogfood" \
  "Migration" \
  "Anti-trigger" \
  "framework docs" \
  "Idempotent" \
  "Narration" \
  "scaffolded-with" \
  "convention owner" \
  "Regression" \
  "core journey"
do
  if grep -qi "$phrase" "$PRINCIPLES"; then ok "$phrase"
  else bad "skill-principles.md missing: $phrase"
  fi
done

echo "== business-first templates =="
if grep -q 'User can' "$SKILL/templates/technical-plan-phase.md"; then
  ok "phase template has User can…"
else
  bad "technical-plan-phase.md missing User can…"
fi
if grep -qi 'Journey' "$SKILL/templates/product-feature.md"; then
  ok "product-feature has Journey"
else
  bad "product-feature.md missing Journey"
fi
if grep -qi 'ruthless\|exactly one\|Out of v1' "$PROMPT/references/prompt-craft.md"; then
  ok "prompt-craft MVP ruthlessness"
else
  bad "prompt-craft.md missing MVP / one core action rules"
fi
if grep -qi 'Edge cases' "$SKILL/references/testing-and-ci.md" \
  && grep -qi 'Golden path' "$SKILL/references/testing-and-ci.md" \
  && grep -qi 'Validation' "$SKILL/references/testing-and-ci.md"; then
  ok "testing-and-ci edge-case matrices"
else
  bad "testing-and-ci.md missing TU/e2e edge-case tables"
fi

echo "== entrypoint constraints =="
if grep -qi 'mkdir' "$ENTRY/SKILL.md" \
  && grep -q 'shipjaw-prompt' "$ENTRY/SKILL.md" \
  && grep -q 'shipjaw-build' "$ENTRY/SKILL.md" \
  && grep -q 'shipjaw-adopt' "$ENTRY/SKILL.md" \
  && grep -q 'shipjaw-ask' "$ENTRY/SKILL.md"; then
  ok "shipjaw entrypoint: folder + explains work skills"
else
  bad "shipjaw entrypoint must mkdir/cd and explain prompt/build/adopt/ask"
fi
if grep -qi 'create-next-app\|knowledge-base' "$ENTRY/SKILL.md" \
  && grep -qi 'No `create-next-app`\|never\|Do \*\*not\*\*' "$ENTRY/SKILL.md"; then
  ok "shipjaw entrypoint forbids scaffold/KB"
else
  bad "shipjaw entrypoint must forbid scaffold/KB"
fi

echo "== adopt survey wired =="
if grep -q 'survey-adopt-state' "$ADOPT/SKILL.md" \
  && grep -qi 'PARTIAL_DOCS\|FULL_SHIPJAW_KB\|Status snapshot\|where we are' "$ADOPT/SKILL.md"; then
  ok "shipjaw-adopt surveys docs/plans and reports status"
else
  bad "shipjaw-adopt must survey state and produce status snapshot"
fi
if grep -qi 'no rewrite\|Do not rewrite\|never rewrites\|no.*rewrite' "$ADOPT/SKILL.md" \
  && grep -q 'shipjaw-ask' "$ADOPT/SKILL.md"; then
  ok "shipjaw-adopt: no rewrite + handoff to ask"
else
  bad "shipjaw-adopt must forbid rewrite and hand off to ask"
fi

echo "== prompt skill constraints =="
if grep -qi 'knowledge-base' "$PROMPT/SKILL.md" \
  && grep -qi 'never' "$PROMPT/SKILL.md"; then
  ok "shipjaw-prompt forbids KB scaffold"
else
  bad "shipjaw-prompt must forbid creating knowledge-base/"
fi
if grep -q 'source-prompt.md' "$PROMPT/SKILL.md" "$SKILL/references/workflow.md"; then
  ok "source-prompt handoff wired"
else
  bad "source-prompt.md handoff missing"
fi

echo "== doc templates: no code fences =="
if command -v rg >/dev/null 2>&1; then
  if rg -n '```ts|```tsx|```js' "$SKILL/templates/knowledge-base" "$SKILL/templates/technical-plan-phase.md" "$SKILL/templates/product-overview.md" 2>/dev/null; then
    bad "code fences found in doc templates"
  else ok "no ts/js fences in doc templates"
  fi
else
  if grep -R -n -E '```ts|```tsx|```js' "$SKILL/templates/knowledge-base" "$SKILL/templates/technical-plan-phase.md" "$SKILL/templates/product-overview.md" 2>/dev/null; then
    bad "code fences found in doc templates"
  else ok "no ts/js fences in doc templates"
  fi
fi

echo "== documentation default = committed =="
if grep -n 'add `documentation/` to `.gitignore`' "$SKILL/references/doc-structure.md" "$SKILL/SKILL.md" 2>/dev/null | grep -v -i 'not\|never\|do not'; then
  bad "still instructs gitignoring documentation/ by default"
else ok "documentation/ default = committed"
fi

echo "== regression reference + BR template =="
if [[ -f "$SKILL/references/regression-and-business-rules.md" ]]; then
  ok "regression-and-business-rules.md"
else
  bad "missing regression-and-business-rules.md"
fi
if [[ -f "$SKILL/templates/business-rule.md" ]]; then
  ok "business-rule.md template"
else
  bad "missing templates/business-rule.md"
fi
if grep -q 'BR-' "$SKILL/templates/business-rule.md" \
  && grep -qi 'Invariant' "$SKILL/templates/business-rule.md"; then
  ok "BR template has id + invariant"
else
  bad "BR template missing BR- / Invariant"
fi

echo "== architecture template stamps version =="
if grep -q 'scaffolded-with' "$SKILL/templates/knowledge-base/architecture.md"; then
  ok "architecture.md has scaffolded-with"
else
  bad "architecture.md missing scaffolded-with"
fi
if grep -q 'adopted-with' "$SKILL/templates/knowledge-base/architecture.md"; then
  ok "architecture.md documents adopted-with"
else
  bad "architecture.md missing adopted-with note"
fi

echo "== scaffold README idempotent =="
if grep -qi 'Idempotent' "$SKILL/templates/scaffold/README.md"; then
  ok "scaffold README idempotent rules"
else
  bad "scaffold README missing idempotent rules"
fi

echo "== playwright dedicated port =="
if grep -q '3005' "$SKILL/templates/scaffold/playwright.config.ts"; then
  ok "playwright e2e port 3005"
else
  bad "playwright.config.ts should default e2e away from 3000"
fi

echo "== next.config roots =="
if grep -q 'outputFileTracingRoot' "$SKILL/templates/scaffold/next.config.ts" \
  && grep -q 'turbopack' "$SKILL/templates/scaffold/next.config.ts"; then
  ok "next.config pins app root"
else
  bad "next.config.ts missing turbopack.root / outputFileTracingRoot"
fi

echo "== types/helpers placement =="
if grep -qi 'Types, constants, helpers' "$SKILL/references/project-structure.md" \
  && grep -qi 'grab-bag\|utils.ts' "$SKILL/references/project-structure.md" \
  && grep -qi 'dedicated\|constants.ts\|grab-bag\|utils.ts' "$SKILL/references/code-standards.md"; then
  ok "placement rules for types/consts/helpers"
else
  bad "project-structure/code-standards missing types-consts-helpers placement"
fi

echo "== ports + composition + thin adapters =="
if grep -qi 'Composition root' "$SKILL/references/project-structure.md" \
  && grep -qi 'Ports (naming' "$SKILL/references/project-structure.md" \
  && grep -qi 'thin adapters' "$SKILL/references/project-structure.md" \
  && grep -qi 'Error → HTTP' "$SKILL/references/project-structure.md" \
  && grep -qi 'Anti-barrel' "$SKILL/references/project-structure.md"; then
  ok "ports, composition, thin adapters, error map, anti-barrel"
else
  bad "project-structure.md missing ports/composition/thin adapters/error map"
fi
if grep -qi 'Signal' "$SKILL/references/tech-choices.md"; then
  ok "tech-choices.md signal tables"
else
  bad "tech-choices.md missing signal tables"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo
  echo "smoke-check FAILED"
  exit 1
fi
echo
echo "smoke-check PASSED"
