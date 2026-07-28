#!/usr/bin/env bash
# Structural smoke check for shipjaw / shipjaw-prompt / shipjaw-build /
# shipjaw-adopt / shipjaw-upgrade / shipjaw-challenge / shipjaw-ask.
# Run from repo root: ./scripts/smoke-check.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL="$ROOT/.claude/skills/shipjaw-build"
ASK="$ROOT/.claude/skills/shipjaw-ask"
PROMPT="$ROOT/.claude/skills/shipjaw-prompt"
ADOPT="$ROOT/.claude/skills/shipjaw-adopt"
UPGRADE="$ROOT/.claude/skills/shipjaw-upgrade"
CHALLENGE="$ROOT/.claude/skills/shipjaw-challenge"
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
  "$UPGRADE/SKILL.md" \
  "$CHALLENGE/SKILL.md" \
  "$SKILL/SKILL.md" \
  "$SKILL/VERSION" \
  "$SKILL/references/skill-principles.md" \
  "$SKILL/references/migration.md" \
  "$SKILL/references/tech-choices.md" \
  "$SKILL/references/regression-and-business-rules.md" \
  "$SKILL/references/gate-failure-modes.md" \
  "$SKILL/references/design-constraints.md" \
  "$SKILL/references/challenge-built-in.md" \
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
  "$SKILL/templates/technical-plan-converge-arch.md" \
  "$SKILL/templates/challenge-report.md" \
  "$SKILL/templates/handoff.md" \
  "$SKILL/scripts/copy-continuation-contract.sh" \
  "$SKILL/scripts/stamp-provenance.sh" \
  "$SKILL/scripts/init-docs-skeleton.sh" \
  "$SKILL/scripts/validate-docs.sh" \
  "$SKILL/scripts/validate-docs-drift.sh" \
  "$SKILL/scripts/changelog-since-stamp.sh" \
  "$SKILL/scripts/run-gate.sh" \
  "$SKILL/scripts/survey-adopt-state.sh" \
  "$ROOT/.cursor/skills/shipjaw" \
  "$ROOT/.cursor/skills/shipjaw-prompt" \
  "$ROOT/.cursor/skills/shipjaw-build" \
  "$ROOT/.cursor/skills/shipjaw-adopt" \
  "$ROOT/.cursor/skills/shipjaw-upgrade" \
  "$ROOT/.cursor/skills/shipjaw-challenge" \
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

# A CHANGELOG entry with no matching VERSION bump is invisible to every
# project's shipjaw-upgrade: changelog-since-stamp.sh compares a project's
# stamp against this VERSION file, so real changes silently look like "you
# are current." Caught once already (7 changelog entries landed before
# VERSION was bumped) — this stops it from happening silently again.
LATEST_CHANGELOG_HEADER="$(grep -m1 '^## ' "$ROOT/CHANGELOG.md" | sed -E 's/^## //')"
VER_AS_HEADER="${VER//./-}"
if [[ "$VER_AS_HEADER" == "$LATEST_CHANGELOG_HEADER" ]]; then
  ok "VERSION matches latest CHANGELOG.md header ($LATEST_CHANGELOG_HEADER)"
else
  bad "VERSION ($VER) does not match latest CHANGELOG.md header ($LATEST_CHANGELOG_HEADER) — bump VERSION"
fi

echo "== frontmatter descriptions =="
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$UPGRADE/SKILL.md" "$CHALLENGE/SKILL.md" "$ASK/SKILL.md"; do
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
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$UPGRADE/SKILL.md" "$CHALLENGE/SKILL.md" "$ASK/SKILL.md"; do
  desc="$(grep -E '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//' | head -n1)"
  if grep -qiE 'projet|idée|reprendre|continuer|adopter|après|prêt|créer|nouveau|corriger|ajouter|ramener|notes produit|upgrade|contester' <<<"$desc"; then
    FR_HITS=$((FR_HITS + 1))
    ok "$(basename "$(dirname "$skill_md")") FR trigger cue"
  else
    bad "$(basename "$(dirname "$skill_md")") missing FR discovery cue in description"
  fi
