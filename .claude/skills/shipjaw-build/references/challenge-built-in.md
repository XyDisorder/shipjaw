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
