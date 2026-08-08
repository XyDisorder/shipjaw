# Prompt craft (expression → build-ready)

Goal: one prompt that lets `shipjaw-build` skip almost all discovery
**and** force a ruthless MVP (principle 18 — core journey first).

## Output shape (required sections)

Write a single markdown document with these headings:

1. **Product one-liner** — what it is + for whom (1–2 sentences).
2. **Core action** — **exactly one** thing a user must complete in v1.
   Write it as *User can …*. If you have two, one is Out of v1.
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
   action e2e-able**.
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

## v1 scope trim gate (mandatory, before persisting)

Before writing `source-prompt.md`, re-read every bullet under **v1 scope**
and ask: does the **core action** literally not work without it? If the
honest answer is "no, but it'd be nice" — cut it to **Out of v1**, however
small it looks. This is the step that actually produces a ruthless MVP;
the Quality bar above states the rule, this gate is what enforces it.

Signs a bullet needs cutting: it's a growth/retention layer (streaks,
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
