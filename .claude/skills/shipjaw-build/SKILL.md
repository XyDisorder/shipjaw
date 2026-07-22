---
name: shipjaw-build
description: Scaffolds a brand-new TypeScript/Next.js application (NestJS API only when the product truly needs one) from a build-ready product prompt — writes committed documentation/, enforces strict TypeScript, Vitest, Playwright, security headers, clean architecture, then ships v1 behind a verification gate. Use when bootstrapping greenfield, running create-next-app from a dense brief, pasting a product prompt, documentation/product/source-prompt.md is ready, après shipjaw-prompt, prompt prêt, initial build, or first scaffold of a new Shipjaw app. Do not use to polish a vague idea first (shipjaw-prompt), adopt an existing foreign codebase (shipjaw-adopt), tweak CSS/copy only, non-TS repos, or when documentation/knowledge-base/ already exists (shipjaw-ask).
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
3. **Architecture** — canonical tree in `project-structure.md` (including
   types / constants / helpers placement). Contracts consumer updates
   **only if `packages/contracts/` exists**. No grab-bag `lib/utils.ts`.
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
- [ ] ./scripts/copy-continuation-contract.sh <project-root>
- [ ] ./scripts/stamp-provenance.sh <project-root>
- [ ] ./scripts/validate-docs.sh <project-root>
- [ ] Implement core *User can…* + tests (types/consts/helpers placed per
      project-structure — no utils grab-bag)
- [ ] ./scripts/run-gate.sh <project-root> --with-e2e
- [ ] Fix ≤2 attempts; update KB surgically; hand off to shipjaw-ask
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
./scripts/init-docs-skeleton.sh <project-root>   # adopt / repair
./scripts/validate-docs.sh <project-root>        # feedback loop
./scripts/run-gate.sh <project-root> [--with-e2e]
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
