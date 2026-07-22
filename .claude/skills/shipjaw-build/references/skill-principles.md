# Operating principles (binding for all Shipjaw skills)

These are product decisions for *how the skills behave*, not app-domain
rules. Agents must follow them; do not re-litigate mid-task.

1. **Entrypoint + three work skills.** `/shipjaw` = onboarding only
   (create/cd into a named project folder, explain the pipeline).
   `shipjaw-prompt` = expression only (rough idea →
   `documentation/product/source-prompt.md`). `shipjaw-build` =
   bootstrap only (prompt → docs + scaffold + v1). `shipjaw-ask` =
   every later session. Continuation never reloads bootstrap
   discovery/architecture docs or re-derives the stack. If KB exists →
   hand off to ask; if INDEX missing but docs exist → repair, don't
   bootstrap. Prompt and entrypoint must **never** create
   `knowledge-base/`.


2. **State lives in the repo, not the transcript.** Anything needed to
   resume (architecture, decisions, phase status, contracts) is written
   to committed `documentation/` and/or config before the turn ends.
   Chat is disposable. After `/compact` or a new chat, recovery = read
   `INDEX.md`, not "remember last session."

3. **Progressive disclosure.** SKILL.md stays thin. Rare detail lives in
   `references/*` and is opened **only when the current step needs it**
   — never "just in case." `shipjaw-ask`: at most **one** reference file
   per task, and usually zero. Same idea as `INDEX.md` → one/two KB files.

4. **Compile rules into tooling.** Bootstrap is incomplete until typing /
   lint / headers / CI / scripts actually encode the hard rules
   (`templates/scaffold/` → tsconfig, eslint, next.config, playwright,
   CI). Future sessions trust the linter/typechecker/CI, not prose.

5. **Templates over prose.** If `templates/` or `templates/scaffold/`
   has a file for it, **copy and adapt** — do not regenerate from a
   paragraph. Invented parallel configs are a regression.

6. **Host-portable actions.** Say *what* to do, then *how* per host:
   questions → structured tool if present (`AskUserQuestion` /
   `AskQuestion`), else numbered chat (max 4/round). Compact context →
   `/compact` (Claude) or fresh chat / short handoff (Cursor). Never
   require a Claude-only API with no fallback.

7. **Hard stop budgets.** Discovery: max **2 rounds**, ~**8** questions
   total, then default and record. Clarification in continuation: **1**
   short question. Verification: **1** gate per task/phase, max **2**
   fix attempts, then stop and ask the human. No third blind retry. No
   unbounded "read the whole repo."

8. **No contradictory product defaults.** Docs are **committed** (not
   gitignored) so continuation works cross-machine. `packages/contracts/`
   rules apply **only when that package exists**. Nest / modern-extras
   files load **only when stack/discovery activated them**. If two
   instructions conflict, prefer the more specific conditional rule and
   fix the docs — don't improvise a third path.

9. **Dogfood the skill.** Maintainers run `./scripts/smoke-check.sh`
   after editing skills/templates. Periodically run a tiny real
   `/shipjaw-build` smoke app when Next/tooling majors move. A skill that
   isn't exercised drifts.

10. **Migration over forced upgrades.** Old projects stay valid. Use
    `references/migration.md` when `scaffolded-with` is missing or docs
    look pre-committed-docs. Never re-bootstrap to "catch up."

11. **Anti-triggers.** Do not use these skills for: single-file cosmetic
    CSS tweaks, non-TypeScript repos, pure design/copy with no app, or
    repos that already have their own conflicting architecture skill as
    the convention owner. Prefer a normal coding turn instead.

12. **Don't paste framework docs.** Teach stable project patterns (trees,
    ports, gates). Do not dump or mirror Next/Nest documentation pages
    into references or `documentation/` — link concepts, keep patterns
    short; framework docs go stale faster than hard rules.

13. **Idempotent scaffold.** If a target file already exists and already
    encodes the required rule (strict flags, headers, webServer, etc.),
    leave it alone or merge minimally. Never overwrite custom project
    config wholesale with the template on re-run or upgrade.

14. **Narration budget.** Act; don't lecture. Don't paste reference file
    contents into the user chat. Status updates: a few short sentences
    max unless the user asks for detail. Discovery answers and decisions
    go into `documentation/`, not long essays in the transcript.

15. **Stamp the skill version.** At scaffold (and on doc upgrades), set
    in `architecture.md`:
    `scaffolded-with: shipjaw-build@<VERSION>` where VERSION is the
    contents of `shipjaw-build/VERSION` (YYYY.MM.DD). Enables migration
    detection later.

16. **One convention owner.** After bootstrap, the **project** owns
    conventions via its committed `documentation/` + tsconfig/eslint/CI
    + `AGENTS.md` / `.cursor/rules/shipjaw.mdc` (continuation contract).
    The skill only fills gaps. If the project later adopts a design
    system or ADR that conflicts with a skill default, follow the
    project and record the deviation in `architecture.md` — don't fight
    it on every task.

17. **Regression & business-rule safety (tiered).** Every behavior
    change preserves documented invariants. Always: short pre-change
    bullets; invariants owned in domain/application; bug fix ⇒
    failing-then-passing regression test; never weaken tests to green;
    characterization before rewriting fuzzy legacy; gate + docs current.
    Critical paths (auth, money, multi-state, multi-client, migrations)
    add slim `BR-XXX` docs and contract/state/side-effect checks.
    → `references/regression-and-business-rules.md`

18. **Ship the core journey first.** v1 and each phase optimize for one
    demonstrable *User can …* outcome before polish, extras, or
    speculative platform work. Phase-01 (and any critical flow) is not
    done until a golden-path e2e proves that journey. Do not implement
    Out-of-v1 items "while we're here." Ambiguous product behavior →
    ≤1 clarifying question, then **stop** — do not invent the business
    rule. Phases should be demonstrable to a non-dev when possible.
    → phase template `User can…` · `prompt-craft.md` · product-feature
    journey section.
