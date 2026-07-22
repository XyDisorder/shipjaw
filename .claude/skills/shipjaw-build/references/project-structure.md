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
      actions.ts               # thin adapters → application (see below)
  components/ui/               # generic primitives only (Button, Input…)
  server/
    domain/
    application/
      ports/                   # one port per file (interfaces only)
    infrastructure/            # port implementations
    composition.ts             # wire ports → use-cases (composition root)
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

## Ports (naming + one file)

- Ports live under `server/application/ports/` as **TypeScript interfaces
  (or abstract types) only** — no implementations, no framework imports.
- **One port per file**, named after the capability:
  `todo-repository.ts` → `export interface TodoRepository { … }`.
- Infrastructure implements with a clear suffix:
  `SqliteTodoRepository`, `PrismaTodoRepository` — file under
  `server/infrastructure/`.
- Application use-cases depend on the **port type**, never on a concrete
  infra class.
- Do not invent ports “for later”; add a port the first time a use-case
  needs an outside capability.

## Composition root (wiring)

- **One place** constructs concrete infra and injects it into use-cases:
  `server/composition.ts` (or `server/composition/<feature>.ts` if the
  file would otherwise exceed ~300 lines).
- Presentation (Server Actions, Route Handlers, RSC loaders) imports
  **wired use-cases / facades from composition** — not
  `infrastructure/` directly.
- Tests: unit-test use-cases with fake/in-memory port implementations;
  do not boot the real DB in domain/application unit tests.

```
features/todos/actions.ts
        → server/composition.ts  (getCreateTodo() / createTodo)
              → application/create-todo.ts(port)
              → infrastructure/sqlite-todo-repository.ts
```

## Server Actions & Route Handlers = thin adapters

Allowed in `features/<f>/actions.ts` / `app/api/...` :

1. Parse/validate input with zod (schema owned by application/contracts)
2. Auth/session re-check if the surface is privileged
3. Call one application use-case (from composition)
4. Map domain/application errors → UI message or HTTP status
5. Revalidate/redirect as needed

**Forbidden in adapters:** SQL/ORM calls, business invariants, multi-step
orchestration that belongs in a use-case, importing infrastructure
repos directly.

## Error → HTTP / UI mapping

Keep a small explicit map (in the adapter or a tiny
`presentation`-level helper next to it — **not** in domain):

| Error kind (domain/application) | HTTP (Route Handler) | UI / Server Action |
|---|---|---|
| validation / zod failure | 400 | field or form error |
| `UnauthorizedError` / unauthenticated | 401 | sign-in / forbidden UI |
| `ForbiddenError` / authz | 403 | not allowed message |
| `NotFoundError` | 404 | not-found UI |
| conflict / duplicate / idempotency | 409 | form-level message |
| other known domain errors | 422 or 400 | stable user message |
| unknown | 500 + log | generic failure (no leak) |

Never `catch { return 500 }` without logging and without trying known
error types first. Prefer typed errors or `Result` over stringly throws.

## Anti-barrel

- Do **not** add `server/domain/index.ts` (or similar) that re-exports the
  whole layer. Import concrete modules:
  `server/domain/todo` — keeps boundaries obvious and avoids cycles.

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

## Types, constants, helpers (placement)

Do **not** leave domain types, magic values, and reusable helpers buried
inside route files, Server Actions, or large components. Split by
**ownership**, not by a global “utils” dump.

| Kind | Where it lives | Notes |
|---|---|---|
| Domain types / value objects / invariants | `server/domain/<concept>.ts` (or co-located `types.ts` next to that concept) | No React, no fetch, no ORM |
| Wire / form / env schemas (zod) | `application/` (or `packages/contracts` in Nest monorepo) | Presentation imports schemas; does not redefine the model |
| Business constants (status, role, limits) | `server/domain/<concept>.constants.ts` (or next to the owning domain module) | Named unions/enums > string literals; see code-standards |
| Pure domain helpers | `server/domain/` next to the rule they serve | Same purity rules as domain |
| Application orchestration helpers | `server/application/` | Still no UI imports |
| Feature-only UI helpers / formatters | `features/<feature>/lib/` | Not imported by domain/application |
| Generic UI primitives | `components/ui/` | Zero feature/domain knowledge |
| Cross-cutting infra only | `src/lib/` (`env.ts`, `logger.ts`, …) | **No** catch-all `utils.ts` / `helpers.ts` |

**Extract when** a type, constant, or helper is reused, or when it
obscures the host file’s one responsibility. **Do not** create empty
folder trees “for later.” **Do not** put business rules in
`features/.../lib/` or `lib/utils.ts`.

Canonical sketch (Next-only) — extend the tree above as concepts appear:

```
src/server/domain/
  todo.ts                 # types + invariants
  todo.constants.ts       # status union / limits
  errors.ts               # NotFoundError, … (shared domain errors)
src/server/application/
  ports/todo-repository.ts
  create-todo.ts          # use-case depends on TodoRepository port
src/server/infrastructure/
  sqlite-todo-repository.ts
src/server/composition.ts # wires SqliteTodoRepository → createTodo
features/todos/
  lib/format-due-date.ts  # UI-only helper
  actions.ts              # thin → composition → use-case
```

## Feature folders

Group by domain concept under `features/`, not by "all hooks / all
components". A component belongs in `components/ui/` only if it has zero
feature-specific logic.
