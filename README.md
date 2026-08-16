# Shipjaw

<p align="center">
  <a href="https://github.com/XyDisorder/shipjaw/actions/workflows/smoke.yml"><img src="https://github.com/XyDisorder/shipjaw/actions/workflows/smoke.yml/badge.svg" alt="smoke" /></a>
  <a href="https://github.com/XyDisorder/shipjaw/releases/latest"><img src="https://img.shields.io/github/v/release/XyDisorder/shipjaw" alt="latest release" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/XyDisorder/shipjaw" alt="license" /></a>
</p>

<p align="center">
  <img src="assets/logo-dark-wordmark.png" alt="Shipjaw — Ship the product. Not the prompt engineering." width="720" />
</p>

<p align="center">
  <strong>Ship the product — solid tech, docs that scale, tokens kept low.</strong>
</p>

<p align="center">
  Claude Code &amp; Cursor skills to express, scaffold, and grow production-grade apps<br/>
  <strong>TypeScript · Next.js · NestJS (only when you actually need it)</strong>
</p>

<p align="center">
  <a href="#installation">Install</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#what-you-get">What you get</a> ·
  <a href="#positioning">Positioning</a> ·
  <a href="#why-its-different">Why it’s different</a>
</p>

---

## The problem

You ask an agent to “build my site.” You get:

- a half-baked prompt → a half-baked app  
- code that *sometimes* compiles  
- no stable architecture  
- missing or invented docs  
- features that regress because nothing owns the business rules  
- the next session **re-deriving everything** and burning your token budget  

**Shipjaw** flips that: express the product clearly, bootstrap once with real foundations, then evolve cheaply without regressions.

## The promise

| Express (`shipjaw-prompt`) | Build (`shipjaw-build`) | Adopt (`shipjaw-adopt`) | Continue (`shipjaw-ask`) |
|---|---|---|---|
| Rough idea → dense product prompt | Prompt → docs + scaffold + v1 | Existing app → docs + contract | `INDEX.md` + 1–2 files |
| Clarifies only what’s missing | Tech choices from the **prompt** | No rewrite | No rediscovery |
| Writes `product/source-prompt.md` | Committed `documentation/` | AGENTS + Cursor rule | State in the repo, not chat |
| No code, no KB yet | Strict TS, tests, security gate | Idempotent tooling gaps | Same contract, minimal tokens |
| | Invariants in domain/application | Stamp `adopted-with` | Bug fix ⇒ regression test |

Start with `/shipjaw` to create the project folder and see this map.

One line: **prompt-first, docs-first, tooling-enforced, core journey first, continuation cheap, regressions blocked.**

## What you get

- A **Next.js** app (App Router) with `domain` → `application` → `infrastructure` → presentation layers  
- **NestJS in a monorepo** only when the product justifies it  
- **Rules compiled** into tsconfig, eslint, CSP, Vitest, Playwright + a11y (axe)  
- A **living knowledge base** rotated so it stays short  
- **Tiered business-rule safety** (slim `BR-XXX` when critical)  
- **Automatic tech decisions** via `tech-choices.md`  
- Works with **Claude Code** and **Cursor**

## How it works

```text
  /shipjaw  →  create folder + explain pipeline
         │
         ▼
  Rough idea / notes          Existing TS/Next app (no Shipjaw KB)
         │                              │
         ▼                              ▼
 ┌───────────────────┐         ┌───────────────────┐
 │  shipjaw-prompt   │         │  shipjaw-adopt    │
 │  → source-prompt  │         │  docs + contract   │
 └─────────┬─────────┘         └─────────┬─────────┘
           │                             │
           ▼                             │
 ┌───────────────────┐                   │
 │  shipjaw-build    │                   │
 │  docs → scaffold  │                   │
 │  → v1 + gate      │                   │
 └─────────┬─────────┘                   │
           │  documentation/INDEX.md     │
           └──────────────┬──────────────┘
                          ▼
                ┌───────────────────┐
                │   shipjaw-ask     │
                │  INDEX + 1–2 files│
                └───────────────────┘
```

## Usage

**0. Start** — new empty project folder + roadmap of commands:

```text
/shipjaw
```

```text
/shipjaw my-grocery-app
```

Creates (or reuses) the folder, switches into it, then explains
`/shipjaw-prompt` → `/shipjaw-build` → `/shipjaw-ask` (and `/shipjaw-adopt`
for existing apps).

**1. Express** — optional if you already have a sharp prompt:

```text
/shipjaw-prompt Une app de listes de courses partagée en famille, simple, mobile-first
```

**2. Build** — uses the message prompt **or** `documentation/product/source-prompt.md`:

```text
/shipjaw-build
```

```text
/shipjaw-build A personal todo tool, no accounts, minimal UI, local persistence
```

**2b. Adopt** — existing TS/Next app started without Shipjaw:

```text
/shipjaw-adopt
```

**2c. Upgrade** — Shipjaw app, skill/docs stamps lag (no feature work):

```text
/shipjaw-upgrade
```

