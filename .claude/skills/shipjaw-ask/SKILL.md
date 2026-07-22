---
name: shipjaw-ask
description: Continues, extends, fixes, or resumes a Shipjaw app that already has documentation/knowledge-base/ + INDEX.md. Use for features, bugs, refactors, next-session work, "continue this repo", or when AGENTS.md / .cursor/rules/shipjaw.mdc apply. Token-cheap — INDEX then 1–2 files. Do not use for greenfield (shipjaw-build), adopting a foreign app with no KB (shipjaw-adopt), vague idea polishing (shipjaw-prompt), pure one-line CSS/copy, or non-TS repos.
---

# shipjaw-ask

Continuation-only. Do **not** reload bootstrap discovery/architecture or
the full `shipjaw-build` SKILL body. Trust project tooling + docs.

## Binding defaults (do not open principles unless conflict)

1. State lives in committed `documentation/` — update before done.
2. Progressive disclosure — INDEX → ≤2 files; Grep + offset reads.
3. Project owns conventions after bootstrap (tsconfig/eslint/CI/docs).
4. Core *User can…* first; no Out-of-v1 / drive-by scope.
5. Bug ⇒ failing-then-passing regression test; never weaken tests to green.
6. Gate once; **stop after 2** failed fix attempts; ask the human.

**Old repos only:** `../shipjaw-build/references/migration.md`.

## Anti-triggers

- No app yet / no KB → if only a rough idea, `shipjaw-prompt`; if a
  build-ready prompt exists (message or `source-prompt.md`),
  `shipjaw-build`; if an **existing** TS app has no KB → `shipjaw-adopt`
- Task is a one-line copy/CSS change → normal edit, don't load the whole
  continuation protocol beyond a quick INDEX peek if unsure

## Context budget — read in order, stop when enough

1. `documentation/INDEX.md` first. **Open when** = hard filter.
   - Missing INDEX but docs/app exist → repair INDEX (migration-aware).
   - Nothing there → stop; suggest `shipjaw-build` or `shipjaw-adopt`.
2. Only the KB file(s) the task touches (1–2). No archives unless auditing.
3. Active phase file only if needed.
4. At most **one** reference under `../shipjaw-build/references/`, usually
   **zero**. Never open `discovery-questions.md` / `stack-shape.md` /
   `skill-principles.md` here by default.

Never preload `product/` or the full KB. Broad scope → new phase.

**Code reads:** Grep first; offset/limit on large files.
**Narration:** act; don't dump docs into chat.

## Checklist

```
- [ ] Read / repair INDEX
- [ ] ≤1 clarifying Q; stop if core behavior still ambiguous
- [ ] Implement (journey-first; domain tests; e2e edges if critical)
- [ ] One gate; ≤2 fix attempts
- [ ] Surgical doc updates
- [ ] Suggest /compact or fresh chat
```

## Workflow

1. Read / repair INDEX (check `scaffolded-with`; migrate lightly if needed).
2. ≤1 clarifying question. If the **core behavior** is still ambiguous
   after that → **stop** and ask the human; do not invent the business rule.
3. Implement via project config as source of truth:
   - prefer the active phase's *User can…* / journey over drive-by polish
   - do not implement Out-of-v1 / out-of-phase scope "while we're here"
   - domain/application → Vitest; invariants owned there (not UI-only)
   - bug fix → regression test (fail before / pass after)
   - never weaken/skip existing tests just to green
   - critical flow → Playwright golden path + e2e edges (empty / form
     error / unauthorized / not-found as applicable) + axe + keyboard/focus
   - unit edges for new domain/application behavior (see
     `../shipjaw-build/references/testing-and-ci.md` tables) — don't
     duplicate pure validation in e2e
   - critical auth/money/state/multi-client → slim BR +
     `../shipjaw-build/references/regression-and-business-rules.md` if needed
   - contracts consumers only if package exists
   - actions/endpoints → authz + session + middleware as needed
4. One gate; ≤2 fix attempts; then ask human.
5. Surgical KB / product updates (paths/signatures only); rotate logs;
   archive done phases. Idempotent: don't rewrite unrelated docs.
6. Suggest `/compact` (Claude) or fresh chat / handoff (Cursor).
