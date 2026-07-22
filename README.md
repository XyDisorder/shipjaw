# Shipjaw

<p align="center">
  <img src="assets/logo-dark-wordmark.png" alt="Shipjaw — Ship the product. Not the prompt engineering." width="720" />
</p>

<p align="center">
  <strong>Ship the product — solid tech, docs that scale, tokens kept low.</strong>
</p>

<p align="center">
  Claude Code &amp; Cursor skills to scaffold and grow production-grade apps<br/>
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

- code that *sometimes* compiles  
- no stable architecture  
- missing or invented docs  
- features that regress because nothing owns the business rules  
- the next session **re-deriving everything** and burning your token budget  

**Shipjaw** flips that: bootstrap once with real foundations; every later change stays cheap, tested, and faithful to the product.

## The promise

| At bootstrap (`shipjaw`) | Afterward (`shipjaw-ask`) |
|---|---|
| Targeted questions (not an interrogation) | Reads `INDEX.md` + 1–2 relevant files |
| Tech choices derived from the **prompt** | No rediscovery, no re-architecture |
| Committed `documentation/` | State lives in the repo, not the chat |
| Deterministic scaffold (copy-ready kit) | Typecheck / lint / test / e2e gate |
| Strict TS, clean architecture, App Router security | Same contract, minimal token bill |
| Invariants owned in domain/application | Bug fix ⇒ regression test; never weaken tests to green |

One line: **docs-first, tooling-enforced, continuation cheap, regressions blocked.**

## What you get

- A **Next.js** app (App Router) with `domain` → `application` → `infrastructure` → presentation layers  
- **NestJS in a monorepo** only when the product justifies it (multi-client API, workers, etc.)  
- **Rules compiled** into tsconfig, eslint, CSP headers, Vitest, Playwright + a11y (axe)  
- A **living knowledge base**: architecture, domain, decisions, changelog — rotated so it stays short  
- **Tiered business-rule safety**: short pre-change analysis always; slim `BR-XXX` docs when auth / money / multi-state / multi-client matter  
- **Automatic tech decisions**: signal → stack tables (`tech-choices.md`) — you don’t pick Drizzle vs Nest “by vibe”  
- Works with **Claude Code** and **Cursor**

## How it works

```text
  Your product prompt
         │
         ▼
 ┌───────────────────┐
 │     shipjaw       │  bootstrap once
 │  discovery → docs │
 │  → scaffold → v1  │
 └─────────┬─────────┘
           │  documentation/INDEX.md  (committed)
           ▼
 ┌───────────────────┐
 │   shipjaw-ask     │  every later feature / fix
 │  INDEX + 1–2 files│
 └───────────────────┘
```

Two skills, one contract. Pay the expensive thinking once; keep day-to-day work light — without sacrificing delivery quality.

## Usage

**1. Bootstrap** — new project:

```text
/shipjaw A personal todo tool, no accounts, minimal UI, local persistence
```

**2. Continue** — same repo, later:

```text
/shipjaw-ask Add a done/active filter and the matching e2e
```

Compact context between unrelated tasks (`/compact` on Claude, or a fresh chat on Cursor): **everything needed to resume already lives in `documentation/`**.

## Installation

### In this repo

- Claude Code: `.claude/skills/*`  
- Cursor: `.cursor/skills/*` (symlinks → single source of truth)

### Global (any project)

```sh
git clone https://github.com/XyDisorder/shipjaw.git
cd shipjaw

mkdir -p ~/.claude/skills ~/.cursor/skills

ln -s "$(pwd)/.claude/skills/shipjaw" ~/.claude/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-ask"   ~/.claude/skills/shipjaw-ask

ln -s "$(pwd)/.claude/skills/shipjaw" ~/.cursor/skills/shipjaw
ln -s "$(pwd)/.claude/skills/shipjaw-ask"   ~/.cursor/skills/shipjaw-ask
```

Keep both skills as **siblings** so `shipjaw-ask` can resolve `../shipjaw/references/` when needed.

> Renaming from the old `skill-my-app` install: remove the old symlinks, clone/pull this repo, then link `shipjaw` + `shipjaw-ask` as above. Legacy `scaffolded-with: skill-my-app@…` stamps still work via migration notes.

## Why it’s different

| Typical agent approach | Shipjaw |
|---|---|
| Everything in the transcript | Versioned state in `documentation/` |
| One mega catch-all prompt | Expensive bootstrap ≠ cheap continuation |
| “No `any`” as forgettable prose | Encoded in tsconfig / eslint / CI |
| Config reinvented every time | Copy `templates/scaffold/` |
| Nest “just in case” | Nest only when the prompt justifies it |
| Gitignored docs → amnesiac clones | **Committed** docs; `shipjaw-ask` survives clone |
| Fixes that quietly regress | Bug ⇒ failing-then-passing test; invariants in domain |

## Anti-triggers (don’t use it for)

- A one-off CSS / copy tweak  
- A non-TypeScript repo  
- A project that **already** has `documentation/knowledge-base/` → use **`shipjaw-ask`**, not bootstrap  

## Maintainers

```sh
./scripts/smoke-check.sh
```

Version: `.claude/skills/shipjaw/VERSION` · changelog: [`CHANGELOG.md`](CHANGELOG.md) · principles: [`skill-principles.md`](.claude/skills/shipjaw/references/skill-principles.md) · regression: [`regression-and-business-rules.md`](.claude/skills/shipjaw/references/regression-and-business-rules.md) · tech choices: [`tech-choices.md`](.claude/skills/shipjaw/references/tech-choices.md)
