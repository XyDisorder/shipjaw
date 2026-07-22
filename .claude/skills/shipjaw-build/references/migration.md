# Migration & compatibility

> For agents on repos scaffolded by an older Shipjaw (or the former
> names `shipjaw`, `skill-my-app` / `ask-my-app`). Read only when
> `architecture.md` lacks `scaffolded-with`, docs look gitignored, or
> INDEX/layout diverges from current expectations.

## Detect era

1. Read `documentation/knowledge-base/architecture.md` for
   `scaffolded-with: shipjaw-build@<VERSION>` (legacy:
   `scaffolded-with: shipjaw@…` or `skill-my-app@…` — treat as valid).
2. If missing: treat as **pre-version-stamp** (before 2026.07.22).
3. If `documentation/` is gitignored or absent from git but present
   locally: **pre-committed-docs** era.
4. If only `documentation/product/source-prompt.md` exists (no KB):
   expression happened via `shipjaw-prompt` — run `shipjaw-build`, do not
   treat as an existing app.

## Always do (any era)

- Prefer `shipjaw-ask` when any `documentation/knowledge-base/` exists.
- Repair missing `INDEX.md` from the tree rather than re-bootstrapping.
- Do **not** force a full re-scaffold to "upgrade" the skill.

## Foreign projects (never used Shipjaw)

If the repo has app code but **no** `documentation/knowledge-base/`,
do **not** use this file as a green light to bootstrap. Run
**`shipjaw-adopt`** instead (docs + contract + idempotent gaps, no
rewrite). After adopt, continue with `shipjaw-ask`.

## Era-specific upgrades (opt-in, one per task unless user asks for all)

| Gap | Upgrade |
|---|---|
| No `scaffolded-with` line | Add `scaffolded-with: shipjaw-build@<current VERSION>` + note "upgraded docs only" |
| `documentation/` gitignored | Remove from `.gitignore`, commit docs (ask user if secrets might be in docs first) |
| Docs contain large code fences | Convert touched sections to paths/signatures only when you edit them |
| No Open-when column in INDEX | Add it on next INDEX edit |
| Flat / non-canonical folders | Don't move the tree unless the task requires it; record actual layout in architecture.md |
| Missing eslint/tsconfig strict bits | Add only the missing flags/files from `templates/scaffold/` (**idempotent** — don't overwrite custom rules) |
| No `AGENTS.md` / `.cursor/rules/shipjaw.mdc` | Copy from scaffold kit if missing (idempotent) |
| INDEX lacks continuation banner | Add the shipjaw-ask pointer at the top on next INDEX edit |
| Types/consts/helpers dumped in UI or `lib/utils.ts` | On touched code, relocate per `project-structure.md` placement table (don't mass-move unrelated files) |
| Actions/handlers call infra or embed business rules | Thin adapter + port + composition root on the touched path |
| Errors only as `throw new Error` / bare 500 | Introduce typed domain errors + map per Error→HTTP/UI table when touching that flow |
| No decisions/changelog rotation | Start rotating when files next cross thresholds |
| Assumes `packages/contracts/` but Next-only | Skip contracts rule; don't create the package |

## Do not

- Re-run discovery or stack-shape on an existing project.
- Replace a working Playwright/eslint setup wholesale with the template.
- Treat "old layout" as failure — document reality, then converge slowly.
