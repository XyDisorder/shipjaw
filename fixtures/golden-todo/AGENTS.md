# Agent notes (Shipjaw)

This repository was scaffolded with **Shipjaw**.

- **Continue work:** prefer `/shipjaw-ask <task>` (or obey `.cursor/rules/shipjaw.mdc`).
- **Source of truth:** `documentation/INDEX.md` → then 1–2 relevant docs.
- **Handoff:** read/update `documentation/handoff.md` at session boundaries.
- **Do not** re-bootstrap with `/shipjaw-build` while `documentation/knowledge-base/` exists.

Gate before done: typecheck, lint, unit, e2e as relevant. Types/constants/helpers
by ownership — no grab-bag `lib/utils.ts`. Ports + `composition.ts`; thin adapters.
