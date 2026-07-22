#!/usr/bin/env bash
# Survey an existing app before shipjaw-adopt — what docs/plans already exist,
# and rough signals for "where we are". Read-only. Always exit 0.
# Usage: survey-adopt-state.sh <project-root>
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root>" >&2
  exit 2
fi

cd "$ROOT"

echo "== adopt survey: $(pwd) =="

echo
echo "-- stack signals --"
[[ -f package.json ]] && echo "OK  package.json" || echo "MISS package.json"
if [[ -f package.json ]] && command -v node >/dev/null 2>&1; then
  node -e '
    const p=require("./package.json");
    const d={...p.dependencies||{},...p.devDependencies||{}};
    const keys=["next","react","typescript","vitest","jest","playwright","@playwright/test","nestjs","@nestjs/core"];
    for (const k of keys) if (d[k]) console.log("dep "+k+"@"+d[k]);
    const s=Object.keys(p.scripts||{});
    if (s.length) console.log("scripts: "+s.join(", "));
  ' 2>/dev/null || true
fi
[[ -f pnpm-lock.yaml ]] && echo "lock pnpm"
[[ -f yarn.lock ]] && echo "lock yarn"
[[ -f package-lock.json ]] && echo "lock npm"

echo
echo "-- Shipjaw documentation/ --"
DOC=documentation
if [[ ! -d "$DOC" ]]; then
  echo "none documentation/ (greenfield docs)"
else
  echo "OK  documentation/ present"
  for f in \
    INDEX.md \
    knowledge-base/architecture.md \
    knowledge-base/domain-model.md \
    knowledge-base/features-index.md \
    knowledge-base/decisions.md \
    knowledge-base/changelog.md \
    knowledge-base/api-reference.md \
    product/overview.md \
    product/source-prompt.md \
    product/design-brief.md \
    technical-plan/00-roadmap.md
  do
    if [[ -f "$DOC/$f" ]]; then echo "  OK  $f"
    else echo "  MISS $f"
    fi
  done
  # phases
  if [[ -d "$DOC/technical-plan" ]]; then
    echo "  phases:"
    find "$DOC/technical-plan" -maxdepth 2 -type f -name 'phase-*.md' 2>/dev/null | sort | while read -r p; do
      echo "    $p"
      # status line if present
      grep -iE '^Status:|^status:|\*User can\*' "$p" 2>/dev/null | head -n 3 | sed 's/^/      /' || true
    done
    if [[ -d "$DOC/technical-plan/phase-archive" ]]; then
      echo "  archived phases:"
      find "$DOC/technical-plan/phase-archive" -type f -name 'phase-*.md' 2>/dev/null | sort | sed 's/^/    /' || true
    fi
  fi
  if [[ -f "$DOC/knowledge-base/architecture.md" ]] \
    && grep -qE 'scaffolded-with:|adopted-with:' "$DOC/knowledge-base/architecture.md"; then
    echo "  provenance:"
    grep -E 'scaffolded-with:|adopted-with:' "$DOC/knowledge-base/architecture.md" | sed 's/^/    /'
  fi
fi

echo
echo "-- foreign / adjacent planning docs (candidates to absorb) --"
# common locations outside Shipjaw layout
shopt -s nullglob
CANDIDATES=(
  README.md README.mdx
  ROADMAP.md ROADMAP.mdx roadmap.md
  TODO.md TODOS.md CHANGELOG.md HISTORY.md
  PLAN.md PLANS.md CONTRIBUTING.md
  docs docs/ docs/README.md
  .github/ISSUE_TEMPLATE
  ADR ADRs adr docs/adr docs/decisions
  specs spec
)
found=0
for c in "${CANDIDATES[@]}"; do
  if [[ -e "$c" ]]; then
    echo "  found $c"
    found=1
  fi
done
# loose globs
for c in docs/*.md docs/**/*.md .cursor/rules/* AGENTS.md CLAUDE.md; do
  if [[ -e "$c" ]]; then
    echo "  found $c"
    found=1
  fi
done
[[ "$found" -eq 0 ]] && echo "  (none obvious)"

echo
echo "-- product surface (routes / pages hint) --"
for d in app src/app pages src/pages; do
  if [[ -d "$d" ]]; then
    echo "  tree $d"
    find "$d" \( -name 'page.tsx' -o -name 'page.ts' -o -name 'route.ts' -o -name 'route.tsx' -o -name 'index.tsx' \) 2>/dev/null \
      | head -n 40 | sed 's/^/    /' || true
  fi
done

echo
echo "-- recent git (where we might be) --"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git log -8 --oneline 2>/dev/null | sed 's/^/  /' || true
  echo "  tags:"
  git tag --sort=-creatordate 2>/dev/null | head -n 8 | sed 's/^/    /' || echo "    (none)"
else
  echo "  (not a git repo)"
fi

echo
echo "-- adopt routing hint --"
if [[ -f "$DOC/knowledge-base/architecture.md" ]] \
  && [[ -f "$DOC/INDEX.md" ]] \
  && [[ -f "$DOC/knowledge-base/features-index.md" ]]; then
  echo "FULL_SHIPJAW_KB → prefer shipjaw-ask (upgrade via migration.md if legacy)"
elif [[ -d "$DOC" ]]; then
  echo "PARTIAL_DOCS → adopt: merge/fill gaps; do not wipe; map into INDEX + roadmap"
else
  echo "NO_DOCS → adopt: init skeleton then fill from code + foreign plans"
fi

echo
echo "survey-adopt-state done"
