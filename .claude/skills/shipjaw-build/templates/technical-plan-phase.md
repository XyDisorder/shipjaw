# Phase <N> — <Name>

**Status:** todo | in-progress | done
**Depends on:** <phase(s) or "none">

## Goal
<One paragraph: what this phase delivers and why it's a coherent unit.>

## Out of scope
<What this phase explicitly does NOT cover — push it to a later phase file.>

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

## Business rules (tiered)
- [ ] None critical — invariants noted in feature doc / domain tests only
- [ ] Critical — slim `BR-XXX` under `product/business-rules/`
      (`templates/business-rule.md`) + INDEX row when folder is created

## Tests
- [ ] Unit (Vitest) — `<file>.test.ts`: <happy path + meaningful edge>
- [ ] Bug fix — regression test reproduces failure (fail before / pass after)
- [ ] E2E + a11y (Playwright + axe-core) — only if critical flow:
      `<flow>.spec.ts` — golden path + zero critical/serious axe +
      keyboard/focus smoke on the primary control
- [ ] No existing test deleted/weakened unless intentional behavior change
      (docs + plan updated; replacement coverage in place)

## Acceptance criteria
- [ ] <Concrete, checkable condition>
- [ ] `tsc --noEmit`, lint, and test/e2e all pass (local + CI)
- [ ] If `packages/contracts/` exists: every consumer updated (else n/a)
- [ ] Security: no new secret hardcoded; Server Actions / endpoints
      re-check authz; rate limit if unauthenticated write; middleware
      covers new protected routes (n/a otherwise)
- [ ] Invariants enforced in domain/application (not only UI/adapters)
- [ ] Product / KB / BR docs match shipped behavior
- [ ] ...