done
if [[ "$FR_HITS" -ge 7 ]]; then ok "all skills carry FR discovery cues"
else bad "expected FR cues on all 7 skills (got $FR_HITS)"
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
for skill_md in "$ENTRY/SKILL.md" "$PROMPT/SKILL.md" "$SKILL/SKILL.md" "$ADOPT/SKILL.md" "$UPGRADE/SKILL.md" "$CHALLENGE/SKILL.md" "$ASK/SKILL.md"; do
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
  validate-docs-drift.sh \
  changelog-since-stamp.sh \
  run-gate.sh \
  survey-adopt-state.sh
do
  path="$SKILL/scripts/$s"
  if [[ -x "$path" ]]; then ok "$s executable"
  else bad "$s missing or not executable"
  fi
done

echo "== copy-continuation-contract warns on gitignored rule file =="
# Real-dogfood catch (craftmyjob, 2026-07-27): a project's own .gitignore
# blanket-ignored .cursor/, silently swallowing .cursor/rules/shipjaw.mdc
# from git — the continuation contract "wrote" but would never reach a
# clone/CI. Verify the warning fires, and that it stops firing once the
# project's .gitignore carries the documented unignore pattern.
TMP_GI="$(mktemp -d)"
git -C "$TMP_GI" init -q
printf '.cursor/*\n' > "$TMP_GI/.gitignore"
gi_out="$("$SKILL/scripts/copy-continuation-contract.sh" "$TMP_GI" 2>&1 || true)"
if grep -q 'WARN .*gitignored' <<<"$gi_out"; then
  ok "warns when shipjaw.mdc is gitignored"
else
  bad "should warn when shipjaw.mdc is gitignored"
  echo "$gi_out"
fi
printf '!.cursor/rules/\n!.cursor/rules/shipjaw.mdc\n' >> "$TMP_GI/.gitignore"
gi_out2="$("$SKILL/scripts/copy-continuation-contract.sh" "$TMP_GI" 2>&1 || true)"
if grep -q 'WARN .*gitignored' <<<"$gi_out2"; then
  bad "should stay silent once the unignore pattern is in place"
  echo "$gi_out2"
else
  ok "silent once the unignore pattern is in place"
fi
rm -rf "$TMP_GI"

echo "== handoff wired =="
if [[ -f "$SKILL/templates/handoff.md" ]] \
  && grep -q 'handoff.md' "$ASK/SKILL.md" \
  && grep -q 'handoff.md' "$SKILL/SKILL.md" \
  && grep -q 'handoff.md' "$ADOPT/SKILL.md" \
  && grep -q 'handoff.md' "$PROMPT/SKILL.md"; then
  ok "handoff template + all work skills"
else
  bad "handoff.md must be templated and required in prompt/build/adopt/ask"
fi

if grep -qi 'handoff.md' "$SKILL/references/skill-principles.md"; then
  ok "principles mention handoff"
else
  bad "skill-principles.md should require handoff.md"
fi
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
  "shipjaw-upgrade" \
  "shipjaw-challenge" \
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
  && grep -q 'shipjaw-challenge' "$ENTRY/SKILL.md" \
  && grep -q 'shipjaw-ask' "$ENTRY/SKILL.md"; then
  ok "shipjaw entrypoint: folder + explains work skills"
else
  bad "shipjaw entrypoint must mkdir/cd and explain prompt/build/adopt/upgrade/challenge/ask"
fi
if grep -qi 'create-next-app\|knowledge-base' "$ENTRY/SKILL.md" \
  && grep -qi 'No `create-next-app`\|never\|Do \*\*not\*\*' "$ENTRY/SKILL.md"; then
  ok "shipjaw entrypoint forbids scaffold/KB"
else
  bad "shipjaw entrypoint must forbid scaffold/KB"
fi

echo "== ROI refs (failure modes, design, drift, upgrade) =="
if grep -qi 'Drift protocol' "$ASK/SKILL.md" \
  && grep -qi 'gate-failure-modes' "$ASK/SKILL.md" \
  && grep -qi 'design-constraints' "$ASK/SKILL.md"; then
  ok "shipjaw-ask: drift + failure modes + design constraints"
