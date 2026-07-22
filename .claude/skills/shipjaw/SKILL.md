---
name: shipjaw
description: Scaffold a brand-new TypeScript/Next.js site/app (NestJS only when needed) from a product prompt — docs-first, tests, security, clean architecture. Trigger for initial build only. Do not use for small CSS tweaks, non-TS repos, or when documentation/knowledge-base/ already exists (use shipjaw-ask instead).
---

# shipjaw

Bootstrap-only. Turns a product prompt into a scaffolded TypeScript
site and a committed `documentation/` map. Later sessions use
`shipjaw-ask` — never re-run this skill on an existing KB.

**Operating principles:** `references/skill-principles.md` (1–17).
Highlights: two skills; state in repo; progressive disclosure; compile
into tooling; templates > prose (idempotent copy); host fallbacks; stop
budgets; docs committed; anti-triggers; no framework-doc dumps; narration
budget; stamp `scaffolded-with`; project owns conventions after bootstrap;
tiered regression / business-rule safety.

## Anti-triggers (stop — don't run bootstrap)

- `documentation/knowledge-base/` already exists → `shipjaw-ask`
- Single-file cosmetic / copy tweak with no product build
- Non-TypeScript codebase
- User only wants framework tutorial text (point at official docs)

## Hard rules (never negotiable)

1. **Typing** — `strict: true`. No `any`. `unknown` only at untyped
   entry points, narrowed via zod/type guard. → `code-standards.md`
2. **File size** — hard cap **500 lines**; plan split ~300.
3. **Architecture** — canonical tree in `project-structure.md`.
   Contracts consumer updates **only if `packages/contracts/` exists**.
4. **Tests** — Vitest for domain/application; Playwright + axe +
   keyboard/focus smoke for critical flows. Bug fix ⇒ regression test;
   never weaken tests to green. → `testing-and-ci.md` ·
   `regression-and-business-rules.md`
5. **Security** — secrets out of git; authz in `application/`; actions
   re-check session; middleware; CSP via scaffold `next.config.ts`.
6. **Documentation** — committed `documentation/`. No app code before
   `INDEX.md` + phase-01. Stamp `scaffolded-with: shipjaw@VERSION`.
7. **Verify** — one gate/phase; **stop after 2 failed attempts**.
8. **KB current** — update before done; state not only in chat.

## Workflow (summary — `references/workflow.md`)

1. Intake (note technical signals) → 2. Clarify (≤2 rounds / ~8 Q) →
3. Stack via `stack-shape.md` + `tech-choices.md` (announce one line) →
4. Docs before feature code → 5. Scaffold (temp-dir merge if docs exist;
   idempotent kit) → 6. Implement + gate → 7. KB update + suggest compact.

If the repo looks like an older shipjaw project, read
`references/migration.md` instead of re-bootstrapping.

## Cost / narration

- Load only the reference the current step needs.
- Act; don't paste reference contents into chat (principle 14).
- Prefer merge-over-overwrite for existing config (principle 13).

## References (on demand)

- `skill-principles.md` · `migration.md` ·
  `regression-and-business-rules.md`
- `discovery-questions.md` · `stack-shape.md` · `tech-choices.md`
- `project-structure.md` · `code-standards.md` · `testing-and-ci.md` ·
  `security.md`
- `monorepo-and-nestjs.md` — Nest only
- `modern-extras.md` — only if discovery activated
- `doc-structure.md` · `workflow.md`
- `templates/` · `templates/scaffold/` · `templates/business-rule.md` ·
  `VERSION`
