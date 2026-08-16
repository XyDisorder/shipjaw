# Contributing to Shipjaw

Shipjaw is a set of Claude Code / Cursor skills, not a library — most of
what you're editing is Markdown (`SKILL.md` + `references/*.md`) and a
handful of bash scripts. The bar for a change isn't "sounds right," it's
**dogfooded**: run against a real project, not just the golden fixture.

## Before you open a PR

1. **Ground it in a real symptom.** The best fixes in this repo's
   `CHANGELOG.md` all start the same way: a real project did something
   wrong, or an agent misread an instruction on real work — not a
   hypothetical. If you're fixing a bug, say what real (or realistically
   reproduced) scenario triggered it.
2. **Run the test suite:**
   ```sh
   ./scripts/smoke-check.sh     # structural checks across every skill
   ./scripts/smoke-fixture.sh   # golden fixture (fixtures/golden-todo/)
   ./scripts/eval-skill-routing.sh
   ```
   `eval-skill-routing-llm.sh` costs a real `claude -p` call — only run it
   for routing/description changes, not every PR.
3. **If you touch a skill's behavior**, add a `smoke-check.sh` assertion
   that would have failed before your fix. A prose instruction that
   nothing checks tends to silently stop being followed — see
   `CHANGELOG.md`'s repeated "mechanism exists but isn't wired in"
   pattern.
4. **VERSION / CHANGELOG stay in sync.** Any behavior change to a skill
   gets a `CHANGELOG.md` entry, and
   `.claude/skills/shipjaw-build/VERSION` must exactly match the newest
   `## ` header (dots, not dashes — `smoke-check.sh` enforces this).
5. **Keep skills thin.** `SKILL.md` is the always-loaded part — new
   detail belongs in `references/*.md`, opened only when the workflow
   step actually needs it. See `references/skill-principles.md`
   (principle 3, progressive disclosure) before adding a new reference
   file or growing an existing one past a couple hundred lines.

## Repo layout

- `.claude/skills/*` — source of truth. `.cursor/skills/*` are symlinks
  into it; don't edit the Cursor side directly.
- `fixtures/golden-todo/` — the structural test fixture. Its
  `package.json` scripts are `echo` stubs on purpose (no `npm install`
  needed to run the suite).
- `evals/routing-cases.yml` — which prompt should route to which skill;
  add a case here if you change a skill's `description:` trigger phrases.

## What's out of scope for a PR

- Product-code generators / templates for stacks other than TypeScript +
  Next.js (+ NestJS when justified) — that boundary is deliberate, see
  the README's "Positioning" section.
- Speculative architecture (new modules, plugin systems, multi-language
  support) without a real project that needed it. See
  `evals/routing-cases.yml` and `CHANGELOG.md` for how much this project
  favors small, dogfooded increments over up-front design.

## Questions / proposals

Open a [Discussion](../../discussions) for anything bigger than a bug fix
— a new skill, a workflow change, a positioning question — before
sinking time into a PR.
