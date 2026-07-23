#!/usr/bin/env bash
# Report knowledge-base drift: doc content vs current code reality.
# Complements validate-docs.sh (section/file presence) with checks that
# actually look at whether the docs still describe the repo as it is today.
# Mixed severity, deliberately: checks #1-3 are informational (see "Known
# limitations" — tested against a real, organically-written project and
# found too many legitimate false positives to safely hard-block on).
# Check #4 is a hard fail — tested against the same real project with zero
# false positives, precise enough to gate on. Exit 1 only from #4.
#
#   1. Dangling path references — a KB file points at a file/dir that
#      doesn't resolve (checked at repo root, then under src/ — the
#      canonical tree). Catches real drift (renamed/deleted files) but
#      also flags legitimate shorthand the check can't resolve.
#   2. Staleness heuristic — code under src/app/packages changed after a
#      KB file's last git update. A human/agent still has to judge whether
#      the change was KB-relevant.
#   3. Pending-migration heuristic (code ahead of docs, direction #1/#2
#      can't see) — a migration file was added/changed after
#      features-index.md was last updated. Can't check the actual DB state
#      from a static script: flags "go verify this was applied and
#      documented," does not prove either way.
#   4. Feature module vs docs (code ahead of docs, hard fail) — a top-level
#      folder under src/modules, src/features, or features/ whose name
#      never appears in features-index.md. A short distinctive folder
#      name is far less ambiguous to match than a full file path, so this
#      one is precise enough to block on — this is what would have caught
#      the actual incident (a shipped module absent from the docs).
#
# Known limitations of checks #1-3 (found via real-project testing, not
# fixed):
#   - Paths that drop an intermediate segment in prose (e.g. doc says
#     `composition/gallery.ts` for real path `src/shared/composition/
#     gallery.ts`) or a Next.js route-group folder (`(protected)`) will
#     misreport as missing. Omitted file extensions likewise.
#   - A path mentioned only as a negative example ("ports live in
#     `*.port.ts`, not `application/ports/`") reads the same as a real
#     reference and will misreport as missing.
#
# Scope: only files doc-structure.md calls "the single source of truth for
# how the site works today" (architecture/domain-model/api-reference/
# features-index + business-rules/BR-*.md). changelog.md and decisions.md
# are historical logs by design and are not checked here.
#
# Usage: validate-docs-drift.sh <project-root>
set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root>" >&2
  exit 2
fi

DOC="$ROOT/documentation"

ok()   { printf '  OK   %s\n' "$1"; }
warn() { printf '  WARN %s\n' "$1"; }
miss() { printf '  MISS %s\n' "$1"; }

REALITY_FILES=(
  "$DOC/knowledge-base/architecture.md"
  "$DOC/knowledge-base/domain-model.md"
  "$DOC/knowledge-base/api-reference.md"
  "$DOC/knowledge-base/features-index.md"
)
shopt -s nullglob
REALITY_FILES+=("$DOC"/product/business-rules/BR-*.md)
shopt -u nullglob

extract_paths() {
  local file="$1"
  {
    # inline `path/like/this` spans
    grep -oE '`[A-Za-z0-9_./-]*/[A-Za-z0-9_./-]+`' "$file" | tr -d '`' || true
    # bare paths inside fenced ``` blocks (e.g. architecture.md folder trees)
    awk '/^```/{f=!f;next} f' "$file" \
      | sed -E 's/^[[:space:]]+|[[:space:]]+$//g' \
      | grep -E '^[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)+/?$' || true
  } | sort -u
}

