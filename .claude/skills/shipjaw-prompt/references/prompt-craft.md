# Prompt craft (expression → build-ready)

Goal: one prompt that lets `shipjaw-build` skip almost all discovery.

## Output shape (required sections)

Write a single markdown document with these headings:

1. **Product one-liner** — what it is + for whom (1–2 sentences).
2. **Core action** — the one thing a user must complete in v1.
3. **Users & roles** — who acts; auth model (none / email / roles) and
   ownership (single-user / org / marketplace) if auth.
4. **v1 scope** — must-have flows/pages as a bullet list.
5. **Out of v1 / non-goals** — explicit exclusions.
6. **Data & integrations** — what persists; third parties (payments,
   email, CMS, analytics) or "none".
7. **Constraints** — SEO-critical / compliance / offline / performance /
   host (Vercel / Docker / undecided) / none.
8. **Design** — style direction, light/dark, brand assets if any, locales
   (default language + extras).
9. **Success criteria** — 3–5 checkable outcomes for v1.
10. **Open defaults** — every assumption marked `(default)` so build can
    record them in overview/design-brief.

## Quality bar

- Concrete nouns over vibes ("todo list with local persistence", not
  "a productivity tool").
- No stack shopping list unless the user mandated a tool — stack is
  chosen by `shipjaw-build` via `tech-choices.md`.
- No UI pixel specs; design direction only.
- Short enough to re-read cheaply (~40–80 lines). Dense > literary.

## Anti-patterns

- Leaving auth/data/locale unspecified when they change the scaffold.
- Expanding into a full PRD / phase plan (that is build's job).
- Copying the user's raw dump without resolving contradictions.
