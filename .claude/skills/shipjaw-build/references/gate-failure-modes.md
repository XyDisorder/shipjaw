# Gate failure modes (check before a 3rd attempt)

> Open **only after the 2nd failed verification gate** (or when the error
> message clearly matches a row below). Do not preload at task start.
> Prefer environment/config fixes that don't count as a "logic" retry
> when the skill says so (busy e2e port, etc.).

## Quick triage

| Symptom | Likely cause | Fix |
|---|---|---|
| Playwright can't bind / `EADDRINUSE` / page empty on 3000 | Dev server already on 3000; e2e should use dedicated port | Use scaffold Playwright port **3005**; kill stray `next dev` or set `webServer.port` |
| E2E list/page empty though unit tests pass | Route statically shelled at build | `export const dynamic = "force-dynamic"` on DB/per-request routes |
| `better-sqlite3` / native module build fail | Host blocks native compile (pnpm approve-builds) | Apply `tech-choices.md` data-layer **fallback** (e.g. `node:sqlite`); ADR in decisions.md |
| Type error importing server module into client | `'use client'` file pulls `server/` or secret `env` | Move import behind Server Action / server wrapper; keep client leaf thin |
| Gate fails: actions talk to DB directly / circular imports | Adapter not thin; missing composition root | Port + use-case + `composition.ts`; action only validate → call → map error |
| `zod` / env crash at boot | Missing env or schema too strict for local | Fill `.env.local` from documented keys; never commit secrets |
| ESLint `no-explicit-any` / unsafe | Boundary not narrowed | Parse with zod at edge; no `as any` |
| Vitest can't resolve `@/` or server paths | Alias / vitest config drift | Align `vitest.config.ts` aliases with tsconfig paths |
| Playwright timeout waiting for UI | Race, missing await, wrong selector | Fix race; don't raise CI retries above 1 |
| Axe critical/serious | Missing labels, contrast, roles | Fix a11y in the critical journey; don't disable axe |
| `create-next-app` refuses non-empty dir | Docs already written | Scaffold into **temp dir**, merge into project (workflow.md) |
| Turbopack / tracing wrong root | Nested workspace confusion | `turbopack.root` + `outputFileTracingRoot` pinned to app root |
| Tests pass locally, fail in CI | Env, port, timing | Reproduce with CI-like Playwright config; pin Node version if needed |

## Retry policy reminder

1. First failure → fix the concrete error.
2. Second failure → **read this file**, apply matching row, one more focused fix.
3. Still red → **stop**, ask the human (paste gate output + which row you tried).

Do not weaken tests, skip e2e, or delete assertions to go green.
