---
name: shipjaw-adopt
description: Adopts the Shipjaw contract on an existing TypeScript/Next (or React TS) app that was never scaffolded with Shipjaw: surveys existing docs/plans/phases, creates or merges documentation/ + INDEX.md, AGENTS.md, Cursor rule, provenance stamps, and fills tooling gaps — never rewrites product code. Use when legacy Next app, foreign create-next-app, ramener ce projet sous Shipjaw, adopter Shipjaw, bring this codebase under Shipjaw, or app has code but incomplete/missing Shipjaw KB. Do not use for empty greenfield (shipjaw-build), vague idea polishing (shipjaw-prompt), or a complete Shipjaw knowledge-base/ (shipjaw-ask). Do not rewrite the app.
---

# shipjaw-adopt

**Adopt only.** Bring an existing app under the Shipjaw continuation
contract **without** re-scaffolding or rewriting the product.

After adopt → use **`shipjaw-ask`**. Never run `shipjaw-build` on a
non-empty app that already has product code.

**Templates / kit:** `../shipjaw-build/templates/` ·
`../shipjaw-build/templates/scaffold/`.
**Complete Shipjaw KB already** (INDEX + architecture + features-index):
`shipjaw-ask` + `../shipjaw-build/references/migration.md` — not a
full re-adopt.

## Anti-triggers

- No app yet / empty folder → `/shipjaw` then prompt/build
- Rough idea only → `shipjaw-prompt`
- **Complete** Shipjaw KB already (`documentation/INDEX.md` +
  `knowledge-base/architecture.md` + `features-index.md`) →
  `shipjaw-ask` (migration upgrades if needed). **Partial** docs →
  stay here and **merge** (never wipe).
- Non-TypeScript repo → refuse
- User wants a full rewrite / new Next app → `shipjaw-build` in a
  **new** folder, not adopt-in-place

## Checklist

```
- [ ] Detect TS/Next app
- [ ] ./scripts/survey-adopt-state.sh <root>  (read output fully)
- [ ] Classify: NO_DOCS | PARTIAL_DOCS | FULL_SHIPJAW_KB
- [ ] If FULL → stop; hand off shipjaw-ask
- [ ] ≤2 clarify Q only for gaps survey couldn't answer
- [ ] init-docs-skeleton (idempotent — skips existing files)
- [ ] Absorb foreign plans → roadmap / features-index / decisions / changelog
- [ ] Fill as-is status: shipped vs next phase (*User can…*)
- [ ] copy-continuation-contract + stamp-provenance --adopted
- [ ] Tooling gaps idempotent
- [ ] validate-docs + run-gate (cheap)
- [ ] Status snapshot in reply + hand off /shipjaw-ask
```

## Workflow

### 1. Detect + survey (mandatory)

Confirm TS app (`package.json` + Next/React TS). Then **execute and
read**:

```bash
../shipjaw-build/scripts/survey-adopt-state.sh <project-root>
```

The survey reports:

- stack / scripts
- which Shipjaw `documentation/` files exist (and phase files + status)
- foreign planning docs (`README`, `ROADMAP`, `docs/`, ADRs, `TODO`, …)
- route/page surface
- recent git commits/tags
- routing hint: `NO_DOCS` | `PARTIAL_DOCS` | `FULL_SHIPJAW_KB`

**Routing:**

| Survey hint | Action |
|---|---|
| `FULL_SHIPJAW_KB` | Stop → `/shipjaw-ask` (+ migration if legacy) |
| `PARTIAL_DOCS` | Continue adopt: **merge**, never overwrite real content with blank templates |
| `NO_DOCS` | Continue adopt: skeleton then fill from code + foreign plans |

### 2. Clarify (≤2 questions total)

Only ask what survey + README still leave open:

1. One-line product vision / audience
2. The single core *User can…* journey **today** (what already works)

Do **not** re-run full discovery or redesign the stack.

### 3. Documentation — create or merge

```bash
../shipjaw-build/scripts/init-docs-skeleton.sh <project-root>
```

Idempotent: existing files are **skipped**. Then the agent must:

1. **Fill / repair** Shipjaw files from **reality** (paths/signatures only).
2. **Absorb** foreign plans into Shipjaw homes (do not leave two sources
   of truth):
   - roadmaps / TODOs / phase notes → `technical-plan/00-roadmap.md` +
     active `phase-*.md` (status: todo | doing | done)
   - shipped features from README/routes/git → `features-index.md`
   - ADRs / decision notes → `decisions.md`
   - prior changelogs → `changelog.md` (summaries, not dumps)
3. Infer **where we are**:
   - INDEX `Current phase:` = active phase or “stabilize + document”
   - roadmap lists done vs next with honest status
   - one active phase whose *User can…* matches what works **or** the
     next concrete slice — never invent a fake multi-phase history
4. If foreign `docs/` remain, note in `architecture.md` /
   `decisions.md` that Shipjaw `documentation/` is now canonical; link
   paths, don’t duplicate bodies.

### 4. Continuation contract + provenance

```bash
../shipjaw-build/scripts/copy-continuation-contract.sh <project-root>
../shipjaw-build/scripts/stamp-provenance.sh <project-root> --adopted
../shipjaw-build/scripts/validate-docs.sh <project-root>
```

### 5. Tooling gaps (idempotent)

From `templates/scaffold/` README: add **missing** bits only. Never
wholesale-replace working eslint/playwright/next config. Document real
layout; do not mass-move folders.

### 6. Gate sanity

```bash
../shipjaw-build/scripts/run-gate.sh <project-root>
```

`--with-e2e` only if asked or a critical journey is already covered.

### 7. Status snapshot + hand off

Reply must include a short **where we are** block:

- Docs before → after (created / merged / left alone)
- Shipped (from features-index / routes)
- Current phase + next *User can…*
- Known gaps (tests, a11y, clean-arch drift)

Then:

```text
/shipjaw-ask <next feature or fix>
```

## Hard rules

- No `create-next-app`, no product rewrite, no Out-of-v1 feature dump.
- Survey before skeleton. Merge > overwrite. Templates never clobber
  existing content (`init-docs-skeleton` skips).
- Docs describe **as-is** status; phases reflect reality, not a fake
  greenfield roadmap.
- Narration budget: survey summary + status snapshot + handoff.
- VERSION = contents of `../shipjaw-build/VERSION`.
