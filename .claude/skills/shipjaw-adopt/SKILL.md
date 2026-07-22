---
name: shipjaw-adopt
description: Adopts the Shipjaw contract on an existing TypeScript/Next (or React TS) app that was never scaffolded with Shipjaw: surveys docs/plans/phases and architecture practice gaps, merges documentation/, proposes a converge-arch improvement plan, adds AGENTS/Cursor rule and tooling gaps — never rewrites product code unless the user explicitly asks. Use when legacy Next app, foreign create-next-app, ramener ce projet sous Shipjaw, adopter Shipjaw, or incomplete Shipjaw KB. Do not use for empty greenfield (shipjaw-build), vague idea polishing (shipjaw-prompt), or a complete Shipjaw knowledge-base/ (shipjaw-ask).
---

# shipjaw-adopt

**Adopt only.** Bring an existing app under the Shipjaw continuation
contract **without** re-scaffolding or rewriting the product by default.

After adopt → use **`shipjaw-ask`** (including the proposed arch
convergence phase). Never run `shipjaw-build` on a non-empty app that
already has product code.

**Templates / kit:** `../shipjaw-build/templates/` ·
`../shipjaw-build/templates/scaffold/` ·
`../shipjaw-build/templates/technical-plan-converge-arch.md`.
**Complete Shipjaw KB already:** `shipjaw-ask` + migration — not a full
re-adopt.

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
- [ ] ./scripts/survey-adopt-state.sh <root>  (read fully, incl. arch signals)
- [ ] Classify: NO_DOCS | PARTIAL_DOCS | FULL_SHIPJAW_KB
- [ ] If FULL → stop; hand off shipjaw-ask
- [ ] ≤2 clarify Q only for gaps survey couldn't answer
- [ ] init-docs-skeleton (idempotent)
- [ ] Absorb foreign plans → roadmap / features-index / decisions / changelog
- [ ] Architecture practice audit (read-only) → gaps table in architecture.md
- [ ] Propose converge-arch phase (plan only; no mass refactor)
- [ ] copy-continuation-contract + stamp-provenance --adopted
- [ ] Tooling gaps idempotent
- [ ] validate-docs + run-gate (cheap)
- [ ] Status snapshot + improvement plan summary + /shipjaw-ask handoff
```

## Workflow

### 1. Detect + survey (mandatory)

```bash
../shipjaw-build/scripts/survey-adopt-state.sh <project-root>
```

Read **all** sections, including **architecture practice signals**.

| Survey hint | Action |
|---|---|
| `FULL_SHIPJAW_KB` | Stop → `/shipjaw-ask` (+ migration if legacy) |
| `PARTIAL_DOCS` | Continue: **merge**, never wipe |
| `NO_DOCS` | Continue: skeleton then fill |

### 2. Clarify (≤2 questions total)

1. One-line product vision / audience
2. Core *User can…* today

Optional third only if user already asked for refactor scope: *Audit only
vs start P0 slice now?* Default = **audit + plan only**.

### 3. Documentation — create or merge

```bash
../shipjaw-build/scripts/init-docs-skeleton.sh <project-root>
```

Fill as-is; absorb foreign plans (same rules as before).

### 4. Architecture practice audit (read-only — mandatory)

Using survey signals + targeted Grep (do **not** rewrite code here),
score the repo against Shipjaw practices
(`../shipjaw-build/references/project-structure.md` ·
`code-standards.md`):

| Practice | Look for | Gap if… |
|---|---|---|
| Layer folders | `server/domain|application|infrastructure` | missing / logic only in `app/` |
| Ports | `application/ports/*` | use-cases import concrete DB/clients |
| Composition root | `server/composition.ts` | actions `new` repos / import infra |
| Thin adapters | `features/**/actions.ts` | SQL/ORM/domain rules inside actions |
| Typed errors + UI/HTTP map | domain error types | only `throw new Error` / bare 500 |
| Types/consts ownership | `*.constants.ts`, domain types | models only in components |
| No utils grab-bag | `lib/utils.ts` / `helpers.ts` | catch-all shared bag |
| Anti-barrel | layer `index.ts` re-exports | whole-layer barrels |

**Write results into** `documentation/knowledge-base/architecture.md`:

- section **Shipjaw practice gaps** (table: gap · evidence path · P0/P1/P2)
- section **Notable deviations** — current layout is canonical until
  converged; do not pretend clean-arch exists if it doesn’t

Also append one short entry to `decisions.md`: “Adopted Shipjaw contract;
architecture convergence planned, not executed at adopt.”

### 5. Propose improvement plan (mandatory — plan only)

Create (or merge into) a technical-plan phase from
`../shipjaw-build/templates/technical-plan-converge-arch.md`:

- Path eg. `documentation/technical-plan/phase-0N-converge-clean-arch.md`
- Fill the gaps table from the audit; **ordered slices** (core journey
  P0 first; no big-bang)
- Link it from `technical-plan/00-roadmap.md` and INDEX `Current phase`
  if this is the next work (or keep product phase current and list
  converge as following)

**Do not implement** the slices during adopt unless the user **explicitly**
asked to start refactoring in the same message. Default handoff:

```text
/shipjaw-ask Execute P0 from phase-0N-converge-clean-arch (characterization first)
```

### 6. Continuation contract + provenance

```bash
../shipjaw-build/scripts/copy-continuation-contract.sh <project-root>
../shipjaw-build/scripts/stamp-provenance.sh <project-root> --adopted
../shipjaw-build/scripts/validate-docs.sh <project-root>
```

### 7. Tooling gaps (idempotent)

Add missing strict/tsconfig/eslint/test/CI bits only. Never wholesale
replace working configs. Do not mass-move folders to match clean-arch
during adopt — that’s the converge phase.

### 8. Gate sanity

```bash
../shipjaw-build/scripts/run-gate.sh <project-root>
```

### 9. Status snapshot + hand off

Reply **must** include:

1. Docs before → after
2. Shipped / current product phase
3. **Architecture gaps** (top P0/P1)
4. **Proposed improvement plan** (phase path + ordered slices, 3–6 bullets)
5. Explicit: *no structural rewrite done* (unless user asked)

Then hand off to `/shipjaw-ask` for the first P0 slice or the next product
feature.

## Hard rules

- No `create-next-app`, no silent product/architecture rewrite.
- Survey + practice audit + **written plan** are mandatory; execution of
  the plan is **opt-in**.
- Merge > overwrite. Templates never clobber existing content.
- Docs describe **as-is**; the converge phase describes **to-be** slices.
- Narration budget: survey + gaps + plan + handoff.
- VERSION = contents of `../shipjaw-build/VERSION`.
