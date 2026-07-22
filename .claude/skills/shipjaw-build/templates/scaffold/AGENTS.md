# Agent notes (Shipjaw)

This repository was scaffolded with **Shipjaw**.

- **Continue work:** prefer `/shipjaw-ask <task>` (or obey `.cursor/rules/shipjaw.mdc`
  if the slash skill is not invoked).
- **Source of truth:** `documentation/INDEX.md` → then 1–2 relevant docs.
- **Do not** re-bootstrap with `/shipjaw-build` while `documentation/knowledge-base/`
  exists.
- **New product idea (separate app):** `/shipjaw` in a new folder.

Gate before done: typecheck, lint, unit, e2e as relevant. Keep docs in sync
with what shipped. Types/constants/helpers live by ownership (`domain` /
`application` / `features/<f>/lib`) — no grab-bag `lib/utils.ts`.
