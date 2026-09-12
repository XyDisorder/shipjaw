# Built-in challenge (default for all work skills)

Agents must **challenge plans and non-forced choices** while they work —
not only when someone types `/shipjaw-challenge`.

`/shipjaw-challenge` is the **optional full ritual** (dedicated report file,
slash-only lock ceremony). The **minimum** below is always on.

## When (minimum bar)

Run a challenger pass before locking any of:

- phase scope / *User can…* / Out of v1
- ADR or stack fork not forced by `tech-choices.md`
- new auth, persistence, primary UI, money/authz approach
- “we’ll do X this way” product or architecture calls in chat

Skip only: one-line CSS/copy, typo, pure mechanical rename, or work
inside an already-challenged phase with no new decision.

## Scale the pass to actual stakes

The list above triggers on shape ("new dependency", "primary UI") — it
doesn't ask whether anything is actually at risk. Real-dogfood catch
(tcg-collection, 2026-09-09): a purely decorative addition to a
single-user personal tool (no auth, no persisted data, no other users)
got the **full** 5-axis subagent pass and a wall of output before any
code existed, for a change with none of the failure modes that ritual
exists to catch. That's disproportionate, and disproportionate process
is itself a Shipjaw defect — not a safe default.

Two tiers, same "no rubber-stamp" spirit:

- **Full pass** (as below) when the change touches **any** of: auth,
  money, persisted/shared data, multi-user or authz boundaries, an
  irreversible/hard-to-undo action, or when it **removes or contradicts**
  an existing documented decision/non-goal (rewriting product vision,
  not just adding to it).
- **Light self-check** — one short paragraph, no subagent, no 5-axis
  table — when **all** of: single-user/personal project, purely
  additive (nothing existing removed or contradicted), reversible
  (behind a toggle, lazy-loaded, or trivially deletable), and confined
  to presentation (no domain/application logic, no data model change).
  State the one biggest real risk (version compatibility, bundle/perf
  cost, an a11y or fallback gap) and how it's handled, then proceed.
  If the self-check surfaces something that actually matches a full-pass
  trigger, escalate — don't downgrade to dodge the ritual after the fact.

When unsure which tier applies, that uncertainty itself is a signal to
run the full pass once — the light tier is for clear-cut low-stakes
cases, not a default to reach for.

## How (prefer a separate mind)

1. **Proposer** — ≤8 bullets: goal, *User can…*, approach, out of scope, risks.
2. **Challenger** — prefer Cursor `Task` / subagent (or second chat) with
   only the artifact + INDEX + ≤2 docs — **not** the proposer’s excuses.
   Axes: Product · Business · Tech · Pragmatism · Design
   (`design-constraints.md` when UI). Forbid “LGTM”.
3. **Fallback** — same session, hard role flip: attack the plan; invent
   one simpler alternative you would ship instead.
4. **Resolve** — ≥1 Keep/Change/Defer per axis **or** explicit
   “no viable alternative + why”. Apply Change to the plan/ADR **before**
   code. Note the pass in the phase **Challenge** section (path to full
   report if any, else “built-in <date>”).

Rubber-stamp with zero pushback = **invalid**. Re-run.

## Escalate to `/shipjaw-challenge`

Use the slash skill when: the user asks; the first built-in pass left the
plan unstable; locking a meaty phase/ADR and you want a durable
`challenge-report.md` in the repo.
