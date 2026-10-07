# Prod readiness (on-demand — not a mandatory gate)

> Read when: the user is about to deploy/launch an app publicly, asks
> "is this ready for production / to launch," or a phase's Constraints
> say the app is public-facing. **Not** part of the per-phase gate — a
> purely local/private dev tool never needs this file. Scale to actual
> stakes (same spirit as `challenge-built-in.md` "Scale the pass to
> actual stakes") — don't run the full list against a solo hobby tool
> just because it's technically deployed.

Real catch (2026-10-07, conference feedback, capitalized on): scattered
prod concerns already existed (`security.md`, `modern-extras.md`'s
Deploy/Observability sections, per-phase Acceptance criteria) but no
single place answered "is this app actually ready" once a project moves
past the first phase and gets real deployed use (`tcg-collection`,
`mtg-deck-optimizer` both are). Every item below must be **checkable
without ambiguity** — pass/fail, not a feeling ("the app feels solid" is
not a checklist item; "pnpm build succeeds" is).

## Tier 1 — every deployed app, no exception (even a solo personal tool)

- [ ] `pnpm build` succeeds (not just `pnpm dev`) — dev-mode-only bugs
  (e.g. a CSP missing `'unsafe-eval'`, discovered live on
  `mtg-deck-optimizer`) do not count as proof the production build works
- [ ] No secrets committed; `.env.example` documents every required env
  var, nothing hardcoded
- [ ] Security headers present (scaffold `next.config.ts` CSP/headers
  unmodified-or-deliberately-adjusted, not silently dropped)
- [ ] `pnpm audit` clean (or documented exceptions) — already in the CI
  pipeline, confirm it's not being ignored
- [ ] A real external-service failure (API down, bad response) surfaces
  as a clear, typed error to the user — not an unhandled crash or a
  silent empty state. Real catch: Scryfall rejecting a default
  `fetch` User-Agent on `mtg-deck-optimizer` surfaced as 133 silent
  "couldn't be checked" cards until the response body was actually
  logged — log the real failure reason, not just a status code
- [ ] `handoff.md` + `INDEX.md` current enough that the owner can pick
  the project back up in 3 months without this session's memory

## Tier 2 — any app with auth, persisted user data, or unauthenticated writes

All of Tier 1, plus:
- [ ] Error/observability reporting wired (Sentry or equivalent) behind
  an `infrastructure/` port, not deferred indefinitely — `modern-extras.md`
  names this but doesn't gate it; this file does, once auth/data exist
- [ ] Rate limiting on every unauthenticated write surface, not just
  "where it felt necessary"
- [ ] Migrations are reversible, or the rollback plan is written down —
  not assumed
- [ ] Who gets paged / how an incident is noticed — even a one-line
  answer ("I check manually") beats no answer

## Tier 3 — real external users, money, or regulated/personal data

Not yet dogfooded on any real Shipjaw project as of 2026-10-07 — write
concrete items here only against a real project that actually needs this
tier, not speculatively. Candidates to validate when that project exists:
terms/privacy for collected personal data, backup cadence, on-call
rotation, GDPR-class handling if EU user data is involved.

## How to apply

Pick the highest tier that matches the project's real stakes (per
`overview.md` — auth? money? persisted data? real external users?), run
only that tier plus the ones below it. A Tier-1-only project that
suddenly adds auth moves to Tier 2 from that point on — note the shift
as a decision in `decisions.md`, don't silently skip the new tier's items.
