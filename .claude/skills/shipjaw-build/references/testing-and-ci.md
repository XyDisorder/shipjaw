# Testing strategy & CI

> Read once at scaffold time. The verification gate runs these on every
> task afterward — don't re-read this file just to run tests.

## Testing strategy

- **Unit — Vitest, project-wide.** Mandatory for every `domain/` and
  `application/` addition. Colocate as `<file>.test.ts`.
  Infrastructure/presentation: only when there's real logic; otherwise
  e2e covers them.
  - Jest **only** if Nest `TestingModule` is required for DI wiring;
    otherwise Vitest everywhere. Record any Jest exception in
    `architecture.md`.
- **E2E — Playwright**, critical flows only (core action / *User can…*
  from the active phase + explicitly critical acceptance criteria). No
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

## Edge cases — what goes where (pragmatic)

Default: **domain/application rules → unit**; **user-visible outcomes of
the critical journey → e2e**. Do not duplicate the same matrix in both
layers.

### Unit (Vitest) — required set for each new domain/application behavior

| Case | Required? | Notes |
|---|---|---|
| Happy path | **yes** | Main success result / state transition |
| Validation / invariant reject | **yes** | Empty input, invalid shape, business forbidden |
| Not-found / missing entity | **yes** if the use-case loads by id | Typed domain/application error |
| Unauthorized / ownership | **yes** if authz lives in application | Never only tested in UI |
| Boundary values | **yes** when numbers/dates/limits matter | min/max, empty collection |
| Idempotent re-entry | **yes** if operation may retry | Double submit / same command twice |
| Concurrency / race | only if critical + multi-writer | Keep small; otherwise document n/a |

Skip speculative cases not in the phase *User can…* / Out of scope.

### E2E (Playwright) — required set for each **critical** journey only

| Case | Required? | Notes |
|---|---|---|
| Golden path (*User can…*) | **yes** | Principle 18 — not done without it |
| Empty state | **yes** if the journey has a list/inbox/home with zero data | Assert copy/CTA, not just "no crash" |
| Inline / form error | **yes** if the journey submits input | Invalid submit shows recoverable error |
| Unauthorized | **yes** if the route/action is protected | Redirect or explicit deny — match product |
| Not-found UI | **yes** if users can hit a missing resource URL | |
| A11y + keyboard smoke | **yes** on the same critical spec | axe + primary control focus |
| Multi-browser / mobile matrix | **no** by default | Add only if prompt demands it |
| Every edge already covered in unit | **no** | Don't re-test pure validation in e2e |

Non-critical phases: unit edges only; e2e optional.

### Mapping rule of thumb

- Pure function / use-case decision → **unit**
- "User sees X after clicking Y" → **e2e**
- Bug fix → one regression test at the **lowest layer that caught it**
  (unit if domain; e2e if only reproducible in the UI)

List the chosen edge cases in the phase **Tests** section (paths + which
row of the tables above). `n/a` must say why.

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
