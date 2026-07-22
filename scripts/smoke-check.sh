#!/usr/bin/env bash
# Structural smoke check for skill-my-app / ask-my-app (no network).
# Run from repo root: ./scripts/smoke-check.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL="$ROOT/.claude/skills/skill-my-app"
ASK="$ROOT/.claude/skills/ask-my-app"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; FAIL=1; }

echo "== skill layout =="
for f in \
  "$ASK/SKILL.md" \
  "$SKILL/SKILL.md" \
  "$SKILL/VERSION" \
  "$SKILL/references/skill-principles.md" \
  "$SKILL/references/migration.md" \
  "$SKILL/references/tech-choices.md" \
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
  "$ROOT/.cursor/skills/skill-my-app" \
  "$ROOT/.cursor/skills/ask-my-app" \
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
for skill_md in "$SKILL/SKILL.md" "$ASK/SKILL.md"; do
  name="$(basename "$(dirname "$skill_md")")"
  desc="$(grep -E '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//' | head -n1)"
  if [[ -z "$desc" ]]; then bad "$name missing description"
  elif (( ${#desc} > 560 )); then bad "$name description too long (${#desc}; keep ≤560)"
  else ok "$name description ${#desc} chars"
  fi
  if grep -qiE 'do not use|not for|instead' <<<"$desc"; then
    ok "$name anti-trigger in description"
  else
    bad "$name description needs anti-trigger (do not use / not for / instead)"
  fi
done

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

echo "== principles 9–16 phrases =="
PRINCIPLES="$SKILL/references/skill-principles.md"
for phrase in \
  "Dogfood" \
  "Migration" \
  "Anti-trigger" \
  "framework docs" \
  "Idempotent" \
  "Narration" \
  "scaffolded-with" \
  "convention owner"
do
  if grep -qi "$phrase" "$PRINCIPLES"; then ok "$phrase"
  else bad "skill-principles.md missing: $phrase"
  fi
done

echo "== architecture template stamps version =="
if grep -q 'scaffolded-with' "$SKILL/templates/knowledge-base/architecture.md"; then
  ok "architecture.md has scaffolded-with"
else
  bad "architecture.md missing scaffolded-with"
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

echo "== tech-choices present =="
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
