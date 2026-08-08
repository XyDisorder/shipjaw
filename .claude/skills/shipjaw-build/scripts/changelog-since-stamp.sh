#!/usr/bin/env bash
# Print Shipjaw CHANGELOG entries newer than the project's scaffolded-with stamp.
# Usage: changelog-since-stamp.sh <project-root> [stamp-version]
# stamp-version optional override (e.g. 2026.07.22q). Exit 0 always when printable.
set -euo pipefail

ROOT="${1:-}"
OVERRIDE="${2:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root> [stamp-version]" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_VER="$(tr -d '[:space:]' < "$SCRIPT_DIR/../VERSION")"
# scripts → shipjaw-build → skills → .claude → repo root
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"

if [[ ! -f "$CHANGELOG" ]]; then
  echo "missing CHANGELOG at $CHANGELOG" >&2
  exit 1
fi

norm() {
  # 2026.07.22u → 2026-07-22u (matches ## headers)
  echo "$1" | tr -d '[:space:]' | sed 's/\./-/g'
}

STAMP_RAW="$OVERRIDE"
if [[ -z "$STAMP_RAW" ]]; then
  ARCH="$ROOT/documentation/knowledge-base/architecture.md"
  if [[ -f "$ARCH" ]]; then
    STAMP_RAW="$(grep -Eo '(scaffolded|adopted)-with:[[:space:]]*[^[:space:]]+' "$ARCH" \
      | head -n1 | sed -E 's/.*@//' || true)"
  fi
fi

STAMP_NORM="$(norm "${STAMP_RAW:-}")"
SKILL_NORM="$(norm "$SKILL_VER")"

echo "== Shipjaw upgrade delta =="
echo "project stamp: ${STAMP_RAW:-"(none)"}"
echo "installed skill: shipjaw-build@${SKILL_VER}"

if [[ -z "$STAMP_RAW" ]]; then
  echo ""
  echo "No scaffolded-with stamp found — treating as pre-version-stamp era"
  echo "(see migration.md); a completed /shipjaw-upgrade run adds one."
  echo "Recent changelog (last 5 sections) for context:"
  echo ""
  awk '
    /^## / {
      if (n==5) exit
      if (n>0) print ""
      n++
    }
    n>0 { print }
  ' "$CHANGELOG"
  exit 0
fi

if [[ "$STAMP_NORM" == "$SKILL_NORM" ]]; then
  echo ""
  echo "Already at installed VERSION — no changelog delta."
  exit 0
fi

echo ""
echo "Changes in the skill since your stamp (apply via /shipjaw-upgrade + migration.md):"
echo ""

# Newest-first CHANGELOG: print sections until we hit the stamp header (exclusive).
awk -v stamp="$STAMP_NORM" '
  BEGIN { printing=0; found=0 }
  /^## / {
    ver=$0
    sub(/^##[[:space:]]+/, "", ver)
    gsub(/\./, "-", ver)
    if (ver == stamp) { found=1; exit }
    printing=1
    if (seen++) print ""
  }
  printing { print }
  END {
    if (!found && !seen) {
      print "(stamp not found in CHANGELOG — project may predate recorded versions)"
      print "Read migration.md era table and upgrade anyway."
    } else if (!found && seen) {
      print ""
      print "(stamp " stamp " not found as a header — printed entries above the oldest listed)"
    }
  }
' "$CHANGELOG"
