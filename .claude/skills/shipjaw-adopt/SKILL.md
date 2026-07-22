---
name: shipjaw-adopt
description: Adopt Shipjaw on an existing TypeScript/Next app that was not scaffolded with Shipjaw — add documentation/, INDEX, AGENTS.md, Cursor rule, and idempotent tooling gaps. Do not use for greenfield (shipjaw-build), vague idea polishing (shipjaw-prompt), or when knowledge-base/ already exists (shipjaw-ask / migration upgrades). Do not rewrite the app.
---

# shipjaw-adopt

**Adopt only.** Bring an existing app under the Shipjaw continuation
contract **without** re-scaffolding or rewriting the product.

After adopt → use **`shipjaw-ask`**. Never run `shipjaw-build` on a
non-empty app that already has product code.

**Principles:** `../shipjaw-build/references/skill-principles.md`.
**Templates / kit:** `../shipjaw-build/templates/` ·
`../shipjaw-build/templates/scaffold/`.
**Old Shipjaw eras** (KB exists but legacy): use
`../shipjaw-build/references/migration.md` via `shipjaw-ask`, not this
skill.

## Anti-triggers

- No app yet / empty folder → `/shipjaw` then prompt/build
- Rough idea only → `shipjaw-prompt`
- `documentation/knowledge-base/` already present → `shipjaw-ask`
  (apply migration upgrades if needed)
- Non-TypeScript repo → refuse
- User wants a full rewrite / new Next app → `shipjaw-build` in a
  **new** folder, not adopt-in-place

## Workflow

### 1. Detect

Confirm the cwd is an existing TS app (e.g. `package.json` + Next or
React TS). Note package manager, test runner, eslint presence, and
whether any `documentation/` already exists.

If KB already exists → stop; hand off to `shipjaw-ask`.

### 2. Clarify (≤2 questions total)

Only ask what you cannot infer from the repo:

1. One-line product vision / audience (if README is empty or wrong)
2. The single core *User can…* journey today (if unclear)

Do **not** re-run full discovery or redesign the stack.

### 3. Documentation (committed)

Create `documentation/` from `../shipjaw-build/templates/` +
`doc-structure.md`. Fill from **reality** (actual folders, scripts,
deps) — paths/signatures only, no pasted code.

Minimum set:

- `INDEX.md` (with continuation banner)
- `knowledge-base/architecture.md` — real layout; stamp
  `scaffolded-with: shipjaw-build@<VERSION>` and note
  `adopted-with: shipjaw-adopt@<VERSION>` (docs + contract; code pre-existed)
- `domain-model.md`, `features-index.md`, `decisions.md`, `changelog.md`
- `api-reference.md` only if an API/Route Handlers surface exists
- `product/overview.md` (+ design-brief only if design is already clear)
- `technical-plan/00-roadmap.md` + one active phase reflecting **current**
  next work (or “stabilize + document” if no roadmap)

Do not invent features that are not in the code. Mark gaps honestly.

### 4. Continuation contract

Idempotent copy from scaffold kit:

- `AGENTS.md` → repo root
- `shipjaw.cursor-rule.mdc` → `.cursor/rules/shipjaw.mdc`

### 5. Tooling gaps (idempotent, opt-in per file)

From `templates/scaffold/` README: **add missing** strict/tsconfig bits,
eslint no-explicit-any, vitest/playwright scripts, CI/Dependabot,
security headers — only when absent. **Never** overwrite a working
custom eslint/playwright/next config wholesale.

If the tree is not the Shipjaw clean-arch layout: document the real
layout in `architecture.md`; do **not** mass-move folders in adopt.

### 6. Gate sanity

If scripts exist, run what is cheap and already wired (typecheck/lint/
unit). Do not invent a full e2e suite in adopt unless the user asks.
Record known gaps in changelog / roadmap.

### 7. Stop + hand off

Brief reply: what was added, what was left alone, and:

```text
/shipjaw-ask <next feature or fix>
```

## Hard rules

- No `create-next-app`, no product rewrite, no Out-of-v1 feature dump.
- Docs describe **as-is**, then converge via later `shipjaw-ask` tasks.
- Narration budget: detection summary + docs created + handoff command.
- VERSION = contents of `../shipjaw-build/VERSION`.
