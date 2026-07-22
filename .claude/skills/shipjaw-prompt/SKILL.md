---
name: shipjaw-prompt
description: Turns a rough, messy, or vague product idea into a dense build-ready product prompt and persists it at documentation/product/source-prompt.md for shipjaw-build. Use when the user wants to express/clarify/polish a product before scaffolding, mentions idée vague, brainstorm app, help me write the prompt, notes produit pas prêtes, refine the brief, or the idea is not yet scaffold-ready. Do not scaffold application code or create documentation/knowledge-base/ (that is shipjaw-build). Do not use when knowledge-base/ already exists (shipjaw-ask), the user already has a dense prompt and wants code now (shipjaw-build), or the task is only CSS/copy.
---

# shipjaw-prompt

**Expression only.** Takes messy notes / a vague idea and produces a
**build-ready product prompt** that `shipjaw-build` can consume with
almost no rediscovery. Does **not** scaffold an app, does **not** create
`documentation/knowledge-base/`.

## Anti-triggers

- `documentation/knowledge-base/` exists → `shipjaw-ask` (product already
  bootstrapped)
- User already has a polished prompt and wants code now → `shipjaw-build`
- Pure CSS/copy tweak / non-TypeScript → refuse

## Checklist

```
- [ ] Intake raw idea
- [ ] Clarify gaps only (≤2 rounds / ~8 Q); default the rest
- [ ] Craft dense prompt (references/prompt-craft.md)
- [ ] Write documentation/product/source-prompt.md (never KB)
- [ ] Write documentation/handoff.md → next /shipjaw-build
- [ ] Hand off: /shipjaw-build
```

## Workflow

1. **Intake** — read the user's raw expression (any language, any mess).
2. **Clarify** only gaps — max **2 rounds / ~8 questions** total. Prefer
   structured host questions (`AskUserQuestion` / `AskQuestion`) else
   numbered chat. Use `../shipjaw-build/references/discovery-questions.md`
   as the question bank; skip anything already answered. Then **default**
   and record defaults inside the prompt.
3. **Craft** the prompt — follow `references/prompt-craft.md`. Output must
   be dense, unambiguous, and sufficient for `shipjaw-build` step 1–3.
4. **Persist** — write `documentation/product/source-prompt.md` from
   `templates/source-prompt.md` (create `documentation/product/` only —
   **never** create `knowledge-base/` here). Overwrite only if the user
   confirms when a source-prompt already exists.
5. **Hand off** — show the final prompt in chat and tell the user to run
   `/shipjaw-build` (no args if the file exists, or paste the prompt).

## Hard rules

- No application code, no Next scaffold, no CI, no phase plan beyond an
  optional one-line "suggested v1 scope" inside the prompt.
- No inventing fake constraints the user didn't imply — mark defaults as
  `(default)`.
- Reply in the user's language for questions; the **stored prompt is
  English** unless the user explicitly wants another language for the
  product copy (then note locales in the prompt).
- Narration budget: short status; the deliverable is the prompt file.

## References

- `references/prompt-craft.md`
- `templates/source-prompt.md`
- `../shipjaw-build/references/discovery-questions.md` (questions only)
- Principles: `../shipjaw-build/references/skill-principles.md` (on conflict only)
