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

| Express (`shipjaw-prompt`) | Build (`shipjaw-build`) | Continue (`shipjaw-ask`) |
|---|---|---|
| Rough idea → dense product prompt | Prompt → docs + scaffold + v1 | `INDEX.md` + 1–2 files |
| Clarifies only what’s missing | Tech choices from the **prompt** | No rediscovery |
| Writes `product/source-prompt.md` | Committed `documentation/` | State in the repo, not chat |
| No code, no KB yet | Strict TS, tests, security gate | Same contract, minimal tokens |
| | Invariants in domain/application | Bug fix ⇒ regression test |

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
  Rough idea / notes
         │
         ▼
 ┌───────────────────┐
 │  shipjaw-prompt   │  express once (optional if prompt is ready)
 │  → source-prompt  │
 └─────────┬─────────┘
           │  documentation/product/source-prompt.md
           ▼
 ┌───────────────────┐
 │  shipjaw-build    │  bootstrap once
 │  docs → scaffold  │
 │  → v1 + gate      │
 └─────────┬─────────┘
           │  documentation/INDEX.md  (committed)
           ▼
 ┌───────────────────┐
 │   shipjaw-ask     │  every later feature / fix
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
`/shipjaw-prompt` → `/shipjaw-build` → `/shipjaw-ask`.

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

**3. Continue** — same repo, later:

```text
/shipjaw-ask Add a done/active filter and the matching e2e
```

Compact between tasks (`/compact` on Claude, or a fresh chat on Cursor): resume from `documentation/`.

## Installation

### In this repo

- Claude Code: `.claude/skills/*`  
- Cursor: `.cursor/skills/*` (symlinks → single source of truth)

### Global (any project)

```sh
git clone https://github.com/XyDisorder/shipjaw.git
cd shipjaw

mkdir -p ~/.claude/skills ~/.cursor/skills

ln -s "$(pwd)/.claude/skills/shipjaw"        ~/.claude/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-prompt" ~/.claude/skills/shipjaw-prompt
ln -s "$(pwd)/.claude/skills/shipjaw-build"  ~/.claude/skills/shipjaw-build
ln -s "$(pwd)/.claude/skills/shipjaw-ask"    ~/.claude/skills/shipjaw-ask

ln -s "$(pwd)/.claude/skills/shipjaw"        ~/.cursor/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-prompt" ~/.cursor/skills/shipjaw-prompt
ln -s "$(pwd)/.claude/skills/shipjaw-build"  ~/.cursor/skills/shipjaw-build
ln -s "$(pwd)/.claude/skills/shipjaw-ask"    ~/.cursor/skills/shipjaw-ask
```

Keep the skills as **siblings** so relative `../shipjaw-build/references/` paths resolve.

> Migrating from `skill-my-app` / old single `shipjaw` bootstrap: remove old symlinks, link the four skills above. Legacy `scaffolded-with: skill-my-app@…` / `shipjaw@…` stamps still work. Bootstrap is now **`shipjaw-build`**.

## Why it’s different

| Typical agent approach | Shipjaw |
|---|---|
| Jump straight into code from vibes | Optional **prompt craft** before scaffold |
| Everything in the transcript | Versioned state in `documentation/` |
| One mega catch-all prompt | Express ≠ build ≠ continue |
| “No `any`” as forgettable prose | Encoded in tsconfig / eslint / CI |
| Gitignored docs → amnesiac clones | **Committed** docs |
| Fixes that quietly regress | Bug ⇒ failing-then-passing test |

## Anti-triggers (don’t use the wrong skill)

- Bare start / need a project folder → **`/shipjaw`**  
- Vague idea, no prompt yet → **`shipjaw-prompt`**, not build  
- One-off CSS / copy tweak → normal edit  
- Non-TypeScript repo → refuse  
- KB already exists → **`shipjaw-ask`**, not build  

## Maintainers

```sh
./scripts/smoke-check.sh
```

Version: `.claude/skills/shipjaw-build/VERSION` · changelog: [`CHANGELOG.md`](CHANGELOG.md) · principles: [`skill-principles.md`](.claude/skills/shipjaw-build/references/skill-principles.md) · prompt craft: [`prompt-craft.md`](.claude/skills/shipjaw-prompt/references/prompt-craft.md) · regression: [`regression-and-business-rules.md`](.claude/skills/shipjaw-build/references/regression-and-business-rules.md)
