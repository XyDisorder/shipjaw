#!/usr/bin/env bash
# Idempotent by default: copy Shipjaw continuation contract into a target
# app, skipping files that already exist. Pass --refresh (used by
# shipjaw-upgrade) to force-overwrite with the current templates instead —
# without it, an existing AGENTS.md/shipjaw.mdc never picks up contract
# changes shipped in newer shipjaw-build VERSIONs, even via /shipjaw-upgrade,
# because plain copy silently no-ops once the files exist.
# Usage: copy-continuation-contract.sh <project-root> [--refresh]
set -euo pipefail

ROOT="${1:-}"
REFRESH=0
for arg in "$@"; do
  [[ "$arg" == "--refresh" ]] && REFRESH=1
done
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root> [--refresh]" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT="$(cd "$SCRIPT_DIR/../templates/scaffold" && pwd)"

mkdir -p "$ROOT/.cursor/rules"

if [[ ! -f "$ROOT/AGENTS.md" ]]; then
  cp "$KIT/AGENTS.md" "$ROOT/AGENTS.md"
  echo "wrote AGENTS.md"
elif [[ "$REFRESH" -eq 1 ]]; then
  cp "$KIT/AGENTS.md" "$ROOT/AGENTS.md"
  echo "refreshed AGENTS.md"
else
  echo "skip AGENTS.md (exists — pass --refresh to update)"
fi

if [[ ! -f "$ROOT/.cursor/rules/shipjaw.mdc" ]]; then
  cp "$KIT/shipjaw.cursor-rule.mdc" "$ROOT/.cursor/rules/shipjaw.mdc"
  echo "wrote .cursor/rules/shipjaw.mdc"
elif [[ "$REFRESH" -eq 1 ]]; then
  cp "$KIT/shipjaw.cursor-rule.mdc" "$ROOT/.cursor/rules/shipjaw.mdc"
  echo "refreshed .cursor/rules/shipjaw.mdc"
else
  echo "skip .cursor/rules/shipjaw.mdc (exists — pass --refresh to update)"
fi

# A file that exists on disk but is gitignored by the target repo's own
# .gitignore (e.g. a blanket `.cursor` entry meant for local editor state)
# silently never reaches a clone or CI — defeats the whole point of a
# *committed* continuation contract. Warn, don't auto-edit .gitignore:
# the exception pattern is project-specific and this script has no basis
# to guess it safely.
warn_if_gitignored() {
  local file="$1"
  if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git -C "$ROOT" check-ignore -q -- "$file" 2>/dev/null; then
      echo "WARN ${file#"$ROOT"/} is gitignored by this repo — it will never be committed as-is." >&2
      echo "     Add an exception in .gitignore (unignore each parent dir too, e.g.:" >&2
      echo "       !.cursor/rules" >&2
      echo "       !${file#"$ROOT"/}" >&2
      echo "     ) or it silently won't ship to clones/CI." >&2
    fi
  fi
}
warn_if_gitignored "$ROOT/AGENTS.md"
warn_if_gitignored "$ROOT/.cursor/rules/shipjaw.mdc"
