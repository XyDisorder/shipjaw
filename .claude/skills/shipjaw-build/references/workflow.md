# Full workflow (initial build)

This is the bootstrap workflow. Once a project has
`documentation/knowledge-base/`, all later work goes through
`shipjaw-ask`, not this one. Vague ideas should go through
`shipjaw-prompt` first.

## 1. Intake

Resolve the product prompt in this order:

1. Prompt text in the user message (paste wins if present).
2. Else `documentation/product/source-prompt.md` (from `shipjaw-prompt`).
3. Else stop and ask for a prompt **or** suggest `/shipjaw-prompt`.

Read the prompt. Briefly note what's specified vs missing (one or two
sentences). List the **technical signals** you already see (auth? DB?
multi-client API? i18n? deploy?) — these feed step 3 via
`tech-choices.md`. If the prompt already has the craft sections
(one-liner, core action, v1 scope, auth/data, constraints, design,
success criteria), treat discovery as nearly done.
## 2. Clarify (only what's missing)

Use `references/discovery-questions.md`. Max 4 questions/round via host
tool or numbered chat. **Hard budget: max 2 rounds, ~8 questions total**
— then default and record in `product/design-brief.md` / `overview.md`.
Reply in the user's language.

## 3. Decide the stack shape

Read `references/stack-shape.md` + `references/tech-choices.md`. Map
prompt/discovery signals → Nest or not, data layer, API surface, auth,
i18n/deploy extras. **Announce the stack in one line** (with the "because")
before scaffolding. Nest → also plan to read `monorepo-and-nestjs.md` at
step 5; otherwise never open it.

## 4. Documentation first

**Hard rule: no application feature code before `INDEX.md` + `phase-01`
exist.** Config/scaffold may follow immediately after docs are written.

1. Create committed `documentation/` (do **not** gitignore). Seed from
   `templates/`.
2. Fill `product/overview.md` (incl. Non-goals / Out of v1) and
   `design-brief.md`. If `product/source-prompt.md` exists, keep it and
   derive overview/design-brief from it (don't delete the source prompt).
3. Break into phases (`templates/technical-plan-phase.md`). Split when
   >~500 lines net-new across many files **or** when a critical e2e flow
   is bundled with unrelated polish.
4. Seed `knowledge-base/` from templates (include intended stack from
   step 3).
5. Write `INDEX.md` last so it maps everything accurately.

## 5. Scaffold

### 5a. Next app vs non-empty `documentation/`

`create-next-app` **refuses a non-empty directory**. Use one of:

1. **Preferred:** scaffold Next into a **temp dir**, then merge into the
   project root that already has `documentation/` (rsync/cp excluding
   `.git`), **or**
2. Scaffold Next in the empty root **first**, then add `documentation/`
   in the same turn before feature code (docs still land before product
   features — the hard rule is about feature code, not the order of
   `create-next-app` vs mkdir docs).

Never delete `documentation/` to please the scaffolder.

### 5b. References to load

1. `project-structure.md` — always (canonical tree + API matrix).
2. `code-standards.md` — always; encode into real tsconfig/eslint.
3. `testing-and-ci.md` — always; Vitest + Playwright + axe.
4. `security.md` — always; headers/CSP/actions/middleware patterns.
5. `monorepo-and-nestjs.md` — **only if** NestJS.
6. `modern-extras.md` — **only** sections discovery/tech-choices activated.
7. `migration.md` — only when upgrading a pre-existing shipjaw-build app.

Do **not** paste official Next/Nest docs into the repo (principle 12).

### 5c. Copy kit + completeness

Copy `templates/scaffold/` per its README (**idempotent**). Wire scripts:
`typecheck`, `lint`, `test`, `test:watch`, `e2e`, `build`. Copy CI +
Dependabot. Run (do not reinvent):

```bash
./scripts/copy-continuation-contract.sh <project-root>
./scripts/stamp-provenance.sh <project-root>
./scripts/validate-docs.sh <project-root>
./scripts/run-gate.sh <project-root> [--with-e2e]
```

(paths relative to the `shipjaw-build` skill dir). Stamp exact framework
versions in `architecture.md`.

If a native DB driver fails to install (pnpm build-script deny), apply the
`tech-choices.md` data-layer **fallback** and log an ADR — don't loop the
gate on native compiles.

**Scaffold completeness check:** strict tsconfig, no-explicit-any eslint,
security headers, `turbopack.root` / `outputFileTracingRoot` pointing at
this app, test/e2e scripts, CI, `AGENTS.md` + `.cursor/rules/shipjaw.mdc`.
Still "docs only" → not done.


**Narration:** don't paste reference contents; keep status short.

## 6. Implement phase by phase

Implement + tests + security together. Cap 500 lines/file.
On behavior changes: short pre-change bullets in the phase file; follow
`regression-and-business-rules.md` (tiered). Bug fixes need a regression
test; do not weaken existing tests to green.

**Principle 18 — core journey first:** each phase needs a *User can…*
line. Phase-01 / critical flows: golden-path e2e before polish or
Out-of-v1 extras. Refuse scope creep "while we're here."

Routes that **read a local/file DB or per-request user data** must opt
into dynamic rendering (`export const dynamic = "force-dynamic"` or
equivalent) — otherwise Next may statically shell an empty page.

**Verification gate (once per phase):** typecheck → lint → test → e2e
(e2e mandatory when the phase's *User can…* is a critical journey).
If e2e fails because the port is busy: free it or use the Playwright
config's dedicated e2e port (see scaffold `playwright.config.ts`) — that
counts as environment fix, not a "logic" retry. **After 2 failed gate
attempts on real product errors, stop** and ask the user.
Only then mark the phase done; archive when status flips to `done`.

## 7. Update the knowledge base — every time

Before ending a turn that shipped a feature, changed an API/data
contract, or made an architectural call:

- Update touched KB files surgically (paths/signatures only). Split if
  >~200 lines.
- Append changelog line; rotate past ~50.
- Flip `features-index.md` row.
- Short-form `decisions.md` if needed; archive superseded / rotate past
  ~20–25 active.
- Phase `done` → `phase-archive/` + roadmap pointer + drop from INDEX.
- Update `INDEX.md` only when the TOC itself changed.

Then suggest compacting context: `/compact` (Claude) or fresh chat /
short handoff (Cursor).
