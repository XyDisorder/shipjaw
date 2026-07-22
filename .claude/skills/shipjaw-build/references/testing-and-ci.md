# Testing strategy & CI

> Read once at scaffold time. The verification gate runs these on every
> task afterward — don't re-read this file just to run tests.

## Testing strategy

- **Unit — Vitest, project-wide.** Mandatory for every `domain/` and
  `application/` addition (happy path + meaningful edge/error). Colocate
  as `<file>.test.ts`. Infrastructure/presentation: only when there's
  real logic; otherwise e2e covers them.
  - Jest **only** if Nest `TestingModule` is required for DI wiring;
    otherwise Vitest everywhere. Record any Jest exception in
    `architecture.md`.
- **E2E — Playwright**, critical flows only (core action from
  `product/overview.md` + explicitly critical acceptance criteria). No
  e2e-per-page.
- **A11y in those same e2e tests:** `@axe-core/playwright` → zero
  critical/serious. Also smoke: primary control reachable by keyboard and
  visibly focused. That is a floor, not WCAG certification.
- **No coverage gate.** Prefer fast, meaningful tests over %. Mock via
  application **ports**, not by reaching into infrastructure internals.
- Playwright: copy `templates/scaffold/playwright.config.ts` (dedicated
  e2e port default **3005**, `webServer`, limited CI retries). Avoid
  port **3000** for e2e so a stray `next dev` does not fail the gate.
  Flakes: fix the race; don't raise retries above 1 in CI.
- Scaffold tooling **day one** — phase 1 can add a test the same way
  phase 10 will.
- **Bug fix ⇒ regression test** that reproduces the bug (fails before,
  passes after). Justify any exception in the phase/plan.
- **Do not delete, skip, or weaken** an existing test merely to make new
  code pass. Intentional behavior change ⇒ update product/BR docs +
  plan note + replacement coverage.
- **Characterization tests** before changing poorly documented behavior.
  Details / tiers: `regression-and-business-rules.md`.

## Verification gate (agent)

Run once at end of phase/task: typecheck → lint → unit → e2e
(plus contract / migration / a11y / build when relevant to the change).
**After 2 failed gate attempts**, stop fixing in a loop: list the
remaining errors, what you tried, and ask the user how to proceed.
Don't burn tokens on a third blind retry.

## CI pipeline

Copy `templates/ci-workflow.yml` → `.github/workflows/ci.yml` and
`templates/dependabot.yml` → `.github/dependabot.yml` (add extra
`directory` entries per app in a monorepo). Pipeline: install →
typecheck → lint → audit → unit → e2e (with Playwright browser install) →
build. Red CI = not done.
