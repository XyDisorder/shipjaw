# Regression prevention & business-rule safety (tiered)

> Open on feature / fix / refactor / migration / dependency change that
> touches behavior. Skip for pure CSS/copy with no product logic.
> Full enterprise BR schemas are **out of scope** — keep docs short.

## Always (every behavior change)

1. **Own invariants in domain/application.** Controllers, Server Actions,
   UI, DB adapters, and external callers must not re-implement or bypass
   critical rules. Prefer explicit domain operations over raw mutation.
2. **Pre-change (short).** Before coding, write 3–5 bullets in the phase
   / plan: affected rules or journeys · expected behavior · tests that
   already protect it · gaps (add characterization if needed). Do **not**
   start while expected behavior is still ambiguous.
3. **Bug fix ⇒ regression test.** Reproduce the bug → fails before fix →
   passes after → covers the failure class when practical. A fix without
   that test is incomplete unless testing is technically impossible
   (justify in the plan).
4. **Never weaken tests to green.** Do not delete, skip, or dilute an
   existing test just to make new code pass. Change a test only when
   product behavior intentionally changes **and** product docs / BR (if
   any) are updated **and** the plan explains why **and** replacement
   coverage exists.
5. **Characterization first on fuzzy legacy.** Capture current behavior
   with tests → mark intentional vs accidental → preserve intentional →
   document intentional changes. Unusual ≠ wrong by default.
6. **Gate before done.** Relevant unit / e2e / typecheck / lint (and
   contract / migration / a11y / build when those exist for the change).
   Confirm no unrelated scenario broke. KB + product docs match what
   shipped.

## When critical (auth, money, multi-state, multi-client, migrations)

Create or update slim rules under `documentation/product/business-rules/`
(see `templates/business-rule.md`). Use stable ids `BR-XXX`.

Also cover as needed:

- **State transitions** — valid states, permitted transitions, reject
  invalid explicitly; test critical / repeated / concurrent paths;
  define unknown/historical state behavior.
- **Contracts** — producers/consumers; backward/forward compat; validate
  inputs; version breaking changes; dual-read/write in migration windows;
  avoid deploy-order traps.
- **Side effects** (email, webhooks, jobs) — only after the primary
  operation succeeds; define trigger, retries, idempotency, duplicates,
  failure visibility, recovery.
- **Deploy / data** — old clients/servers/workers/data compatibility;
  rollback + observability **only** when the change ships beyond local.

## Where rules live

| Situation | Where |
|---|---|
| Simple app, few rules | Invariants in `product/features/<slug>.md` + domain tests |
| ≥1 critical rule (authz, billing, stateful machine, etc.) | `product/business-rules/BR-XXX-<slug>.md` + INDEX row |
| Always | Enforcement in `domain/` / `application/`; tests colocated |

Rules describe **product behavior**, not UI/framework/DB/transport.

## Completion gate (behavior change)

Incomplete until: expected behavior was clear · impacted rules documented
at the right tier · regression risks tested · contracts/compat checked
when applicable · side effects safe when applicable · product + KB
current.