echo "== KB drift: path references (informational — see script header) =="
any_reality=0
for f in "${REALITY_FILES[@]}"; do
  [[ -f "$f" ]] || continue
  any_reality=1
  rel="${f#"$ROOT"/}"
  checked=0
  file_miss=0
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    path="${path#./}"
    [[ "$path" == "<"* || "$path" == *"<"* ]] && continue   # template placeholder
    [[ "$path" == "..."* ]] && continue                     # prose abbreviation ("…/foo/bar.ts")
    [[ "$path" == *"://"* ]] && continue                    # URL
    [[ "$path" == /* ]] && continue                         # route, not a repo path
    [[ "$path" == "path/to/"* ]] && continue                # template boilerplate
    # bare `api/...` with no file extension reads as a REST endpoint written
    # shorthand (e.g. "api/invitation/validate-code"), not a literal file
    # path — too ambiguous to check without knowing the exact route-group
    # folder name (ex: app/api/... vs app/(group)/api/...).
    [[ "$path" == api/* && "$path" != *.* ]] && continue
    checked=$((checked + 1))
    resolved="$ROOT/${path%/}"
    [[ -e "$resolved" ]] || resolved="$ROOT/src/${path%/}"  # canonical tree keeps code under src/
    if [[ ! -e "$resolved" ]]; then
      warn "$rel references unresolved path: $path (may be legitimate shorthand — see Known limitations)"
      file_miss=1
    fi
  done < <(extract_paths "$f")
  if [[ "$checked" -eq 0 ]]; then
    warn "$rel — no path references found to check"
  elif [[ "$file_miss" -eq 0 ]]; then
    ok "$rel ($checked path ref(s), all resolve)"
  fi
done
if [[ "$any_reality" -eq 0 ]]; then
  warn "no knowledge-base reality files found — run from a scaffolded project"
fi

echo ""
echo "== KB staleness (informational — git history) =="
if ! command -v git >/dev/null 2>&1; then
  warn "git not found — skipping staleness check"
elif ! git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  warn "not a git repo — skipping staleness check"
else
  SRC_DIRS=()
  for d in src app packages; do
    [[ -d "$ROOT/$d" ]] && SRC_DIRS+=("$d")
  done
  if [[ "${#SRC_DIRS[@]}" -eq 0 ]]; then
    warn "no src/app/packages directory found — skipping staleness check"
  else
    for f in "${REALITY_FILES[@]}"; do
      [[ -f "$f" ]] || continue
      rel="${f#"$ROOT"/}"
      last="$(git -C "$ROOT" log -1 --format='%h %cs' -- "$rel" 2>/dev/null || true)"
      if [[ -z "$last" ]]; then
        warn "$rel not tracked by git yet — skipping staleness check"
        continue
      fi
      last_hash="${last%% *}"
      last_date="${last#* }"
      changed="$(git -C "$ROOT" log --oneline "${last_hash}..HEAD" -- "${SRC_DIRS[@]}" 2>/dev/null | wc -l | tr -d ' ')"
      if [[ "$changed" -gt 0 ]]; then
        warn "$rel last updated $last_date ($last_hash) — $changed commit(s) touched ${SRC_DIRS[*]} since — verify it still matches"
      else
        ok "$rel — no code commits since last update ($last_date)"
      fi
    done
  fi
fi

echo ""
echo "== Pending migrations vs docs (informational — code ahead of docs) =="
FEATURES_INDEX="$DOC/knowledge-base/features-index.md"
if ! command -v git >/dev/null 2>&1; then
  warn "git not found — skipping migration check"
elif ! git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  warn "not a git repo — skipping migration check"
elif [[ ! -f "$FEATURES_INDEX" ]]; then
  warn "no features-index.md — skipping migration check"
else
  MIGRATION_DIRS=()
  # Verified tool defaults only (drizzle-kit `out`, Prisma, Supabase CLI) —
  # not guesses.
  for d in drizzle prisma/migrations supabase/migrations; do
    [[ -d "$ROOT/$d" ]] && MIGRATION_DIRS+=("$d")
  done
  if [[ "${#MIGRATION_DIRS[@]}" -eq 0 ]]; then
    ok "no migration directory found — nothing to check"
  else
    feat_last="$(git -C "$ROOT" log -1 --format='%h %cs' -- "documentation/knowledge-base/features-index.md" 2>/dev/null || true)"
    if [[ -z "$feat_last" ]]; then
      warn "features-index.md not tracked by git yet — skipping migration check"
    else
      feat_hash="${feat_last%% *}"
      feat_date="${feat_last#* }"
      new_migrations="$(git -C "$ROOT" log --oneline "${feat_hash}..HEAD" -- "${MIGRATION_DIRS[@]}" 2>/dev/null | wc -l | tr -d ' ')"
      if [[ "$new_migrations" -gt 0 ]]; then
        warn "${MIGRATION_DIRS[*]}: $new_migrations commit(s) touched migrations since features-index.md was last updated ($feat_date, $feat_hash) — confirm the migration was applied (db:migrate) and the feature is documented"
      else
        ok "${MIGRATION_DIRS[*]} — no migration changes since features-index.md was last updated ($feat_date)"
      fi
    fi
  fi
fi

echo ""
echo "== Feature modules vs docs (code ahead of docs) =="
# Lower-ambiguity than the path-reference check above: a top-level feature
# module folder name is a short, distinctive word — far less prone to the
# abbreviation/route-group issues that forced the path check to be
# informational-only. If a module exists in code but its name appears
# nowhere in features-index.md, that's a real, high-confidence signal the
# doc was never updated for it (exactly the Phase 6 incident this script
# exists to catch). Hard fail — this is precise enough to gate on.
FEATURE_MODULE_FAIL=0
FEATURE_DIRS=()
for d in src/modules src/features features; do
  [[ -d "$ROOT/$d" ]] && FEATURE_DIRS+=("$ROOT/$d")
done
DENYLIST=(shared common lib core types utils ui __tests__ node_modules)
if [[ "${#FEATURE_DIRS[@]}" -eq 0 ]]; then
  ok "no src/modules, src/features, or features/ directory found — nothing to check"
elif [[ ! -f "$FEATURES_INDEX" ]]; then
  warn "no features-index.md — skipping feature-module check"
else
  any_module=0
  for fd in "${FEATURE_DIRS[@]}"; do
    while IFS= read -r name; do
      [[ -z "$name" ]] && continue
      skip=0
      for d in "${DENYLIST[@]}"; do [[ "$name" == "$d" ]] && skip=1; done
      [[ "$skip" -eq 1 ]] && continue
      any_module=1
      if ! grep -qi -- "$name" "$FEATURES_INDEX"; then
        miss "feature module '$name' (${fd#"$ROOT"/}/$name) not mentioned anywhere in features-index.md"
        FEATURE_MODULE_FAIL=1
      fi
    done < <(find "$fd" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
  done
  if [[ "$any_module" -eq 1 && "$FEATURE_MODULE_FAIL" -eq 0 ]]; then
    ok "every feature module is mentioned in features-index.md"
  fi
fi

if [[ "$FEATURE_MODULE_FAIL" -ne 0 ]]; then
  echo ""
  echo "validate-docs-drift FAILED (feature module undocumented — see WARN above)"
  echo "(path-reference / staleness / migration checks above are informational only)"
  exit 1
fi

echo ""
echo "validate-docs-drift done (path/staleness/migration checks informational only)"
