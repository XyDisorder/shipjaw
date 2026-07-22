# Technical choices from the prompt

> Read at workflow step 3 (with `stack-shape.md`). Turn the **product
> prompt + discovery answers** into concrete stack decisions. Record every
> non-default choice in `knowledge-base/decisions.md` and the full set in
> `architecture.md`. Do not ask the user to pick libraries when a row
> below already decides.

## How to decide (order)

1. **Extract signals** from the prompt (and only ask what's still missing
   per `discovery-questions.md`).
2. **Apply the tables below** — first matching row wins; prefer the
   smaller stack when unsure.
3. **State the stack in one line** to the user before scaffolding.
4. **Write it down** in `architecture.md` + short ADRs for anything
   non-obvious.

## Signal → decision map

| If the prompt/discovery says… | Choose… | Skip / avoid |
|---|---|---|
| Marketing site, brochure, blog, mostly static CMS | Next-only, **no app DB** (CMS or MDX) | Nest, ORM, auth |
| "Save / account / dashboard / CRUD" for one product UI | Next-only + **Server Actions** + DB (see data table) | Nest unless another client exists |
| Mobile app, public API, third-party consumers, webhooks needing a durable API | **Next + Nest** monorepo | Stuffing everything into Route Handlers |
| Queues, workers, cron, heavy async | Nest (or dedicated worker) + document it | Ad-hoc `setTimeout` in Server Actions |
| Login / roles / "my data" | Auth provider (Auth.js/Clerk/Supabase) + ownership model from discovery | Homegrown auth unless explicitly required |
| Single user / personal tool | No multi-tenant; optional no-auth if prompt is local-only | Org/marketplace complexity |
| Org/team or marketplace | Auth + roles; model ownership in domain | Single-user shortcuts |
| Payments / email / analytics named | Integration behind an `infrastructure/` port | SDKs called from React components |
| Multiple locales | `modern-extras.md` i18n (`next-intl` default) | Hardcoded strings after i18n is on |
| SEO-critical / content site | Metadata + cache defaults from `modern-extras.md` | Forcing everything dynamic |
| Vercel | No Dockerfile unless asked | Premature Docker |
| Docker / self-host | Copy scaffold `Dockerfile` + health route | Vercel-only assumptions |
| Explicit "use Nest/Prisma/…" | Honor the named tool; note in decisions | Silently substituting |

## Data layer (persistence)

| Signal | Default | Fallback if native install blocked (e.g. pnpm deny scripts) |
|---|---|---|
| No persistence needed | None | — |
| Simple local/relational app DB | **Drizzle** + SQLite (or Postgres if hosted) | **`node:sqlite`** (Node 22+) behind the same repository port; or JSON file store for tiny smokes |
| Hosted Postgres / Neon / etc. | Drizzle or Prisma (one project-wide) | Same, after scripts allowed |
| Supabase/Firebase as source of truth | Their client in `infrastructure/` | Don't dual-write a second DB |

Always put persistence behind a **port** in `application/` so the fallback
does not leak into domain/UI. Prefer Drizzle when installs work; record
the fallback ADR if you use `node:sqlite`.

## API surface (Next)

| Signal | Choice |
|---|---|
| Mutations from this Next UI | Server Actions |
| Public HTTP, webhooks, non-Next clients later | Route Handlers (`app/api`) |
| Multiple non-web clients / heavy backend | Nest (already decided above) |

## Rendering

| Signal | Choice |
|---|---|
| Page reads a local/file DB or per-request user data | `export const dynamic = "force-dynamic"` (or equivalent) on that route |
| Pure marketing / CMS with revalidation | Static + `revalidate` / tags per `modern-extras.md` |

## Auth & security extras

| Signal | Choice |
|---|---|
| Protected app routes | `middleware.ts` gate **and** application-layer authz |
| Unauthenticated write (public form, no-auth CRUD) | Rate-limit write Server Actions / handlers |
| Uploads / webhooks | Rules in `security.md` "when applicable" |

## Package manager & tooling defaults

- **pnpm** unless the user/repo already standardizes on npm/yarn.
- If a native addon fails to build (pnpm `ignoredBuiltDependencies` /
  `approve-builds`): switch to the data-layer fallback above — do not
  burn gate retries on native compile.

## One-line announcement example

> Stack: Next.js only, Server Actions, Drizzle+SQLite (fallback node:sqlite
> if native builds blocked), Auth.js email, no Nest — because the prompt
> is a single web app with accounts and no external API consumers.
