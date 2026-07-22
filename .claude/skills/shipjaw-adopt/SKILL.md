---
name: shipjaw-adopt
description: Adopts the Shipjaw contract on an existing TypeScript/Next (or React TS) app that was never scaffolded with Shipjaw: creates documentation/ + INDEX.md, AGENTS.md, .cursor/rules/shipjaw.mdc, provenance stamps, and fills missing tooling gaps idempotently — never rewrites product code or re-runs create-next-app. Use when legacy Next app, foreign create-next-app, ramener ce projet sous Shipjaw, adopter Shipjaw, bring this codebase under Shipjaw, migrate docs onto an existing repo, or the app has code but no documentation/knowledge-base/. Do not use for empty greenfield (shipjaw-build), vague idea polishing (shipjaw-prompt), or when knowledge-base/ already exists (shipjaw-ask / migration). Do not rewrite the app.
---

# shipjaw-adopt

**Adopt only.** Bring an existing app under the Shipjaw continuation
contract **without** re-scaffolding or rewriting the product.

After adopt → use **`shipjaw-ask`**. Never run `shipjaw-build` on a
non-empty app that already has product code.

**Templates / kit:** `../shipjaw-build/templates/` ·
`../shipjaw-build/templates/scaffold/`.
**Old Shipjaw eras** (KB exists but legacy): `shipjaw-ask` +
`../shipjaw-build/references/migration.md` — not this skill.

## Anti-triggers

- No app yet / empty folder → `/shipjaw` then prompt/build
- Rough idea only → `shipjaw-prompt`
- `documentation/knowledge-base/` already present → `shipjaw-ask`
  (apply migration upgrades if needed)
- Non-TypeScript repo → refuse
- User wants a full rewrite / new Next app → `shipjaw-build` in a
  **new** folder, not adopt-in-place

## Checklist

```
- [ ] Detect TS/Next app; abort if KB exists
- [ ] ≤2 clarify Q (vision + core User can…) if needed
- [ ] ../shipjaw-build/scripts/init-docs-skeleton.sh <root>
- [ ] Fill placeholders from real codebase (paths only)
- [ ] ../shipjaw-build/scripts/copy-continuation-contract.sh <root>
- [ ] ../shipjaw-build/scripts/stamp-provenance.sh <root> --adopted
- [ ] Idempotent tooling gaps only (no wholesale config overwrite)
- [ ] ../shipjaw-build/scripts/validate-docs.sh <root>
- [ ] ../shipjaw-build/scripts/run-gate.sh <root> (cheap; e2e only if asked)
- [ ] Hand off: /shipjaw-ask <next task>
```

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

Prefer the skeleton script, then fill from **reality**:

```bash
../shipjaw-build/scripts/init-docs-skeleton.sh <project-root>
```

Fill placeholders from actual folders, scripts, deps — paths/signatures
only, no pasted code. See `../shipjaw-build/references/doc-structure.md`.

Minimum after fill: INDEX, architecture (real layout), domain-model,
features-index, decisions, changelog, product/overview, roadmap + one
active phase. `api-reference.md` only if an API surface exists. Do not
invent features that are not in the code.

### 4. Continuation contract + provenance

```bash
../shipjaw-build/scripts/copy-continuation-contract.sh <project-root>
../shipjaw-build/scripts/stamp-provenance.sh <project-root> --adopted
../shipjaw-build/scripts/validate-docs.sh <project-root>
```

### 5. Tooling gaps (idempotent, opt-in per file)

From `templates/scaffold/` README: **add missing** strict/tsconfig bits,
eslint no-explicit-any, vitest/playwright scripts, CI/Dependabot,
security headers — only when absent. **Never** overwrite a working
custom eslint/playwright/next config wholesale.

If the tree is not the Shipjaw clean-arch layout: document the real
layout in `architecture.md`; do **not** mass-move folders in adopt.

### 6. Gate sanity

```bash
../shipjaw-build/scripts/run-gate.sh <project-root>
```

Add `--with-e2e` only if the user asks or a critical journey is already
covered. Record known gaps in changelog / roadmap.

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
