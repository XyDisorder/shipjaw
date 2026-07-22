# Architecture (current state)

## Skill provenance
- scaffolded-with: shipjaw-build@2026.07.22q
- note: golden fixture — structural reference for Shipjaw maintainers

## Stack
- Frontend: Next.js (fixture), TypeScript strict, App Router
- API: none — Server Actions
- Data layer: in-memory repository (fixture)
- Testing: Vitest + Playwright (scripts present; not fully wired here)

## Folder layout
```
src/server/domain/
src/server/application/ports/
src/server/application/
src/server/infrastructure/
src/server/composition.ts
features/todos/actions.ts
features/todos/lib/
```

## Layering
domain → application (ports) → infrastructure; presentation thin via composition.

## Shipjaw practice gaps
| Gap | Evidence | Priority | Status |
|---|---|---|---|
| (none — fixture baseline) | — | — | done |
