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

## Tests
- [ ] Unit (Vitest) — `<file>.test.ts`: <happy path + meaningful edge>
- [ ] E2E + a11y (Playwright + axe-core) — only if critical flow:
      `<flow>.spec.ts` — golden path + zero critical/serious axe +
      keyboard/focus smoke on the primary control

## Acceptance criteria
- [ ] <Concrete, checkable condition>
- [ ] `tsc --noEmit`, lint, and test/e2e all pass (local + CI)
- [ ] If `packages/contracts/` exists: every consumer updated (else n/a)
- [ ] Security: no new secret hardcoded; Server Actions / endpoints
      re-check authz; rate limit if unauthenticated write; middleware
      covers new protected routes (n/a otherwise)
- [ ] ...
