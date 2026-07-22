# Scaffold kit

Copy these into the new app at workflow step 5. Adapt names/paths to the
canonical tree in `project-structure.md`. Do **not** invent parallel
configs when these exist.

## Idempotent copy rules

- **Missing file** → copy from this kit.
- **File exists and already satisfies the rule** (e.g. `strict: true`,
  CSP headers, Playwright `webServer`) → leave it; do not overwrite.
- **File exists but is missing a required bit** → merge minimally (add
  the flag/header/script only).
- **Re-running scaffold / migrating an old app** → same rules; never
  replace a working custom eslint/playwright setup wholesale.

| File | Copy to (Next-only) | When |
|---|---|---|
| `tsconfig.base.json` | `tsconfig.json` (merge) | always |
| `eslint.config.mjs` | repo root | always |
| `vitest.config.ts` | repo root | always |
| `playwright.config.ts` | repo root | always |
| `src/env.ts` | `src/lib/env.ts` | always |
| `src/lib/logger.ts` | `src/lib/logger.ts` | always |
| `next.config.ts` | repo root | always (headers + `turbopack.root` / `outputFileTracingRoot`) |
| `playwright.config.ts` | repo root | always (e2e on port **3005** by default) |
| `middleware.ts` | repo root | when auth/protected routes exist |
| `Dockerfile` | repo root | when deploy = Docker |
| `AGENTS.md` | repo root | always (Shipjaw continuation pointer) |
| `shipjaw.cursor-rule.mdc` | `.cursor/rules/shipjaw.mdc` | always (Cursor alwaysApply contract) |

Prefer the skill scripts (idempotent) instead of hand-copying those two:

```bash
# from shipjaw-build skill dir
./scripts/copy-continuation-contract.sh <project-root>
./scripts/stamp-provenance.sh <project-root>            # build
./scripts/stamp-provenance.sh <project-root> --adopted  # adopt
```

**Pages that read a local DB:** add `export const dynamic = "force-dynamic"`
on the route module (see `project-structure.md`).

Monorepo: put shared bits in `packages/config/`, app-specific in
`apps/web` / `apps/api`.
