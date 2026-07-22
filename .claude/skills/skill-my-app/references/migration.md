# Migration & compatibility

> For agents on repos scaffolded by an older skill-my-app. Read only when
> `architecture.md` lacks `scaffolded-with`, docs look gitignored, or
> INDEX/layout diverges from current expectations.

## Detect era

1. Read `documentation/knowledge-base/architecture.md` for
   `scaffolded-with: skill-my-app@<VERSION>`.
2. If missing: treat as **pre-version-stamp** (before 2026.07.22).
3. If `documentation/` is gitignored or absent from git but present
   locally: **pre-committed-docs** era.

## Always do (any era)

- Prefer `ask-my-app` when any `documentation/knowledge-base/` exists.
- Repair missing `INDEX.md` from the tree rather than re-bootstrapping.
- Do **not** force a full re-scaffold to "upgrade" the skill.

## Era-specific upgrades (opt-in, one per task unless user asks for all)

| Gap | Upgrade |
|---|---|
| No `scaffolded-with` line | Add `scaffolded-with: skill-my-app@<current VERSION>` + note "upgraded docs only" |
| `documentation/` gitignored | Remove from `.gitignore`, commit docs (ask user if secrets might be in docs first) |
| Docs contain large code fences | Convert touched sections to paths/signatures only when you edit them |
| No Open-when column in INDEX | Add it on next INDEX edit |
| Flat / non-canonical folders | Don't move the tree unless the task requires it; record actual layout in architecture.md |
| Missing eslint/tsconfig strict bits | Add only the missing flags/files from `templates/scaffold/` (**idempotent** — don't overwrite custom rules) |
| No decisions/changelog rotation | Start rotating when files next cross thresholds |
| Assumes `packages/contracts/` but Next-only | Skip contracts rule; don't create the package |

## Do not

- Re-run discovery or stack-shape on an existing project.
- Replace a working Playwright/eslint setup wholesale with the template.
- Treat "old layout" as failure — document reality, then converge slowly.