**3. Continue** — same repo, later:

```text
/shipjaw-ask Add a done/active filter and the matching e2e
```

Compact between tasks (`/compact` on Claude, or a fresh chat on Cursor): resume from `documentation/INDEX.md` then `documentation/handoff.md`.

### When to slash

| Situation | Prefer |
|---|---|
| New empty folder / named project home | `/shipjaw` |
| Rough idea → dense prompt only | `/shipjaw-prompt` |
| Build-ready prompt → docs + app + v1 | `/shipjaw-build` |
| Existing app, no Shipjaw KB | `/shipjaw-adopt` |
| Refresh stamps / AGENTS / see what changed since your stamp | `/shipjaw-upgrade` |
| Challenge plans/choices (built-in in ask/build; optional full report) | `/shipjaw-ask` / `/shipjaw-build` · optional `/shipjaw-challenge` |
| Feature / fix / continue in a Shipjaw app | `/shipjaw-ask` |

Scaffolded apps also get `AGENTS.md` + `.cursor/rules/shipjaw.mdc` so the
continuation contract applies even if you forget the slash — still prefer
`/shipjaw-ask` so the skill loads on purpose.

### Keeping an existing project current

1. Update the Shipjaw skill install (git pull + keep the seven symlinks).
2. In the app repo run **`/shipjaw-upgrade`** — it prints the skill
   **changelog since your `scaffolded-with` stamp**, then refreshes
   AGENTS / Cursor rule / stamps / migration gaps (no product rewrite).
3. Continue with **`/shipjaw-ask`**.

`validate-docs` also enforces Challenge on **`in-progress`** phases
(unfilled Challenge → fail; `todo`/draft → warn only). Fill Challenge
via the built-in ask/build pass (or `/shipjaw-challenge` for a durable
report) before coding.

## Installation

### In this repo

- Claude Code: `.claude/skills/*`  
- Cursor: `.cursor/skills/*` (symlinks → single source of truth)

### Global (any project)

```sh
git clone https://github.com/XyDisorder/shipjaw.git
cd shipjaw

mkdir -p ~/.claude/skills ~/.cursor/skills

ln -s "$(pwd)/.claude/skills/shipjaw"         ~/.claude/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-prompt"  ~/.claude/skills/shipjaw-prompt
ln -s "$(pwd)/.claude/skills/shipjaw-build"   ~/.claude/skills/shipjaw-build
ln -s "$(pwd)/.claude/skills/shipjaw-adopt"   ~/.claude/skills/shipjaw-adopt
ln -s "$(pwd)/.claude/skills/shipjaw-upgrade" ~/.claude/skills/shipjaw-upgrade
ln -s "$(pwd)/.claude/skills/shipjaw-challenge" ~/.claude/skills/shipjaw-challenge
ln -s "$(pwd)/.claude/skills/shipjaw-ask"     ~/.claude/skills/shipjaw-ask

ln -s "$(pwd)/.claude/skills/shipjaw"         ~/.cursor/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-prompt"  ~/.cursor/skills/shipjaw-prompt
ln -s "$(pwd)/.claude/skills/shipjaw-build"   ~/.cursor/skills/shipjaw-build
ln -s "$(pwd)/.claude/skills/shipjaw-adopt"   ~/.cursor/skills/shipjaw-adopt
ln -s "$(pwd)/.claude/skills/shipjaw-upgrade" ~/.cursor/skills/shipjaw-upgrade
ln -s "$(pwd)/.claude/skills/shipjaw-challenge" ~/.cursor/skills/shipjaw-challenge
ln -s "$(pwd)/.claude/skills/shipjaw-ask"     ~/.cursor/skills/shipjaw-ask
```

Keep the skills as **siblings** so relative `../shipjaw-build/references/` paths resolve.

> Migrating from older installs: link **all seven** skills above. Legacy stamps still work. Agents **challenge plans/choices by default** in ask/build; `/shipjaw-challenge` is the optional full report ritual.

## Positioning

Shipjaw is **a methodology encoded as skills** — not a framework you import,
not an operating system you run on, not a platform with its own
infrastructure. The contract lives in your repo's own files
(`documentation/`, tsconfig, eslint, CI), not in a runtime you depend on.
Closer to "`AGENTS.md` + Cursor Rules, but covering the whole project
lifecycle instead of one static instructions file" than to a code
generator.

### Compared to the closest analogues

Cursor Rules, `AGENTS.md`, and GitHub Copilot custom instructions solve the
same narrow problem shipjaw does — give an agent durable, low-token repo
context — so they're the real comparison set (a UI generator like v0/Bolt
or an ORM like Prisma is a different layer, not a competing approach).

