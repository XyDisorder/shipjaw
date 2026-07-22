# skill-my-website changelog

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
