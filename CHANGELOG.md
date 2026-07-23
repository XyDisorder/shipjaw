# skill-my-website changelog

## 2026-07-23k

- **Proactive `/compact` reminder — not just at clean task end.** A real
  session (`mariage_les_bibous`) burned most of its usage at >150k
  context; the only existing reminder was step 9's "suggest /compact",
  reached only at a clean end that an exploratory debugging session may
  never hit. Added a session-size budget (`skill-principles.md` 7,
  inlined into `shipjaw-ask`'s binding defaults since ask never preloads
  principles): a non-gate runtime bug chased past ~6 file reads, or a
  request needing more than one phase, should each get an early
  `/compact` suggestion — before continuing, not after finishing. No tool
  lets an agent trigger `/compact` itself; saying it early enough is the
  only lever available. `gate-failure-modes.md` also reminds at the point
  it's already opened (2nd gate failure). **Caveat, stated plainly: this
  is prose guidance, not a script — unlike today's other fixes, there's no
  way to dogfood-test that an agent actually follows it under pressure.**

## 2026-07-23j

- **`product/features/<slug>.md` was documented but never actually
  instructed — and the convention itself was wrong.** Asked "is that file
  still always written?" — checked: `doc-structure.md` specified a
  `features/` subfolder, with a template ready
  (`templates/product-feature.md`), but `workflow.md`'s actual steps never
  told the agent to create one. Proof: the golden fixture had zero
  product/features files despite 2 shipped features. Initially kept the
  subfolder convention for consistency with `product/business-rules/` — but
  while implementing, the real `mariage_les_bibous` project's own agent
  independently converged on a **flat** naming
  (`product/feature-<slug>.md`, no subfolder) and committed to it as an
  ongoing practice, unprompted. Live evidence beats the abstract
  consistency argument: switched to flat naming everywhere (it also
  self-groups alphabetically via the shared `feature-` prefix, so the
  subfolder's main benefit was never actually needed). Fixed the real gap:
  `workflow.md`, `shipjaw-build/SKILL.md`, and `shipjaw-ask/SKILL.md` now
  explicitly instruct writing `product/feature-<slug>.md` in the same
  "before the gate" step as the `features-index.md` flip. Dogfooded: golden
  fixture now has `product/feature-create-todo.md` and
  `feature-list-todos.md` (`templates/product-feature.md` shape),
  `smoke-fixture.sh` checks for both, `INDEX.md` template and fixture both
  updated.

## 2026-07-23i

- **Closed the loop: the feature-module doc check now runs inside the
  already-mandatory `run-gate.sh`, not as a skippable "optional" step at
  session end.** Asked directly "does the doc actually update better now"
  — answer was no: the hard-fail check from 2026-07-23g only ran at
  session *start* (catching old drift) and was explicitly optional at
  session *end* (exactly where the original incident happened). Fixed by
  calling `validate-docs-drift.sh` from inside `run-gate.sh` itself, so a
  new feature module undocumented in `features-index.md` now fails the
  gate the same run that would otherwise go green. Found and fixed a
  second issue this surfaced: `shipjaw-build`/`shipjaw-ask` ran the gate
  *before* the KB-update step, which would have made every legitimate
  first-time feature fail its own gate — reordered both workflows so
  `features-index.md` is updated before the gate, not after. Tested: golden
  fixture still passes; a synthetic new module now fails the whole
  `run-gate.sh` run (previously only `validate-docs-drift.sh` alone would
  have failed).

## 2026-07-23h

- **VERSION was never bumped across today's 7 changelog entries (a-g) —
  caught via a real project running `/shipjaw-upgrade` and being told "you
  are already current."** `changelog-since-stamp.sh` compares a project's
  stamp against `shipjaw-build/VERSION`; since VERSION was still
  `2026.07.22w`, every real project would have silently missed all of
  today's changes, including the migration-gate fix motivated by this
  exact real project's incident. Bumped VERSION — twice: the first bump
  to `2026.07.23g` was itself already stale by the time this very entry
  was written, since adding it moved the CHANGELOG header again; landed on
  `2026.07.23h` to match. Added a `smoke-check.sh` assertion that VERSION
  always matches the latest CHANGELOG.md header — tested that it correctly
  fails when they diverge — so this specific mistake can't happen silently
  again.

## 2026-07-23g

- **Feature-module check, hard fail this time — validated against a real
  project first.** Following up on 2026-07-23f (where the path-reference
  check turned out too ambiguous to gate on): a top-level folder name
  under `src/modules/`, `src/features/`, or `features/` is a short,
  distinctive word — far less prone to the abbreviation/route-group issues
  that forced the path check to stay informational. Tested against
  `mariage_les_bibous` (the real project from the incident, now fixed on
  its own): 0 false positives across all 8 real feature modules. Tested
  against a synthetic new module folder: correctly fails. This is the
  check that would have actually caught the original incident (a shipped
  `seating` module absent from `features-index.md`). `validate-docs-drift.sh`
  now mixes severities on purpose: checks #1-3 informational, #4 hard fail.

## 2026-07-23f

- **Correction after real-project verification, not just synthetic tests.**
  Ran `validate-docs-drift.sh` against an actual in-progress project
  (not the golden fixture) before committing anything from this week's
  work. Findings and fixes:
  - The dangling-path check produced real false positives on organically
    written docs: abbreviated paths (dropped `shared/` segment, dropped
    Next.js route-group folders like `(protected)`), extension omission,
    and a path mentioned only as a negative/comparison example. Fixed
    what's fixable (fallback resolution under `src/`, skip ellipsis
    abbreviations, skip extensionless `api/...` route shorthand) but real
    noise remained. **Downgraded the whole check from hard-fail to
    informational-only** — a false-positive gate teaches people to ignore
    gates, which is the exact failure mode this project exists to prevent.
  - `MIGRATION_DIRS` in the pending-migration check previously included
    two directories I invented without basis (`migrations`,
    `src/server/infrastructure/migrations`). Trimmed to verified tool
    defaults only: `drizzle` (confirmed against the real project's
    `drizzle.config.ts`), `prisma/migrations`, `supabase/migrations`.
  - Reverted gap #3 (`glossary.md` / `tech-debt.md` / `risks.md`
    templates, 2026-07-23e below) entirely: zero real usage, purely
    speculative, and this session's own lesson is that unvalidated
    process additions don't survive contact with a real project. Deferred
    back to backlog — revisit only if a real project actually needs one.
  - `run-gate.sh`'s `db:migrate` step and the pending-migration WARN logic
    held up: the real project's `package.json` has `"db:migrate":
    "drizzle-kit migrate"` and its migrations live at `./drizzle` (from
    `drizzle.config.ts`'s `out`), matching what was assumed. Kept as-is.

## 2026-07-23e

- **On-demand KB files (gap #3):** `glossary.md` / `tech-debt.md` /
  `risks.md` templates added — created only when actually needed (same
  tiering logic as `product/business-rules/`), not scaffolded by default.
  Documented in `doc-structure.md`, optional rows noted in the `INDEX.md`
  template. `tech-debt.md` and `risks.md` are also checked by
  `validate-docs-drift.sh` when present; `glossary.md` is excluded (term
  definitions, not path references).

## 2026-07-23d

- **Positioning (gap #2):** README now states what Shipjaw actually is —
  "a methodology encoded as skills," not a framework/OS/platform — and
  compares against the real analogues (Cursor Rules, `AGENTS.md`, Copilot
  custom instructions) instead of unrelated product tools. Shipjaw writes
  `AGENTS.md` + `.cursor/rules/shipjaw.mdc` as output rather than competing
  with them.

## 2026-07-23c

- **Real-dogfood fix (gap #4):** a live project's `/shipjaw-ask` run shipped
  a Drizzle migration + feature code without applying the migration locally
  and without updating `features-index.md` — the gate stayed green because
  `run-gate.sh` had no notion of pending migrations, and the
  code-ahead-of-docs direction of drift was manual-only. Two fixes:
  `run-gate.sh` now runs a `db:migrate` script (if present) before tests, so
  an unapplied migration fails the gate instead of shipping silently.
  `validate-docs-drift.sh` gained a third check — migration files changed
  since `features-index.md`'s last update — warning to verify apply +
  documentation. New `db:migrate` convention documented in
  `tech-choices.md`; new triage row in `gate-failure-modes.md`.

## 2026-07-23b

- **KB drift detection:** `validate-docs-drift.sh` closes the gap between
  "the KB describes reality" (stated in `doc-structure.md`) and actually
  verifying it. Two checks: dangling path references in
  architecture/domain-model/api-reference/features-index/BR-*.md (hard
  fail — doc points at a file that no longer exists) and staleness vs git
  history (soft warn — code changed under src/app/packages since a KB
  file's last commit). Wired into build, adopt, upgrade, and ask's Drift
  protocol; dogfooded against `fixtures/golden-todo` in `smoke-fixture.sh`;
  checked for presence in `smoke-check.sh`.

## 2026-07-23a

- **LLM routing eval:** `eval-skill-routing-llm.sh` calls a real model
  (`claude -p`, haiku by default) with the skill catalog + a paraphrased
  `prompt` per case (added to `evals/routing-cases.yml`) that avoids the
  literal trigger words — tests semantic routing, not substring matching.
  Kept separate from the static eval: slower, costs a real call, run
  pre-release rather than per-commit.

## 2026-07-22w

- README: “Keeping an existing project current” (upgrade delta +
  Challenge `validate-docs` guard).

## 2026-07-22v

- **Diff-aware upgrade:** `changelog-since-stamp.sh` shows skill CHANGELOG
  since the project’s `scaffolded-with` stamp; wired into `/shipjaw-upgrade`
  + ask stamp-lag nudge.
- **`validate-docs` Challenge guard:** `in-progress` phases must have a
  filled Challenge section (todo/draft → WARN only).

## 2026-07-22u

- Challenge is **built-in** for plans/choices in ask/build (prefer a
  second agent) — `/shipjaw-challenge` is the optional full report ritual,
  not the only gate. New `challenge-built-in.md`.

## 2026-07-22t

- Smoke: frontmatter + FR discovery loops cover all **7** skills
  (including `shipjaw-challenge` / `contester`).

## 2026-07-22s

- **`shipjaw-challenge`**: real proposer vs challenger split (prefer a
  separate subagent) on phase/ADR plans before non-trivial implement.
  Challenge report template + phase Challenge section; wired into ask,
  build workflow, entrypoint, principles, eval, and smoke.

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
