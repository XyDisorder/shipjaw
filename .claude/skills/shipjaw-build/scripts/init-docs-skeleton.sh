#!/usr/bin/env bash
# Create missing documentation/ files from Shipjaw templates (idempotent).
# Does not overwrite existing files. Does not invent product content —
# leaves template placeholders for the agent to fill from the real repo.
# Usage: init-docs-skeleton.sh <project-root>
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root>" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TPL="$(cd "$SCRIPT_DIR/../templates" && pwd)"

copy_if_missing() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]]; then
    echo "skip $dest"
  else
    cp "$src" "$dest"
    echo "wrote $dest"
  fi
}

copy_if_missing "$TPL/index.md" "$ROOT/documentation/INDEX.md"
copy_if_missing "$TPL/knowledge-base/architecture.md" "$ROOT/documentation/knowledge-base/architecture.md"
copy_if_missing "$TPL/knowledge-base/domain-model.md" "$ROOT/documentation/knowledge-base/domain-model.md"
copy_if_missing "$TPL/knowledge-base/features-index.md" "$ROOT/documentation/knowledge-base/features-index.md"
copy_if_missing "$TPL/knowledge-base/decisions.md" "$ROOT/documentation/knowledge-base/decisions.md"
copy_if_missing "$TPL/knowledge-base/changelog.md" "$ROOT/documentation/knowledge-base/changelog.md"
copy_if_missing "$TPL/knowledge-base/api-reference.md" "$ROOT/documentation/knowledge-base/api-reference.md"
copy_if_missing "$TPL/product-overview.md" "$ROOT/documentation/product/overview.md"
copy_if_missing "$TPL/roadmap.md" "$ROOT/documentation/technical-plan/00-roadmap.md"
copy_if_missing "$TPL/handoff.md" "$ROOT/documentation/handoff.md"

echo "init-docs-skeleton done — fill placeholders from the real codebase"
