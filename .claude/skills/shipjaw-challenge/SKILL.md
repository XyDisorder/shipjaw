---
name: shipjaw-challenge
description: Adversarially challenges a Shipjaw phase plan, ADR, or tech/product decision using a proposer vs challenger split (prefer a separate subagent for the challenger). Scores product, business, tech, pragmatism, and design fit; writes a challenge report and updates the plan. Use when locking a non-trivial phase, reviewing an ADR, before implementing a big slice, challenge this plan, or contester ce plan. Do not implement product code here. Do not use for greenfield scaffold (shipjaw-build), adopt, or routine tiny CSS/copy (shipjaw-ask). Do not rubber-stamp.
disable-model-invocation: true
---

# shipjaw-challenge

**Challenge only.** Two roles must disagree usefully before a plan is
locked. Does **not** scaffold, adopt, or implement features.

**Axes** (score each Keep / Change / Defer + one sharp reason):

1. **Product** — is the *User can…* the real core? Out of v1 ruthless enough?
2. **Business** — value vs effort; what proves it worked?
3. **Tech** — simpler option? clean-arch / ports / debt tradeoff sound?
4. **Pragmatism** — shippable this phase? fallback if blocked?
5. **Design** — fit `design-brief` + `design-constraints.md` (not AI chrome)?

**References (on demand):**
`../shipjaw-build/references/design-constraints.md` ·
`../shipjaw-build/references/tech-choices.md` ·
`../shipjaw-build/references/project-structure.md` ·
`../shipjaw-build/templates/challenge-report.md`

## Anti-triggers

- No target plan/ADR/phase → ask once what to challenge, or stop
- One-line CSS/copy → refuse
- User wants code now with no plan → `shipjaw-ask` / `shipjaw-build`
- Complete rubber-stamp (“looks good”) with no Change/Defer and no
  rejected alternative → **invalid**; force at least one substantive pushback
  or an explicit “no viable alternative; here’s why”

## Dual-agent protocol (mandatory)

### Role A — Proposer (current session)

1. Point at the artifact: phase file, ADR in `decisions.md`, or a short
   pasted plan. If missing, draft a minimal phase from the template first
   (**still do not implement**).
2. State in ≤8 bullets: goal, *User can…*, stack/approach, out of scope,
   risks.

### Role B — Challenger (separate mind)

**Prefer a real second agent** when the host allows it (Cursor `Task` /
subagent, or a second chat with only the plan + INDEX + this skill).
Prompt the challenger with:

- Read-only: the plan artifact, `INDEX.md`, relevant design-brief,
  architecture one-pager — **not** the proposer’s chat rationalizations
- Mission: attack weak assumptions; propose a **simpler** alternative;
  score the five axes; forbid “LGTM”
- Output: fill `templates/challenge-report.md`

**Fallback** if no second agent: same session but **hard reset** —
do not defend the plan; write the report as Challenger only; invent at
least one concrete alternative you would ship instead.

### Role A — Resolve

1. Merge Challenge section into the phase (or ADR): Keep / Change / Defer
   per axis + final call.
2. If Change: edit the plan **before** any implementation.
3. Overwrite `documentation/handoff.md` → next `/shipjaw-ask` (or re-challenge
   if still unstable).
4. Stop. Do not code in this skill.

## When build/ask must invoke this

Non-trivial work (new phase, new persistence/auth, new primary UI surface,
money/authz, or any ADR that isn’t forced by `tech-choices.md`) →
**challenge before implement**. Trivial bugfix inside an already-challenged
phase may skip.

## Checklist

```
- [ ] Identify artifact (phase / ADR / plan)
- [ ] Proposer summary (≤8 bullets)
- [ ] Challenger pass (subagent preferred) → challenge-report
- [ ] At least one Change/Defer OR documented “no alternative”
- [ ] Update phase Challenge section / ADR
- [ ] handoff.md → next ask (implement) or re-challenge
- [ ] Stop (no product code)
```

## Hard rules

- Challenger must not implement; Proposer must not skip the report.
- Token budget: INDEX + artifact + ≤2 docs; no full KB dump to challenger.
- Narration: scores + final call + path to report/phase.
