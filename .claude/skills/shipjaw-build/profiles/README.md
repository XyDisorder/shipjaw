# Technology profiles

A profile translates Shipjaw's stack-agnostic invariants (see
`../references/skill-principles.md` and the "Core" list in
`../SKILL.md`) into concrete choices for one ecosystem: libraries,
canonical folder tree, typing/lint rules, test runners, CI steps.

## `typescript-next/` — the golden profile

Shipjaw's only profile today. Every real dogfooded project so far is
TypeScript/Next(/Nest), so this is also the **only validated** profile —
its content hasn't been pressure-tested against a second ecosystem yet.

- `stack-shape.md` / `tech-choices.md` — when to add Nest, data layer,
  API surface, rendering, package-manager defaults.
- `project-structure.md` — clean-architecture layers, canonical tree,
  ports/composition root, error→HTTP/UI map, file-size/placement rules.
- `code-standards.md` — typing (`strict`, `noUncheckedIndexedAccess`,
  zod boundaries) and code-quality rules that get compiled into
  tsconfig/eslint.
- `testing-and-ci.md` — Vitest/Playwright/axe strategy, edge-case
  tables, CI pipeline.
- `monorepo-and-nestjs.md` — only read when `stack-shape.md` concluded
  a separate Nest API is needed.
- `modern-extras.md` — i18n/observability/deploy, loaded only when
  discovery activates a section.

`shipjaw-build`'s `SKILL.md` and `references/workflow.md` are the
entrypoints that decide when to open each of these — this folder holds
content, not routing.

## Adding a second profile

Don't invent one speculatively. Per the roadmap this profile split
came from (dogfooded 2026-09-07), the honest test of "is Core actually
agnostic" is building and dogfooding a second profile (e.g.
Python/FastAPI) on a real project and seeing how much of `SKILL.md` /
`workflow.md` / `skill-principles.md` needed to change. If it's a lot,
Core still has TypeScript/Next assumptions baked in that this first
split didn't catch — fix Core, don't just duplicate the leak into the
new profile.
