# Project structure

> Read once at scaffold time; re-consult during implementation only when
> a new file's placement or size is genuinely ambiguous.

## Clean architecture layers (per app)

- `domain/` — entities, value objects, pure business rules / invariants.
  Zero imports from infrastructure, frameworks, or presentation. No
  `fetch`, no ORM, no React, no Nest decorators. Critical rules live here
  (or in `application/` use-cases), never only in UI/adapters — see
  `regression-and-business-rules.md`.
- `application/` — use-cases/services that orchestrate domain objects;
  defines **ports** (interfaces) for anything it needs from the outside (a
  repository interface, an email-sender interface...). Depends on `domain`
  only.
- `infrastructure/` — implements the ports: DB repositories (e.g.
  Prisma/Drizzle), external API clients, file storage, auth providers.
  Depends inward on `application`'s interfaces, never the reverse.
- `presentation/` — Next.js: `app/` routes, server actions, React
  components. NestJS: controllers, DTOs, guards. Kept thin — delegates to
  `application`, no business logic here.
- **Dependency rule**: arrows only point inward (presentation →
  application → domain; infrastructure → application's ports → domain).
  `domain` never imports anything from the other three layers.

## Canonical trees (pick one — do not invent a third)

### Next.js only (default)

```
src/
  app/                         # App Router — presentation only
    (marketing)/...
    (app)/...
    api/                       # Route Handlers (public/webhooks only)
  features/
    <feature>/
      components/
      hooks/
      actions.ts               # Server Actions → application use-cases
  components/ui/               # generic primitives only (Button, Input…)
  server/
    domain/
    application/
    infrastructure/
  lib/
    env.ts                     # zod-parsed env (from templates/scaffold)
    logger.ts
middleware.ts                  # auth gate for protected route groups
```

Record the chosen tree in `knowledge-base/architecture.md` on day one.
Default runtime: **Node** unless a specific route truly needs Edge — note
any Edge exception in architecture.md.

### Monorepo (only if NestJS was added)

See `monorepo-and-nestjs.md`. Web app still uses the same layering; shared
domain lives in `packages/domain` **only if both apps truly share it**.

## API surface matrix (Next)

| Need | Use |
|---|---|
| Form / mutation from this Next UI | **Server Action** in `features/<f>/actions.ts` |
| Public HTTP API, webhooks, mobile later | **Route Handler** under `app/api/` |
| Multiple non-web clients or heavy workers | **NestJS** (stack-shape already decided this) |

Do not mix all three for the same use-case. Authz still runs in
`application/` regardless of entry point.

## React / Next presentation rules

- Default to **Server Components**. Add `'use client'` only for
  interactivity (state, effects, browser APIs) — push it to the smallest
  leaf component.
- Never import server-only modules (`server/`, `env` secrets) into a
  client component. Prefer a Server Action or a thin server wrapper.
- Use `next/image` for user-facing images; set metadata (`title`,
  `description`) per route for SEO-critical pages.
- **Dynamic when data is per-request or file/local DB-backed:** on those
  routes set `export const dynamic = "force-dynamic"` (or equivalent).
  Omitting it lets Next statically shell the page at build time — empty
  lists / stale shells in e2e and prod.

## File size & responsibility

- **Hard cap: 500 lines per file.** Treat ~300 lines as the signal to
  start planning a split, not the cap itself.
- One responsibility per file: a component that fetches data, holds
  complex local state, AND renders a large tree should be split into a
  hook (data/state) + smaller presentational components.
- Prefer several small, well-named files over one large one.

## Feature folders

Group by domain concept under `features/`, not by "all hooks / all
components". A component belongs in `components/ui/` only if it has zero
feature-specific logic.
