#!/usr/bin/env bash
# Installs all 7 shipjaw skills as symlinks into ~/.claude/skills and
# ~/.cursor/skills, pointing at this clone. Idempotent — safe to re-run
# after a `git pull` or to pick up a skill added since your last install.
#
# Usage: ./install.sh   (run from anywhere inside this repo)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/.claude/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "error: $SKILLS_SRC not found — run this from a shipjaw clone." >&2
  exit 1
fi

SKILLS=(shipjaw shipjaw-prompt shipjaw-build shipjaw-adopt shipjaw-upgrade shipjaw-challenge shipjaw-ask)
TARGETS=("$HOME/.claude/skills" "$HOME/.cursor/skills")

linked=0
skipped=0
warned=0

for target_dir in "${TARGETS[@]}"; do
  mkdir -p "$target_dir"
  for skill in "${SKILLS[@]}"; do
    src="$SKILLS_SRC/$skill"
    dest="$target_dir/$skill"

    if [[ -L "$dest" ]]; then
      # Already a symlink — we always create these with an absolute
      # target, so a plain readlink compare is enough to detect "already
      # installed, pointing at this clone" vs. stale/foreign.
      if [[ "$(readlink "$dest" 2>/dev/null)" == "$src" ]]; then
        skipped=$((skipped + 1))
        continue
      fi
      echo "warn: $dest is a symlink to something else — leaving it, fix manually if stale" >&2
      warned=$((warned + 1))
      continue
    elif [[ -e "$dest" ]]; then
      echo "warn: $dest already exists and is not a symlink — leaving it" >&2
      warned=$((warned + 1))
      continue
    fi

    ln -s "$src" "$dest"
    linked=$((linked + 1))
  done
done

echo
echo "shipjaw install: $linked linked, $skipped already up to date, $warned need attention"
[[ $warned -gt 0 ]] && echo "(see warnings above — nothing was overwritten)"
echo
echo "Next: open Claude Code or Cursor in any project and run /shipjaw"
