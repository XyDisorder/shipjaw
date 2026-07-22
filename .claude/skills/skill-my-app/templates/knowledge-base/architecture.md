# Architecture (current state)

> Describes the system **as it actually is today**. Update the same
> session anything here changes — edit the relevant section only.
> Paths/signatures only — never paste code blocks.

## Skill provenance
- scaffolded-with: skill-my-app@<YYYY.MM.DD>
  (copy from `.claude/skills/skill-my-app/VERSION` or the installed skill's VERSION file)

## Stack
- Frontend: Next.js <exact version>, TypeScript <exact version>, App Router
- API: <NestJS <version> | none — Server Actions + Route Handlers>
- Package manager / monorepo: <pnpm + turborepo | none, single app>
- Validation: zod
- Data layer: <none | Drizzle/Prisma + DB | CMS>
- Runtime: Node (default) <note any Edge routes>
- Testing: Vitest + Playwright <Jest only if Nest TestingModule exception>
- Auth: <provider | custom>
- i18n / observability / deploy: <none | next-intl | Sentry | Vercel/Docker>

## Folder layout
```
<source tree paths only — fill after scaffold using the canonical tree
from project-structure.md>
```

## Layering
<Confirm boundaries; note deliberate deviations.>

## Security
<Headers via next.config.ts, CSP notes, middleware protected prefixes,
rate-limited surfaces, Dependabot/audit.>

## Notable deviations / convention owner
<Project owns conventions after bootstrap. Record any bent skill default
or external design-system ADR here with the reason.>
