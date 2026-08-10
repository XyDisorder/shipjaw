# Prompt craft (expression → build-ready)

Goal: one prompt that lets `shipjaw-build` skip almost all discovery
**and** force a ruthless MVP (principle 18 — core journey first).

## Output shape (required sections)

Write a single markdown document with these headings:

1. **Product one-liner** — what it is + for whom (1–2 sentences).
2. **Core action** — **exactly one** thing a user must complete in v1.
   Write it as *User can …*, describing only the mechanical action. No
   "personalized / adaptive / tailored to X" qualifiers — those imply a
   whole second system (skill tracking, recommendation logic) is
   load-bearing for v1 when it usually isn't. If you have two, one is Out
   of v1.
3. **Users & roles** — who acts; auth model (none / email / roles) and
   ownership (single-user / org / marketplace) if auth.
4. **v1 scope** — only what is required to complete the **core action**
   (flows as journeys, not a wishlist of pages).
5. **Out of v1 / non-goals** — ruthless list: auth extras, second roles,
   Nest, i18n, payments, polish, admin, etc. unless the core action
   *literally cannot work* without them. Prefer "none needed for core
   action" over speculative platform work.
6. **Data & integrations** — what persists; third parties (payments,
   email, CMS, analytics) or "none".
7. **Constraints** — SEO-critical / compliance / offline / performance /
   host (Vercel / Docker / undecided) / none.
8. **Design** — style direction, light/dark, brand assets if any, locales
   (default language + extras).
9. **Success criteria** — 3–5 checkable outcomes; **#1 must be the core
   action e2e-able** and test exactly **one** capability — never chain
   several features into one "end-to-end" bullet (not "sign up, complete
   onboarding, do X, get Y" as a single checkbox). A criterion may depend
   on auth existing; it must not require every adjacent feature to also
   fire inside the same checkbox.
10. **Open defaults** — every assumption marked `(default)` so build can
    record them in overview/design-brief.

## Quality bar

- Concrete nouns over vibes ("todo list with local persistence", not
  "a productivity tool").
- **One core action.** Everything else is Out of v1 until that ships.
- No stack shopping list unless the user mandated a tool — stack is
  chosen by `shipjaw-build` via `tech-choices.md`.
- No UI pixel specs; design direction only.
- Short enough to re-read cheaply (~40–80 lines). Dense > literary.

## Scope trim gate (mandatory, before persisting)

Real catch: on a real project, `shipjaw-build`'s own built-in challenger
proposed deferring an onboarding quiz out of v1 — and was **overridden**,
because the prompt's own Success criteria #1 had already chained "sign up
→ onboarding quiz → submit → review" into one end-to-end bullet, and Core
action already said the review was "tailored to skill level." Trimming
**v1 scope** alone isn't enough if Core action or Success criteria
quietly re-lock what it cuts — check all three, in this order:

1. **Core action** — read it back: does it name anything beyond the one
   mechanical action (a personalization/adaptation clause, a second
   actor, a scoring/tracking system)? Strip it to the action alone; move
   anything else down to v1 scope, where it can then get cut.
2. **v1 scope** — for every bullet, does the core action literally not
   work without it? If the honest answer is "no, but it'd be nice" — cut
   it to **Out of v1**, however small it looks.
3. **Success criteria** — does any bullet chain more than one feature
   into a single "end-to-end" outcome? Split it, or drop the extra step —
   a criterion may depend on auth existing, it must not require every
   adjacent feature to also fire inside the same checkbox.

Signs a v1-scope bullet needs cutting: a growth/retention layer (streaks,
badges, XP, gamification), a second workflow orbiting the core action
(a dashboard, a reference/cheat-sheet page, an admin view), or a system
whose payoff only lands once several *other* things also ship (an
adaptive/recommendation engine, a content pipeline, a skill-placement
quiz gating the "real" feature). Cut it and write one clause on what
breaks without it if genuinely load-bearing — not "would be nicer with
it."

If you find yourself wanting to add a note like "if this feels large, you
could trim X, Y, Z" at the end of the prompt — stop, and do that trim now,
inside v1 scope itself. A hedge appended after persisting means the gate
was skipped, not that the scope was fine.

## Anti-patterns

- Leaving auth/data/locale unspecified when they change the scaffold.
- Expanding into a full PRD / phase plan (that is build's job).
- Copying the user's raw dump without resolving contradictions.
- "v1 scope" that is really a roadmap (auth + billing + admin + i18n).
- Multiple peer "core actions" — pick one; park the rest in Out of v1.
