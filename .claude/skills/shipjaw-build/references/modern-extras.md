# Modern extras (load only when discovery says yes)

> Skip this file entirely when none of i18n / observability / deploy /
> SEO-heavy caching apply. One section at a time.

## i18n (locales > 1)

- Prefer `next-intl` (or the project's existing choice) with App Router
  locale segment: `src/app/[locale]/...`.
- Default locale + list recorded in `product/design-brief.md` and
  `architecture.md`. Messages as JSON/TS under `messages/<locale>/`.
- Never hardcode user-visible strings in components once i18n is on —
  except purely decorative brand marks.

## Observability

- Replace ad-hoc `console.*` with `templates/scaffold/src/lib/logger.ts`
  (or equivalent) from day one.
- If the product will be deployed: add error reporting (e.g. Sentry) behind
  an `infrastructure/` port; DSN only via env. Record the choice in
  `architecture.md`. Skip full APM until there's traffic worth measuring.

## Caching & SEO (content / marketing sites)

- Default: dynamic where user-specific; `fetch`/`revalidate` or
  `revalidateTag` for public content. Document cache policy per route
  family in `architecture.md` when non-obvious.
- Every public page sets `metadata` (title, description). Use
  `next/image` for LCP images.

## Deploy

| Target | Scaffold |
|---|---|
| Vercel | No Dockerfile required; ensure `build`/`start` scripts; env in Vercel dashboard mirrored in `.env.example` |
| Docker | Copy `templates/scaffold/Dockerfile`; expose a `/api/health` (or Nest health) endpoint |
| Undecided | Scripts only; defer Dockerfile to a later phase and note it in the roadmap |

## Deferred by default

Feature flags, cron/jobs, email templates, analytics privacy — add as
later `technical-plan/` phases when needed; don't invent them at bootstrap.
