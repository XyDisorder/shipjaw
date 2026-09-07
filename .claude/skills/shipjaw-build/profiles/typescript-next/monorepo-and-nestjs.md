# Monorepo layout & NestJS conventions

> Only relevant if `stack-shape.md` concluded a separate NestJS API is
> needed. Skip this file entirely for the Next.js-only case — it doesn't
> apply and isn't worth the tokens.

## Monorepo layout

```
apps/
  web/            # Next.js — presentation + thin server actions/API client
  api/            # NestJS app
packages/
  domain/         # shared ONLY if both apps use the same entities/rules
  contracts/      # zod schemas / DTOs / types shared on the wire
  config/         # shared tsconfig base, eslint base
```

Package manager: pnpm workspaces + turborepo, unless the user prefers
otherwise. Record in `knowledge-base/architecture.md`.

Do **not** create `packages/domain` "for symmetry" — if only `api` needs
domain logic, keep it inside `apps/api` (or `apps/api/src/server/`).

## Shared contract discipline

Applies **only when `packages/contracts/` exists**. A change to any
type/schema there is not done until every consumer in `apps/web` and
`apps/api` is updated in the *same* task and both typecheck/test green.
Breaking changes → short-form entry in `knowledge-base/decisions.md`.

For Next-only projects there is no `packages/contracts/` — share types
inside `src/server/` / feature modules instead.

## NestJS conventions

- One module per bounded context; controllers stay thin (validate → call
  application service → map result).
- **Prefer zod** for DTO/input validation, aligned with `packages/contracts/`
  (same schemas). Use `class-validator` only if the team already depends
  on it — pick one project-wide and record it in `architecture.md`.
- Cross-cutting via guards/interceptors/filters, not copy-paste.

## Nest scaffold checklist (day one)

- `ConfigModule` for env (zod-validated, same keys as `.env.example`)
- `helmet()` + explicit CORS allowlist
- `@nestjs/throttler` on auth/public writes
- Global validation pipe (zod or class-validator — matching the choice above)
- Health endpoint (`@nestjs/terminus` or a minimal `/health`)
- Logger aligned with the web app's logging approach
