# skill-my-website changelog

## 2026-07-22r

- Complete high-ROI skill loop: **gate-failure-modes** (open on 2nd gate
  fail), **drift protocol** in shipjaw-ask, **design-constraints** (anti
  AI-slop), and new **`shipjaw-upgrade`** skill for stamp/docs/contract
  refresh without product rewrite. Wired into entrypoint, principles,
  migration, eval routing, and smoke.

## 2026-07-22q

- Product-quality loop for the skills themselves: **golden fixture**
  (`fixtures/golden-todo` + `smoke-fixture.sh`), mandatory
  `documentation/handoff.md` (template + wired into prompt/build/adopt/ask),
  and static **skill routing eval** (`evals/routing-cases.yml` +
  `eval-skill-routing.sh`).

## 2026-07-22p

- `shipjaw-adopt` now runs a **read-only architecture practice audit**,
  records gaps in `architecture.md`, and **proposes** a converge-clean-arch
  phase (`technical-plan-converge-arch.md`) — execution stays opt-in via
  `shipjaw-ask`. Survey script emits arch practice signals.

## 2026-07-22o

- Architecture deepening: **ports** (one file each), **composition root**
  (`server/composition.ts`), **thin Server Actions/Route Handlers**, and
  an **error → HTTP/UI** mapping table — plus anti-barrel. Wired into
  project-structure, code-standards, build/ask, migration, Cursor rule.

## 2026-07-22n

- Explicit **types / constants / helpers placement** in clean arch
  (`project-structure.md` + `code-standards.md`): domain-owned types &
  `*.constants.ts`, zod in application/contracts, feature `lib/` for
  UI-only helpers, ban grab-bag `lib/utils.ts`. Wired into build/ask +
  migration.

## 2026-07-22m

- `shipjaw-adopt` now **surveys** existing docs/plans/phases before
  writing anything (`survey-adopt-state.sh`): NO_DOCS / PARTIAL_DOCS /
  FULL_SHIPJAW_KB routing, absorb foreign roadmaps into Shipjaw homes,
  required **where we are** status snapshot at handoff.

## 2026-07-22l

- Raise agent robustness + auto-discovery: richer bilingual descriptions
  (500–1024 chars, Use when + FR cues); scripts `init-docs-skeleton`,
  `validate-docs`, `run-gate` with feedback-loop wiring in build/adopt/ask
  checklists; smoke enforces description floor and executable scripts.

## 2026-07-22k

- Skill hygiene: `disable-model-invocation` on `/shipjaw` + `/shipjaw-build`;
  copiable checklists; richer third-person descriptions; `shipjaw-ask`
  inlines binding defaults (no principles preload); utility scripts
  `copy-continuation-contract.sh` + `stamp-provenance.sh`.

## 2026-07-22j

- New **`shipjaw-adopt`**: bring an existing TS/Next app under the
  Shipjaw contract (docs + AGENTS/Cursor rule + idempotent tooling gaps,
  no rewrite). Wired into entrypoint, principles, migration, build/ask
  anti-triggers, README, and install symlinks.

## 2026-07-22i

- Less slash friction on scaffolded apps: always copy `AGENTS.md` +
  `.cursor/rules/shipjaw.mdc` (continuation contract without requiring
  `/shipjaw-ask`); INDEX template banner; wider `shipjaw-ask` description;
  README “When to slash” table.

## 2026-07-22h

- Explicit **TU vs e2e edge-case matrices** in `testing-and-ci.md`
  (validation/authz/boundaries in unit; empty/form error/unauthorized
  golden-path companions in e2e; no duplicate coverage). Wired into phase
  + feature templates and `shipjaw-ask`.

## 2026-07-22g

- Principle **18 — Ship the core journey first**: *User can…* DoD on
  phases, journey-first feature template, ruthless single core action in
  `prompt-craft` / source-prompt; golden-path e2e before polish; stop on
  ambiguous product behavior after one question.

## 2026-07-22f

- Entrypoint **`/shipjaw`**: create a named project folder, switch into
  it, explain `shipjaw-prompt` → `shipjaw-build` → `shipjaw-ask`.
  Principle 1 updated; README install lists four skills.

## 2026-07-22e

- Three-skill pipeline: **`shipjaw-prompt`** (expression →
  `product/source-prompt.md`) → **`shipjaw-build`** (scaffold) →
  **`shipjaw-ask`** (continue). Principle 1 updated; README/install
  refreshed.

## 2026-07-22d

- Principle **17** (tiered regression / business-rule safety): always
  pre-change bullets, domain-owned invariants, bug⇒regression test, never
  weaken tests to green, characterization on fuzzy legacy; critical paths
  get slim `BR-XXX` docs.
- New `references/regression-and-business-rules.md` +
  `templates/business-rule.md`; wired into testing, technical-plan,
  doc-structure, INDEX, shipjaw-build / shipjaw-ask.
- Rebrand to **Shipjaw** (`shipjaw-build` / `shipjaw-ask`), new wordmark, README
  marketing copy updated.

## 2026-07-22b

- Dogfood fixes: docs vs `create-next-app` (temp-dir merge); data-layer
  native-install fallback (`node:sqlite`); Playwright e2e port **3005**;
  `force-dynamic` for local-DB routes; `turbopack.root` /
  `outputFileTracingRoot` in scaffold `next.config.ts`; CI build-before-e2e.
- `references/tech-choices.md` — prompt/discovery signal → stack/library
  decision tables (how the skill chooses tech from the product prompt).

## 2026-07-22

- Meta principles 9–16: dogfood/`smoke-check.sh`, migration.md,
  anti-triggers in descriptions, no framework-doc dumps, idempotent
  scaffold copy, narration budget, `VERSION` + `scaffolded-with` stamp,
  project owns conventions after bootstrap.
- Encoded operating principles 1–8 as binding skill behavior
  (`references/skill-principles.md`).
- Docs committed by default; Cursor + Claude dual install; host fallbacks.
- Token hygiene: rotations, slim SKILL bodies, Open-when, Grep/offset.
- Canonical Next-only tree + API surface matrix; scaffold kit; App Router
  security; modern-extras on demand; gate stop after 2 failures; INDEX
  repair; conditional contracts; Nest checklist.
