#!/usr/bin/env bash
# Idempotent: copy Shipjaw continuation contract into a target app.
# Usage: copy-continuation-contract.sh <project-root>
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root>" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT="$(cd "$SCRIPT_DIR/../templates/scaffold" && pwd)"

mkdir -p "$ROOT/.cursor/rules"

if [[ ! -f "$ROOT/AGENTS.md" ]]; then
  cp "$KIT/AGENTS.md" "$ROOT/AGENTS.md"
  echo "wrote AGENTS.md"
else
  echo "skip AGENTS.md (exists)"
fi

if [[ ! -f "$ROOT/.cursor/rules/shipjaw.mdc" ]]; then
  cp "$KIT/shipjaw.cursor-rule.mdc" "$ROOT/.cursor/rules/shipjaw.mdc"
  echo "wrote .cursor/rules/shipjaw.mdc"
else
  echo "skip .cursor/rules/shipjaw.mdc (exists)"
fi
