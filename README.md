# skill-my-app

Source of truth for two companion agent skills (Claude Code + Cursor)
that scaffold and maintain TypeScript/Next.js (+ NestJS when needed)
websites with enforced best practices.

- `.claude/skills/skill-my-app/` — **bootstrap** (initial build only)
- `.claude/skills/ask-my-app/` — **continuation** (INDEX + few files)

Do **not** use them for one-off CSS/copy tweaks or non-TypeScript repos.

## Installation

### Project-level (this repo)

- **Claude Code:** `.claude/skills/*`
- **Cursor:** `.cursor/skills/*` (symlinks → `.claude/skills/`)

### Global (any project)

```sh
mkdir -p ~/.claude/skills ~/.cursor/skills

ln -s "$(pwd)/.claude/skills/skill-my-app" ~/.claude/skills/skill-my-app
ln -s "$(pwd)/.claude/skills/ask-my-app" ~/.claude/skills/ask-my-app

ln -s "$(pwd)/.claude/skills/skill-my-app" ~/.cursor/skills/skill-my-app
ln -s "$(pwd)/.claude/skills/ask-my-app" ~/.cursor/skills/ask-my-app
```

Keep both skills as siblings so `ask-my-app` can resolve
`../skill-my-app/references/` when needed.

## Usage

```
/skill-my-app <describe the site/app you want>
```

Later:

```
/ask-my-app <the feature/fix you want next>
```

`documentation/` is committed. Compact between tasks: `/compact`
(Claude) or a fresh chat / short handoff (Cursor).

## Maintainers

After editing skills or templates:

```sh
./scripts/smoke-check.sh
```

Bump `.claude/skills/skill-my-app/VERSION` (`YYYY.MM.DD`) when behavior
changes; scaffolded apps stamp `scaffolded-with: skill-my-app@<VERSION>`
in `architecture.md`. Old apps: see
`references/migration.md` — upgrade lightly, never forced re-bootstrap.

Principles: `references/skill-principles.md` (1–16). Changelog:
`CHANGELOG.md`.
