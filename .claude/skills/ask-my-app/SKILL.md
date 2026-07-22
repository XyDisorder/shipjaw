---
name: ask-my-app
description: Continue or extend a skill-my-app project (has documentation/knowledge-base/ + INDEX.md). Token-cheap — INDEX plus one or two task files. Trigger on feature/fix/extend. Do not use for greenfield apps (skill-my-app), pure CSS/copy tweaks, or non-TS repos.
---

# ask-my-app

Continuation-only. Do **not** reload bootstrap discovery/architecture or
the full `skill-my-app` SKILL body. Trust project tooling + docs.
Project owns conventions after bootstrap (principle 16).

**Principles:** `../skill-my-app/references/skill-principles.md`.
**Old repos:** `../skill-my-app/references/migration.md` if
`scaffolded-with` missing or docs look legacy.

## Anti-triggers

- No app yet / no KB → `skill-my-app` (or refuse non-TS / cosmetic-only)
- Task is a one-line copy/CSS change → normal edit, don't load the whole
  continuation protocol beyond a quick INDEX peek if unsure

## Context budget — read in order, stop when enough

1. `documentation/INDEX.md` first. **Open when** = hard filter.
   - Missing INDEX but docs/app exist → repair INDEX (migration-aware).
   - Nothing there → stop; suggest `skill-my-app`.
2. Only the KB file(s) the task touches (1–2). No archives unless auditing.
3. Active phase file only if needed.
4. At most **one** reference under `../skill-my-app/references/`, usually
   zero. Never open `discovery-questions.md` / `stack-shape.md` here.
   Prefer `migration.md` when upgrading legacy docs.

Never preload `product/` or the full KB. Broad scope → new phase.

**Code reads:** Grep first; offset/limit on large files.
**Narration:** act; don't dump docs into chat.

## Workflow

1. Read / repair INDEX (check `scaffolded-with`; migrate lightly if needed).
2. ≤1 clarifying question.
3. Implement via project config as source of truth:
   - domain/application → Vitest
   - critical flow → Playwright + axe + keyboard/focus
   - contracts consumers only if package exists
   - actions/endpoints → authz + session + middleware as needed
4. One gate; ≤2 fix attempts; then ask human.
5. Surgical KB updates (paths/signatures only); rotate logs; archive
   done phases. Idempotent: don't rewrite unrelated docs.
6. Suggest `/compact` (Claude) or fresh chat / handoff (Cursor).
