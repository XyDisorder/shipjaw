#!/usr/bin/env bash
# Stamp or refresh provenance lines in architecture.md.
# Usage: stamp-provenance.sh <project-root> [--adopted]
set -euo pipefail

ROOT="${1:-}"
MODE="${2:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root> [--adopted]" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VER="$(tr -d '[:space:]' < "$SCRIPT_DIR/../VERSION")"
ARCH="$ROOT/documentation/knowledge-base/architecture.md"

if [[ ! -f "$ARCH" ]]; then
  echo "missing $ARCH — create docs first" >&2
  exit 1
fi

stamp="scaffolded-with: shipjaw-build@${VER}"
if grep -q 'scaffolded-with:' "$ARCH"; then
  # portable in-place: rewrite matching line
  tmp="$(mktemp)"
  sed "s|scaffolded-with:.*|${stamp}|" "$ARCH" > "$tmp"
  mv "$tmp" "$ARCH"
  echo "updated $stamp"
else
  # insert under Skill provenance if present, else prepend
  if grep -q '## Skill provenance' "$ARCH"; then
    tmp="$(mktemp)"
    awk -v s="- ${stamp}" '
      /^## Skill provenance/ { print; print s; next }
      { print }
    ' "$ARCH" > "$tmp"
    mv "$tmp" "$ARCH"
  else
    tmp="$(mktemp)"
    {
      echo "## Skill provenance"
      echo "- ${stamp}"
      echo
      cat "$ARCH"
    } > "$tmp"
    mv "$tmp" "$ARCH"
  fi
  echo "added $stamp"
fi

if [[ "$MODE" == "--adopted" ]]; then
  adopt="adopted-with: shipjaw-adopt@${VER} — docs + contract; code pre-existed"
  if grep -q 'adopted-with:' "$ARCH"; then
    tmp="$(mktemp)"
    sed "s|adopted-with:.*|${adopt}|" "$ARCH" > "$tmp"
    mv "$tmp" "$ARCH"
    echo "updated $adopt"
  else
    tmp="$(mktemp)"
    awk -v s="- ${adopt}" '
      /scaffolded-with:/ { print; print s; next }
      { print }
    ' "$ARCH" > "$tmp"
    mv "$tmp" "$ARCH"
    echo "added $adopt"
  fi
fi