else
  bad "shipjaw-ask missing drift / gate-failure-modes / design-constraints"
fi
if [[ -f "$SKILL/references/gate-failure-modes.md" ]] \
  && grep -qi 'EADDRINUSE\|force-dynamic\|2nd' "$SKILL/references/gate-failure-modes.md"; then
  ok "gate-failure-modes.md"
else
  bad "missing gate-failure-modes.md"
fi
if [[ -f "$SKILL/references/design-constraints.md" ]] \
  && grep -qi 'AI-slop\|purple\|cards' "$SKILL/references/design-constraints.md"; then
  ok "design-constraints.md"
else
  bad "missing design-constraints.md"
fi
if [[ -f "$UPGRADE/SKILL.md" ]] \
  && grep -qi 'disable-model-invocation: true' "$UPGRADE/SKILL.md" \
  && grep -qi 'migration.md' "$UPGRADE/SKILL.md" \
  && grep -qi 'changelog-since-stamp' "$UPGRADE/SKILL.md" \
  && grep -qi 'Do not rewrite\|no product rewrite\|Do not rewrite product' "$UPGRADE/SKILL.md"; then
  ok "shipjaw-upgrade skill"
else
  bad "shipjaw-upgrade missing or incomplete"
fi
if grep -q 'disable-model-invocation: true' "$UPGRADE/SKILL.md"; then
  ok "shipjaw-upgrade slash-only"
else
  bad "shipjaw-upgrade should be slash-only"
fi
if [[ -x "$SKILL/scripts/changelog-since-stamp.sh" ]]; then
  delta_out="$("$SKILL/scripts/changelog-since-stamp.sh" "$ROOT/fixtures/golden-todo" 2>&1 || true)"
  if grep -qiE 'Shipjaw upgrade delta|installed skill' <<<"$delta_out"; then
    ok "changelog-since-stamp.sh emits delta"
  else
    bad "changelog-since-stamp.sh missing or silent"
  fi
else
  bad "changelog-since-stamp.sh not executable"
fi
if grep -qi 'Stamp lag\|changelog-since-stamp\|nudge.*shipjaw-upgrade' "$ASK/SKILL.md"; then
  ok "shipjaw-ask nudges upgrade on stamp lag"
else
  bad "shipjaw-ask missing stamp-lag → upgrade nudge"
fi
if grep -qi 'open-phase Challenge\|in-progress' "$SKILL/scripts/validate-docs.sh" \
  && grep -qi 'Axis calls\|Challenge looks unfilled' "$SKILL/scripts/validate-docs.sh"; then
  ok "validate-docs Challenge guard for in-progress phases"
else
  bad "validate-docs missing Challenge guard"
fi
if [[ -f "$CHALLENGE/SKILL.md" ]] \
  && grep -qi 'proposer\|Challenger\|subagent' "$CHALLENGE/SKILL.md" \
  && grep -qi 'Do not rubber-stamp\|rubber-stamp' "$CHALLENGE/SKILL.md" \
  && grep -q 'disable-model-invocation: true' "$CHALLENGE/SKILL.md"; then
  ok "shipjaw-challenge dual-agent protocol"
else
  bad "shipjaw-challenge missing dual-agent / slash-only / anti-rubber-stamp"
fi
if grep -qi 'built-in\|Challenge plans' "$ASK/SKILL.md" \
  && grep -qi 'Challenge (required' "$SKILL/templates/technical-plan-phase.md" \
  && [[ -f "$SKILL/references/challenge-built-in.md" ]] \
  && grep -qi 'not only when\|not slash\|built-in' "$SKILL/references/challenge-built-in.md"; then
  ok "ask + phase template require built-in challenge for non-trivial work"
else
  bad "built-in challenge not wired into ask / phase template / challenge-built-in.md"
fi
if grep -q 'survey-adopt-state' "$ADOPT/SKILL.md" \
  && grep -qi 'PARTIAL_DOCS\|FULL_SHIPJAW_KB\|Status snapshot\|where we are' "$ADOPT/SKILL.md"; then
  ok "shipjaw-adopt surveys docs/plans and reports status"
