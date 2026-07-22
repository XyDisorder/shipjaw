# Shipjaw

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
| Refresh stamps / AGENTS / migration gaps only | `/shipjaw-upgrade` |
| Challenge a phase/ADR before coding | `/shipjaw-challenge` |
| Feature / fix / continue in a Shipjaw app | `/shipjaw-ask` |

Scaffolded apps also get `AGENTS.md` + `.cursor/rules/shipjaw.mdc` so the
continuation contract applies even if you forget the slash — still prefer
`/shipjaw-ask` so the skill loads on purpose.

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

> Migrating from older installs: link **all seven** skills above. Legacy stamps still work. Non-trivial phases should run **`/shipjaw-challenge`** before implement.

## Why it’s different

| Typical agent approach | Shipjaw |
|---|---|
| Jump straight into code from vibes | Optional **prompt craft** before scaffold |
| Everything in the transcript | Versioned state + **handoff.md** |
| One mega catch-all prompt | Express ≠ build ≠ adopt ≠ upgrade ≠ **challenge** ≠ continue |
| “No `any`” as forgettable prose | Encoded in tsconfig / eslint / CI |
| Gitignored docs → amnesiac clones | **Committed** docs |
| Fixes that quietly regress | Bug ⇒ failing-then-passing test |

## Anti-triggers (don’t use the wrong skill)

- Bare start / need a project folder → **`/shipjaw`**  
- Vague idea, no prompt yet → **`shipjaw-prompt`**, not build  
- Existing app without Shipjaw docs → **`shipjaw-adopt`**, not build  
- Only bump skill docs/stamps → **`shipjaw-upgrade`**, not ask  
- Challenge a plan before coding → **`shipjaw-challenge`**  
- One-off CSS / copy tweak → normal edit  
- Non-TypeScript repo → refuse  
- KB already exists + product work → **`shipjaw-ask`**, not build  

## Maintainers

```sh
./scripts/smoke-check.sh
./scripts/smoke-fixture.sh
./scripts/eval-skill-routing.sh
```

- Golden output shape: [`fixtures/golden-todo/`](fixtures/golden-todo/)
- Routing discovery cases: [`evals/routing-cases.yml`](evals/routing-cases.yml)

Version: `.claude/skills/shipjaw-build/VERSION` · changelog: [`CHANGELOG.md`](CHANGELOG.md) · principles: [`skill-principles.md`](.claude/skills/shipjaw-build/references/skill-principles.md) · prompt craft: [`prompt-craft.md`](.claude/skills/shipjaw-prompt/references/prompt-craft.md) · regression: [`regression-and-business-rules.md`](.claude/skills/shipjaw-build/references/regression-and-business-rules.md)
