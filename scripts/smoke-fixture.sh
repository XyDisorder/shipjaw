#!/usr/bin/env bash
# Assert fixtures/golden-todo matches the Shipjaw "good output" shape.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIX="$ROOT/fixtures/golden-todo"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; FAIL=1; }

echo "== golden fixture layout =="
for f in \
  "$FIX/README.md" \
  "$FIX/package.json" \
  "$FIX/AGENTS.md" \
  "$FIX/.cursor/rules/shipjaw.mdc" \
  "$FIX/documentation/INDEX.md" \
  "$FIX/documentation/handoff.md" \
  "$FIX/documentation/knowledge-base/architecture.md" \
  "$FIX/documentation/knowledge-base/domain-model.md" \
  "$FIX/documentation/knowledge-base/features-index.md" \
  "$FIX/documentation/knowledge-base/decisions.md" \
  "$FIX/documentation/knowledge-base/changelog.md" \
  "$FIX/documentation/product/overview.md" \
  "$FIX/documentation/technical-plan/00-roadmap.md" \
  "$FIX/documentation/technical-plan/phase-01-create-todo.md" \
  "$FIX/src/server/domain/todo.ts" \
  "$FIX/src/server/domain/todo.constants.ts" \
  "$FIX/src/server/domain/errors.ts" \
  "$FIX/src/server/application/ports/todo-repository.ts" \
  "$FIX/src/server/application/create-todo.ts" \
  "$FIX/src/server/infrastructure/memory-todo-repository.ts" \
  "$FIX/src/server/composition.ts" \
  "$FIX/features/todos/actions.ts" \
  "$FIX/features/todos/lib/format-title.ts"
do
  if [[ -f "$f" ]]; then ok "${f#"$FIX"/}"
  else bad "missing ${f#"$ROOT"/}"
  fi
done

echo "== golden fixture content contracts =="
if grep -q 'scaffolded-with:' "$FIX/documentation/knowledge-base/architecture.md"; then
  ok "architecture has scaffolded-with"
else bad "architecture missing scaffolded-with"; fi

if grep -q 'User can' "$FIX/documentation/technical-plan/phase-01-create-todo.md"; then
  ok "phase has User can…"
else bad "phase missing User can…"; fi

if grep -q 'Next command' "$FIX/documentation/handoff.md" \
  && grep -q 'shipjaw-ask' "$FIX/documentation/handoff.md"; then
  ok "handoff has next shipjaw-ask command"
else bad "handoff missing next command"; fi

if grep -q 'interface TodoRepository' "$FIX/src/server/application/ports/todo-repository.ts"; then
  ok "port interface present"
else bad "missing TodoRepository port"; fi

if grep -q 'composition' "$FIX/features/todos/actions.ts" \
  && ! grep -qiE 'prisma|drizzle|better-sqlite|MemoryTodoRepository' "$FIX/features/todos/actions.ts"; then
  ok "actions thin (composition, no infra class)"
else bad "actions should use composition only (no infra)"; fi

if grep -q 'createTodo' "$FIX/src/server/composition.ts"; then
  ok "composition wires use-case"
else bad "composition missing wiring"; fi

echo "== golden fixture drift check =="
# validate-docs-drift.sh is informational-only (see its header) and always
# exits 0 on a valid project-root — this only checks it runs without
# crashing and that our own controlled fixture reports zero unresolved
# refs (a real regression would show up as an unexpected WARN here).
drift_out="$(mktemp)"
if ! "$ROOT/.claude/skills/shipjaw-build/scripts/validate-docs-drift.sh" "$FIX" > "$drift_out" 2>&1; then
  bad "validate-docs-drift.sh crashed on golden fixture"
  cat "$drift_out"
elif grep -q 'unresolved path' "$drift_out"; then
  bad "validate-docs-drift.sh found an unresolved path on the golden fixture (should be zero)"
  cat "$drift_out"
else
  ok "validate-docs-drift.sh ran clean on golden fixture"
fi
rm -f "$drift_out"

if [[ "$FAIL" -ne 0 ]]; then
  echo "smoke-fixture FAILED"
  exit 1
fi
echo "smoke-fixture PASSED"