| | Cursor Rules / `AGENTS.md` / Copilot instructions | Shipjaw |
|---|---|---|
| Scope | One (or a few) static instruction files | Full lifecycle: discovery → build → continue → upgrade |
| State | Whatever fits in the rule file | Versioned `documentation/` (product, plan, knowledge base) |
| Gates | None — prose only | Scripted: `run-gate.sh` (typecheck/lint/**db:migrate**/test/e2e/**feature-module-doc check**), `validate-docs.sh` |
| Drift detection | None | `validate-docs-drift.sh` — informational (path refs, staleness, pending migrations); a prompt to look, not a gate |
| Portability | Tool-specific format | Shipjaw **writes** `AGENTS.md` + `.cursor/rules/shipjaw.mdc` as output — layers on top, doesn't replace them |

Shipjaw does not try to replace `AGENTS.md`; it generates one. If `AGENTS.md`
keeps consolidating as a cross-tool standard, shipjaw should track that
spec rather than diverge from it.

## Why it’s different

| Typical agent approach | Shipjaw |
|---|---|
| Jump straight into code from vibes | Optional **prompt craft** before scaffold |
| Everything in the transcript | Versioned state + **handoff.md** |
| One mega catch-all prompt | Express ≠ build ≠ adopt ≠ upgrade ≠ continue (+ optional full **challenge** ritual) |
| Plans rubber-stamped | **Built-in** challenger pass; `in-progress` phases must document Challenge |
| Skill upgrades are opaque | `/shipjaw-upgrade` shows **changelog since your stamp** |
| “No `any`” as forgettable prose | Encoded in tsconfig / eslint / CI |
| Gitignored docs → amnesiac clones | **Committed** docs |
| Fixes that quietly regress | Bug ⇒ failing-then-passing test |
| "v1 scope" that's really a roadmap | Mandatory **scope trim gate** — Core action, v1 scope, Success criteria all checked for smuggled-in scope before the prompt is persisted |

## Anti-triggers (don’t use the wrong skill)

- Bare start / need a project folder → **`/shipjaw`**  
- Vague idea, no prompt yet → **`shipjaw-prompt`**, not build  
- Existing app without Shipjaw docs → **`shipjaw-adopt`**, not build  
- Only bump skill docs/stamps → **`shipjaw-upgrade`**, not ask  
  (shows delta since stamp; ask nudges you if stamps lag)  
- Challenge a plan (full durable report) → **`shipjaw-challenge`** (ask/build already challenge inline)  
- One-off CSS / copy tweak → normal edit  
- Non-TypeScript repo → refuse  
- KB already exists + product work → **`shipjaw-ask`**, not build  

## Maintainers

```sh
./scripts/smoke-check.sh
./scripts/smoke-fixture.sh
./scripts/eval-skill-routing.sh
./scripts/eval-skill-routing-llm.sh   # real model call — run pre-release, not per-commit
```

- CI: `.github/workflows/smoke.yml` runs `smoke-check.sh` (which chains
  `smoke-fixture.sh` + `eval-skill-routing.sh`) on every push/PR to `main`,
  then — on `main` only, gated on that same green run — a `release` job
  tags and publishes a GitHub release whenever
  `.claude/skills/shipjaw-build/VERSION` names a tag that doesn't exist yet.
- Golden output shape: [`fixtures/golden-todo/`](fixtures/golden-todo/)
- Routing discovery cases: [`evals/routing-cases.yml`](evals/routing-cases.yml) — static (substring) +
  LLM (paraphrased `prompt` per case, semantic) coverage
- KB drift: `.claude/skills/shipjaw-build/scripts/validate-docs-drift.sh <project-root>` —
  mixed severity, on purpose. **Informational** (path references, staleness
  vs git history, pending migrations vs `features-index.md`) — tested
  against a real project and found too many legitimate false positives
  (abbreviated paths, dropped Next.js route-group folders) to safely gate
  on; read as a prompt to double-check, not a pass/fail signal. **Hard
  fail** (feature module folder absent from `features-index.md`) — a
  folder name is precise enough to gate on; zero false positives across 8
  real feature modules in testing. Wired into build/adopt/upgrade/ask; run
  against the golden fixture by `smoke-fixture.sh`.
- Gate: `run-gate.sh` runs a project's `db:migrate` script (if present)
  before tests — a committed-but-unapplied migration now fails the gate
  instead of shipping silently (found via real-project dogfooding).
- Gate: `run-gate.sh` also runs `validate-docs-drift.sh`'s feature-module
  check at the end — typecheck/lint/test/e2e can all be green while a
  whole new feature ships with zero mention in `features-index.md`; now
  the already-mandatory gate blocks that too, instead of relying on an
  easy-to-skip "optional" doc-update step. Workflow reordered in
  build/ask so KB updates happen **before** the gate runs.

Version: `.claude/skills/shipjaw-build/VERSION` · changelog: [`CHANGELOG.md`](CHANGELOG.md) · principles: [`skill-principles.md`](.claude/skills/shipjaw-build/references/skill-principles.md) · prompt craft: [`prompt-craft.md`](.claude/skills/shipjaw-prompt/references/prompt-craft.md) · regression: [`regression-and-business-rules.md`](.claude/skills/shipjaw-build/references/regression-and-business-rules.md)

## License

[MIT](LICENSE)
