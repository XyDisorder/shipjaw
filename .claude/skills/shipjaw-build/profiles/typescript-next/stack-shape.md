# Stack shape: when to add NestJS

> Read once at workflow step 3, together with `tech-choices.md` (prompt →
> concrete library/API choices).

Default to **Next.js only** (App Router; Server Actions + Route Handlers
as needed). Add a **separate NestJS app** only when at least one of
these is true:

- A real standalone API is consumed by more than the Next.js frontend
  (mobile app, third-party integrations, public API).
- There's non-trivial background/async work: queues, workers, scheduled
  jobs, webhooks needing durable processing.
- Business logic is complex/heavy enough to want strict layering + DI
  independent of any frontend framework lifecycle.
- The user/prompt explicitly asks for a decoupled backend.

If none apply, don't add NestJS speculatively — a well-layered
`src/server/` (domain/application/infrastructure) inside the Next app is
enough. See `project-structure.md` for the canonical tree and the
Server Action vs Route Handler matrix.

If NestJS is added, also read `monorepo-and-nestjs.md` before scaffolding
— skip it entirely for the Next.js-only case.

## Data layer (decide once, record in architecture.md)

Full signal table: `tech-choices.md`. Summary:

| Situation | Default | If native ORM/driver install fails |
|---|---|---|
| Static / CMS-only | No app DB | — |
| Simple relational | **Drizzle** (+ SQLite local or Postgres hosted) | **`node:sqlite`** (Node 22+) or JSON file behind the same port |
| Auth-provider-hosted (Supabase/Firebase) | Their client behind an `infrastructure/` port | — |

Don't add a DB "just in case." Runtime default: **Node** unless a route
truly needs Edge.

## Versions

Pin the **current stable** App Router Next.js and TypeScript at scaffold
time; write exact versions into `knowledge-base/architecture.md`. Prefer
`next.config.ts` (or `.mjs`) over `.js`.
