---
name: shipjaw-ask
description: Continue, extend, fix, or resume a Shipjaw app in this repo (has documentation/knowledge-base/ + INDEX.md). Use for features, bugs, refactors, and next-session work — token-cheap INDEX + 1–2 files. Prefer /shipjaw-ask; project rule AGENTS.md / .cursor/rules/shipjaw.mdc apply the same contract. Do not use for greenfield (shipjaw-build), vague idea polishing (shipjaw-prompt), pure one-line CSS/copy, or non-TS repos.
---

# shipjaw-ask

Continuation-only. Do **not** reload bootstrap discovery/architecture or
the full `shipjaw-build` SKILL body. Trust project tooling + docs.
Project owns conventions after bootstrap (principle 16).

**Principles:** `../shipjaw-build/references/skill-principles.md`.
**Old repos:** `../shipjaw-build/references/migration.md` if
`scaffolded-with` missing or docs look legacy.

## Anti-triggers

- No app yet / no KB → if only a rough idea, `shipjaw-prompt`; if a
  build-ready prompt exists (message or `source-prompt.md`),
  `shipjaw-build`
- Task is a one-line copy/CSS change → normal edit, don't load the whole
  continuation protocol beyond a quick INDEX peek if unsure

## Context budget — read in order, stop when enough

1. `documentation/INDEX.md` first. **Open when** = hard filter.
   - Missing INDEX but docs/app exist → repair INDEX (migration-aware).
   - Nothing there → stop; suggest `shipjaw-build`.
2. Only the KB file(s) the task touches (1–2). No archives unless auditing.
3. Active phase file only if needed.
4. At most **one** reference under `../shipjaw-build/references/`, usually
   zero. Never open `discovery-questions.md` / `stack-shape.md` here.
   Prefer `migration.md` when upgrading legacy docs.

Never preload `product/` or the full KB. Broad scope → new phase.

**Code reads:** Grep first; offset/limit on large files.
**Narration:** act; don't dump docs into chat.

## Workflow

1. Read / repair INDEX (check `scaffolded-with`; migrate lightly if needed).
2. ≤1 clarifying question. If the **core behavior** is still ambiguous
   after that → **stop** and ask the human (principle 18); do not invent
   the business rule.
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
