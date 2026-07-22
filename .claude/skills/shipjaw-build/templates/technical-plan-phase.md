# Phase <N> — <Name>

**Status:** todo | in-progress | done
**Depends on:** <phase(s) or "none">
**Demonstrable to a non-dev?** yes | no
<!-- Principle 18: prefer yes. Tech-only phases (eslint/CI) only when
     blocking the core journey. -->

## Goal
<One paragraph: what this phase delivers and why it's a coherent unit.>

## User can… (business DoD — required)
- [ ] <Observable outcome in product language, e.g. "create a todo and see it listed">
<!-- If you cannot write this, the phase is too tech-centric — split or merge. -->

## Out of scope
- <Explicit exclusions for this phase — push to a later phase file>
- Non-goals carried from product overview that stay out

## Journey (if this phase touches a user flow)
- Trigger: <how the user starts>
- Steps: <1 → 2 → 3>
- Success: <what they see / have>
- Failure: <empty | error | unauthorized — expected behavior>
<!-- Skip this section only for pure infra with no UX surface. -->

## Tasks
- [ ] <Task> — files: `path/to/file.ts` (layer: domain|application|infrastructure|presentation)
- [ ] ...

## Types / contracts involved
- `TypeName` — `path/to/file.ts` — <one-line shape or role>
- <ExportName> — `path/to/schema.ts` — <fields / purpose>

## Pre-change (behavior) — 3–5 bullets before coding
- Affected rules / journeys / entities: <or "n/a — no behavior change">
- Expected behavior (clear enough to test): <one or two lines>
- Existing tests that protect it: <paths or "none — add characterization">
- Gaps / risks: <compat, side effects, concurrency — or "none">
<!-- Do not start implementation while expected behavior is ambiguous. -->

## Challenge (required for non-trivial phases)
<!-- Built-in challenger pass (prefer subagent) before coding — not
     slash-gated. Optional /shipjaw-challenge for a durable report.
     Trivial follow-ups inside an already-challenged phase may note
     "covered by challenge on phase-0N <date>". -->
- **Report:** `built-in <date>` | `documentation/technical-plan/challenge-phase-0N-….md`
- **Verdict:** proceed | revise-then-proceed | defer | split-phase
- **Axis calls:** Product __ · Business __ · Tech __ · Pragmatism __ · Design __
- **Plan changes applied after challenge:** <none | bullets>
- **Strongest objection addressed how:** <one line>

## Business rules (tiered)
- [ ] None critical — invariants noted in feature doc / domain tests only
- [ ] Critical — slim `BR-XXX` under `product/business-rules/`
      (`templates/business-rule.md`) + INDEX row when folder is created

## Tests
- [ ] Unit (Vitest) — `<file>.test.ts`: happy path + **required edges**
      from `testing-and-ci.md` (validation/reject, not-found, authz,
      boundaries, idempotency as applicable) — list cases or `n/a + why`
- [ ] Bug fix — regression test reproduces failure (fail before / pass after)
- [ ] Core journey e2e (Playwright) — **required when "User can…" is a
      critical flow / phase-01 product slice**: golden path succeeds
- [ ] E2E edges on that critical flow — empty · form error · unauthorized
      · not-found UI as applicable (`testing-and-ci.md` e2e table); do
      **not** re-test pure domain validation already covered in unit
- [ ] E2E + a11y extras — axe zero critical/serious + keyboard/focus on
      primary control (same spec when e2e exists)
- [ ] No existing test deleted/weakened unless intentional behavior change
      (docs + plan updated; replacement coverage in place)

## Acceptance criteria
- [ ] Every "User can…" checkbox above is true
- [ ] Challenge section complete for non-trivial phases (or explicit skip reason)
- [ ] Nothing from Out of scope was implemented
- [ ] `tsc --noEmit`, lint, and test/e2e all pass (local + CI)
- [ ] If `packages/contracts/` exists: every consumer updated (else n/a)
- [ ] Security: no new secret hardcoded; Server Actions / endpoints
      re-check authz; rate limit if unauthenticated write; middleware
      covers new protected routes (n/a otherwise)
- [ ] Invariants enforced in domain/application (not only UI/adapters)
- [ ] Product / KB / BR docs match shipped behavior
- [ ] ...
