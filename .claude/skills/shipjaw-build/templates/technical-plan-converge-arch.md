# Phase <N> — Converge Shipjaw architecture practices

**Status:** todo
**Depends on:** adopt complete (docs + contract present)
**Demonstrable to a non-dev?** no
<!-- Tech convergence phase — still ship in thin vertical slices via ask. -->

## Challenge (required for non-trivial phases)
<!-- Built-in challenger pass (prefer subagent) before coding — not
     slash-gated. Optional /shipjaw-challenge for a durable report.
     Convergence phases almost always touch money/authz/shared-state
     paths by definition (that's why they're P0) — treat as non-trivial
     by default. Trivial follow-ups inside an already-challenged phase
     may note "covered by challenge on phase-0N <date>". -->
- **Report:** `built-in <date>` | `documentation/technical-plan/challenge-phase-0N-….md`
- **Verdict:** proceed | revise-then-proceed | defer | split-phase
- **Axis calls:** Product __ · Business __ · Tech __ · Pragmatism __ · Design __
- **Plan changes applied after challenge:** <none | bullets>
- **Strongest objection addressed how:** <one line>

## Goal
Close the highest-ROI architecture gaps found during `shipjaw-adopt`
without a big-bang rewrite. Converge toward ports, composition root, thin
adapters, typed errors, and ownership-based types/constants/helpers.

## User can… (business DoD — required)
- [ ] <Keep product behavior unchanged while structure improves — or tie
      each slice to a user-visible fix/feature when possible>

## Out of scope
- Full rewrite / create-next-app restart
- Mass-moving untouched folders “for cleanliness”
- Inventing CQRS/events packages

## Architecture gaps (from adopt audit)
| Gap | Evidence (path) | Priority | Proposed slice |
|---|---|---|---|
| <e.g. no composition root> | `<path or "missing">` | P0/P1/P2 | <one ask-sized task> |
| <e.g. actions call DB> | `features/.../actions.ts` | P0 | extract port + use-case + thin action |
| <e.g. lib/utils.ts bag> | `src/lib/utils.ts` | P1 | split by ownership on touch |
| <e.g. untyped errors> | `...` | P1 | domain errors + UI/HTTP map |

## Recommended order
1. P0 — broken dependency rule on the **core journey** path only
2. P1 — composition root + one port for the main write use-case
3. P1 — thin the hottest Server Action / Route Handler
4. P2 — constants/types extraction and utils-bag breakup (on touch)
5. Optional later — eslint `no-restricted-imports` boundaries

## Tasks
- [ ] Record gaps in `knowledge-base/architecture.md` (done at adopt)
- [ ] Slice 1 — files: `…` (layer: …)
- [ ] Slice 2 — …
- [ ] Add characterization tests before structural moves when behavior is fuzzy

## Types / contracts involved
- Ports to introduce: `<TodoRepository>` — `server/application/ports/…`
- Errors to introduce: `NotFoundError` / … — `server/domain/errors.ts`

## Pre-change (behavior) — 3–5 bullets before coding
- Affected rules / journeys / entities: <core journey paths only at first>
- Expected behavior: unchanged unless a linked product fix is in scope
- Existing tests that protect it: <paths or "none — add characterization">
- Gaps / risks: import cycles, Next server/client boundaries

## Tests
### Unit (Vitest)
- [ ] Happy path for extracted use-case
- [ ] Edges per testing-and-ci matrices for touched domain/application

### E2E (Playwright) — only if a critical journey is touched
- [ ] Golden path still passes

## Verification gate
- [ ] typecheck · lint · unit · e2e (if journey touched)

## Done when
- [ ] P0/P1 slices for the core journey are done **or** explicitly deferred
      with reasons in decisions.md
- [ ] `architecture.md` gaps table updated (resolved / deferred)
- [ ] No product regression on the core *User can…*
