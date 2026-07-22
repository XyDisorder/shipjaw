#!/usr/bin/env bash
# Validate Shipjaw documentation/ layout (agent feedback loop).
# Usage: validate-docs.sh <project-root>
# Exit 0 = OK, 1 = gaps listed on stderr/stdout.
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root>" >&2
  exit 2
fi

DOC="$ROOT/documentation"
FAIL=0
req() {
  if [[ -f "$1" ]]; then
    echo "OK  $2"
  else
    echo "MISS $2"
    FAIL=1
  fi
}

echo "== Shipjaw docs layout =="
req "$DOC/INDEX.md" "documentation/INDEX.md"
req "$DOC/knowledge-base/architecture.md" "knowledge-base/architecture.md"
req "$DOC/knowledge-base/domain-model.md" "knowledge-base/domain-model.md"
req "$DOC/knowledge-base/features-index.md" "knowledge-base/features-index.md"
req "$DOC/knowledge-base/decisions.md" "knowledge-base/decisions.md"
req "$DOC/knowledge-base/changelog.md" "knowledge-base/changelog.md"
req "$DOC/product/overview.md" "product/overview.md"
req "$DOC/technical-plan/00-roadmap.md" "technical-plan/00-roadmap.md"

if [[ -f "$DOC/knowledge-base/architecture.md" ]]; then
  if grep -q 'scaffolded-with:' "$DOC/knowledge-base/architecture.md"; then
    echo "OK  scaffolded-with stamp"
  else
    echo "MISS scaffolded-with stamp in architecture.md"
    FAIL=1
  fi
fi

if [[ -f "$ROOT/AGENTS.md" ]]; then echo "OK  AGENTS.md"
else echo "MISS AGENTS.md"; FAIL=1; fi

if [[ -f "$ROOT/.cursor/rules/shipjaw.mdc" ]]; then echo "OK  .cursor/rules/shipjaw.mdc"
else echo "MISS .cursor/rules/shipjaw.mdc"; FAIL=1; fi

if [[ "$FAIL" -ne 0 ]]; then
  echo "validate-docs FAILED"
  exit 1
fi
echo "validate-docs PASSED"