else
  bad "shipjaw-adopt must survey state and produce status snapshot"
fi
if grep -qi 'Architecture practice audit\|practice gaps\|converge-arch\|improvement plan' "$ADOPT/SKILL.md" \
  && [[ -f "$SKILL/templates/technical-plan-converge-arch.md" ]]; then
  ok "shipjaw-adopt audits practices and proposes converge plan"
else
  bad "shipjaw-adopt must audit arch practices + converge-arch template"
fi
# Real-dogfood catch (craftmyjob, 2026-07-27): technical-plan-phase.md has
# a ## Challenge section with the exact **Verdict:** line validate-docs.sh
# checks for; technical-plan-converge-arch.md didn't, even though converge
# phases are P0-by-definition (money/authz paths) and hit the same
# in-progress Challenge gate. Missing template guidance meant freehanding
# the section and getting the format wrong on the first attempt.
if grep -q '^## Challenge' "$SKILL/templates/technical-plan-converge-arch.md" \
  && grep -q '\*\*Verdict:\*\*.*proceed.*revise-then-proceed' "$SKILL/templates/technical-plan-converge-arch.md"; then
  ok "converge-arch template has Challenge section with Verdict line"
else
  bad "technical-plan-converge-arch.md missing ## Challenge / **Verdict:** line (validate-docs.sh will reject in-progress phases written from this template)"
fi
if grep -q 'architecture practice signals' "$SKILL/scripts/survey-adopt-state.sh"; then
  ok "survey-adopt-state emits arch practice signals"
else
  bad "survey-adopt-state.sh missing architecture practice signals"
fi
if grep -q 'gate baseline' "$SKILL/scripts/survey-adopt-state.sh" \
  && grep -q 'has_script typecheck' "$SKILL/scripts/survey-adopt-state.sh" \
  && grep -q 'has_script lint' "$SKILL/scripts/survey-adopt-state.sh"; then
  ok "survey-adopt-state checks lint/typecheck baseline"
else
  bad "survey-adopt-state.sh missing gate baseline (lint/typecheck) check"
fi
survey_out="$(bash "$SKILL/scripts/survey-adopt-state.sh" "$ROOT/fixtures/golden-todo" 2>&1 || true)"
if grep -q 'gate baseline' <<<"$survey_out" && grep -qE 'OK  typecheck clean|OK  lint clean' <<<"$survey_out"; then
  ok "survey-adopt-state gate baseline runs clean on golden fixture"
else
  bad "survey-adopt-state gate baseline did not run on golden fixture"
  echo "$survey_out"
fi
if grep -qi 'no rewrite\|Do not rewrite\|never rewrites\|no silent\|opt-in' "$ADOPT/SKILL.md" \
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
# Real-dogfood catch (craftmyjob, 2026-07-28, found twice in one session):
# an RLS-protected write silently no-ops for a session-less caller
# (webhook/cron) while still reporting success. project-structure.md's
# Ports/Composition section needs to warn about this before an agent
# wires a Supabase-backed function into a port without checking every
# real caller's auth context.
if grep -qi 'Infra client context' "$SKILL/references/project-structure.md" \
  && grep -qi 'service-role client' "$SKILL/references/project-structure.md" \
  && grep -qi "sibling function got this right" "$SKILL/references/project-structure.md"; then
  ok "project-structure.md warns about RLS-aware infra client context"
else
  bad "project-structure.md missing the RLS/session-less-caller client-context lesson"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo
  echo "smoke-check FAILED"
  exit 1
fi

echo "== golden fixture =="
if bash "$ROOT/scripts/smoke-fixture.sh"; then
  ok "smoke-fixture"
else
  bad "smoke-fixture"
fi

echo "== skill routing eval =="
if bash "$ROOT/scripts/eval-skill-routing.sh"; then
  ok "eval-skill-routing"
else
  bad "eval-skill-routing"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo
  echo "smoke-check FAILED"
  exit 1
fi
echo
echo "smoke-check PASSED"
