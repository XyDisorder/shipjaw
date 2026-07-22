# Discovery questions

Only ask what the prompt didn't already answer. Batch max 4 questions per
round via the host's structured-question tool when available (Claude
Code: `AskUserQuestion`; Cursor: `AskQuestion` if present); otherwise a
numbered list in chat. **Hard budget: max 2 rounds, ~8 questions total**
— then stop asking and default (record defaults in
`design-brief.md` / `overview.md`). Prefer concrete recommended options
over open-ended questions.

## 1. Product scope & audience

- Who is this site for, and what's the core action a visitor should be
  able to take? — skip if the prompt already makes this clear.
- What are the must-have pages/sections for v1? Offer a short list
  inferred from the prompt as the recommended option, "a smaller MVP
  subset" as another, "more — I'll list them" as another.

## 2. Backend & data

- Does this need accounts/login? (No accounts / Simple email login / Full
  auth with roles)
- If auth = yes: ownership model — **single-user** / **org/team** /
  **marketplace (multi-sided)**? Default single-user unless the prompt
  implies otherwise.
- Does it need a database or persisted content, or is content
  static/CMS-driven?
- Any third-party integrations already decided (payments, email,
  analytics, CMS)?

These answers feed the stack-shape **and** library choices — see
`stack-shape.md` + `tech-choices.md` (signal → decision tables). Do not
ask the user to pick Drizzle vs Prisma / Server Actions vs Nest when the
tables already decide from their product answers.
## 3. Design & branding

- Style direction: "minimal/neutral", "bold & colorful",
  "corporate/professional", "playful", or "I have references".
- Existing brand assets (logo, palette, fonts)?
- Light/dark mode: light only / dark only / both (system-aware).
- Do **not** ask about border-radius/spacing/fonts you can default —
  record defaults in `product/design-brief.md` (include sensible
  motion/focus-visible/contrast notes the user can correct).

## 4. Content & locale

- Single language or multiple? If multiple, which ones, and which is the
  default? (Multiple → load `references/modern-extras.md` i18n section
  at scaffold.)

## 5. Constraints & deploy

- Any hard constraint? Offer **none** (default) / **SEO-critical** /
  **needs audit trail/compliance** / **other (I'll specify)**.
- Target host only if it changes scaffolding: **Vercel** / **Docker** /
  **undecided**. (Docker/Vercel → `modern-extras.md` deploy section;
  any real deploy → observability baseline there too.)

## What NOT to ask

- Anything already stated in the prompt.
- Deep implementation detail the user has no opinion on — that belongs in
  `technical-plan/`, not a question for them.
- More than ~8 questions total across all rounds (**hard cap**, not a
  soft hint). Past that, make a reasonable default, write it down, and
  let the user correct later.