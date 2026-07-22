---
name: shipjaw-build
description: Scaffolds a brand-new TypeScript/Next.js site/app (NestJS only when needed) from a build-ready product prompt — docs-first, tests, security, clean architecture, committed documentation/. Use for initial bootstrap, create-next-app greenfield, or when the user pastes a dense prompt / has documentation/product/source-prompt.md. Do not use to polish a vague idea (shipjaw-prompt), adopt an existing app (shipjaw-adopt), tweak CSS, or when documentation/knowledge-base/ already exists (shipjaw-ask).
disable-model-invocation: true
---

# shipjaw-build

Bootstrap-only. Turns a **build-ready product prompt** into a scaffolded
TypeScript site and a committed `documentation/` map. Later sessions use
`shipjaw-ask`. Prefer `shipjaw-prompt` first when the idea is still vague.

Slash-preferred (`disable-model-invocation`) — avoid ambient auto-scaffold.

**Operating principles:** `references/skill-principles.md` (1–18) — open
only if a principle conflict arises; hard rules below are enough for most
runs.

## Anti-triggers (stop — don't run bootstrap)

- `documentation/knowledge-base/` already exists → `shipjaw-ask`
- Existing app code **without** Shipjaw KB → `shipjaw-adopt` (do not
  re-scaffold in place)
- Idea is still vague / user wants help wording the product →
  `shipjaw-prompt` first
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
   `INDEX.md` + phase-01. Stamp via `scripts/stamp-provenance.sh`.
7. **Verify** — one gate/phase; **stop after 2 failed attempts**.
8. **KB current** — update before done; state not only in chat.

## Checklist

```
- [ ] Intake prompt (message or product/source-prompt.md)
- [ ] Clarify gaps only (≤2 rounds / ~8 Q) or skip if dense
- [ ] Stack via stack-shape + tech-choices (read on demand)
- [ ] Write documentation/ (INDEX + phase-01) before feature code
- [ ] Scaffold Next (temp-dir merge if docs already present)
- [ ] Copy scaffold kit idempotently (see templates/scaffold/README)
- [ ] Run scripts/copy-continuation-contract.sh <project-root>
- [ ] Run scripts/stamp-provenance.sh <project-root>
- [ ] Implement core *User can…* + tests; gate; ≤2 fix attempts
- [ ] Update KB surgically; hand off to shipjaw-ask
```

## Workflow (summary — `references/workflow.md`)

1. Intake → 2. Clarify → 3. Stack → 4. Docs → 5. Scaffold + kit +
   continuation scripts → 6. Implement + gate → 7. KB + compact.

If the repo looks like an older Shipjaw / skill-my-app project, read
`references/migration.md` instead of re-bootstrapping.

## Scripts (execute, don't reinvent)

From this skill directory:

```bash
./scripts/copy-continuation-contract.sh <project-root>
./scripts/stamp-provenance.sh <project-root>
```

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
  `VERSION` · `scripts/`
