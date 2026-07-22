#!/usr/bin/env bash
# Run the Shipjaw verification gate using whatever package scripts exist.
# Usage: run-gate.sh <project-root> [--with-e2e]
# Stops on first failure. Skips missing scripts with a note.
set -euo pipefail

ROOT="${1:-}"
WITH_E2E=0
if [[ "${2:-}" == "--with-e2e" ]]; then WITH_E2E=1; fi

if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "usage: $0 <project-root> [--with-e2e]" >&2
  exit 2
fi

cd "$ROOT"

pm() {
  if [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null 2>&1; then
    echo pnpm
  elif [[ -f yarn.lock ]] && command -v yarn >/dev/null 2>&1; then
    echo yarn
  elif [[ -f package-lock.json ]] && command -v npm >/dev/null 2>&1; then
    echo npm
  elif command -v pnpm >/dev/null 2>&1; then
    echo pnpm
  elif command -v npm >/dev/null 2>&1; then
    echo npm
  else
    echo ""
  fi
}

PM="$(pm)"
if [[ -z "$PM" ]]; then
  echo "no package manager found" >&2
  exit 1
fi

has_script() {
  node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts['$1']?0:1)" 2>/dev/null
}

run_script() {
  local name="$1"
  if has_script "$name"; then
    echo "== $PM run $name =="
    if [[ "$PM" == "yarn" ]]; then
      yarn "$name"
    else
      "$PM" run "$name"
    fi
  else
    echo "skip $name (no package.json script)"
  fi
}

run_script typecheck
run_script lint
# prefer test over test:unit
if has_script test; then
  run_script test
elif has_script test:unit; then
  run_script test:unit
else
  echo "skip test (no package.json script)"
fi

if [[ "$WITH_E2E" -eq 1 ]]; then
  if has_script e2e; then
    run_script e2e
  elif has_script test:e2e; then
    run_script test:e2e
  else
    echo "skip e2e (no package.json script)"
  fi
fi

echo "run-gate finished"
