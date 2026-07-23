---
name: shipjaw-ask
description: Continues, extends, fixes, or resumes work on a Shipjaw-scaffolded or Shipjaw-adopted TypeScript/Next app that already has documentation/knowledge-base/ and INDEX.md. Token-cheap: read INDEX.md first, then at most 1–2 relevant docs. Use when adding features, fixing bugs, refactors, implementing the next phase, continue this repo, resume after compact, fresh chat on this app, reprendre le projet, continuer cette app, corriger un bug, ajouter une feature, or when AGENTS.md / .cursor/rules/shipjaw.mdc say to follow shipjaw-ask. Do not use for greenfield bootstrap (shipjaw-build), adopting a foreign app with no KB (shipjaw-adopt), skill-only doc upgrades (shipjaw-upgrade), plan-only adversarial review (shipjaw-challenge), polishing a vague product idea (shipjaw-prompt), pure one-line CSS/copy tweaks, or non-TypeScript repos.
---

# shipjaw-ask

Continuation-only. Do **not** reload bootstrap discovery/architecture or
the full `shipjaw-build` SKILL body. Trust project tooling + docs.

## Challenge plans/choices (built-in — not slash-only)

Agents **must** challenge non-trivial plans and choices **in this session**
(prefer a separate Task/subagent as Challenger). Do **not** wait for the
user to type `/shipjaw-challenge`.

Before coding a **new phase**, new auth/persistence, primary UI, money/
authz, or any ADR/stack fork not forced by `tech-choices.md`:

1. Ensure the phase (or ADR) exists.
2. **Built-in pass:** Proposer ≤8 bullets → Challenger attacks (5 axes:
   product / business / tech / pragmatism / design). Prefer subagent;
   else same-session hard role flip. ≥1 Change/Defer **or** “no
   alternative + why”. No rubber-stamp.
3. Apply plan edits; note pass in the phase **Challenge** section
   (`built-in <date>` is enough unless escalating).
4. Only then implement.

**Escalate** to `/shipjaw-challenge` when the user asks, the plan stays
unstable, or you want a durable `challenge-report.md`. Detail:
`../shipjaw-build/references/challenge-built-in.md` (open only if unsure).

Skip only for tiny fixes inside an already-challenged phase (cite prior).

## Binding defaults (do not open principles unless conflict)

1. State lives in committed `documentation/` — update before done.
2. Progressive disclosure — INDEX → handoff.md → ≤2 files; Grep + offset reads.
3. Project owns conventions after bootstrap (tsconfig/eslint/CI/docs).
4. Core *User can…* first; no Out-of-v1 / drive-by scope.
5. Types / consts / helpers by ownership (`domain` / `application` /
   `features/<f>/lib`) — no grab-bag `lib/utils.ts`.
6. Ports in `application/ports/`; wire in `composition.ts`; actions stay
   thin (validate → use-case → map errors).
7. Bug ⇒ failing-then-passing regression test; never weaken tests to green.
8. Gate once; **stop after 2** failed fix attempts; ask the human.
9. End every run by overwriting `documentation/handoff.md` (template
   `../shipjaw-build/templates/handoff.md`) with next slash command.
10. On **doc↔code drift**, stop and resolve (see below) — don’t invent.
11. **Challenge** non-trivial plans/choices **in-session** (prefer
    Task/subagent); `/shipjaw-challenge` only for full report / escalate.
12. **Stamp lag:** if `scaffolded-with` / `adopted-with` is behind the
    installed `shipjaw-build/VERSION`, tell the user once and prefer
    `/shipjaw-upgrade` before heavy product work (unless they insist on
    the feature now). Run
    `../shipjaw-build/scripts/changelog-since-stamp.sh <root>` when
    explaining what changed.

## Anti-triggers

- No app yet / no KB → if only a rough idea, `shipjaw-prompt`; if a
  build-ready prompt exists (message or `source-prompt.md`),
  `shipjaw-build`; if an **existing** TS app has no KB → `shipjaw-adopt`
- User only wants skill/docs stamp refresh → `shipjaw-upgrade`
- Task is a one-line copy/CSS change → normal edit, don't load the whole
  continuation protocol beyond a quick INDEX peek if unsure

## Context budget — read in order, stop when enough

1. `documentation/INDEX.md` first. **Open when** = hard filter.
   - Missing INDEX but docs/app exist → repair INDEX (migration-aware).
   - Nothing there → stop; suggest `shipjaw-build` or `shipjaw-adopt`.
2. `documentation/handoff.md` if present.
3. Only the KB file(s) the task touches (1–2). No archives unless auditing.
4. Active phase file only if needed.
5. At most **one** reference under `../shipjaw-build/references/`, usually
   **zero**. Never open `discovery-questions.md` / `stack-shape.md` /
   `skill-principles.md` here by default.
   - 2nd gate failure → `gate-failure-modes.md`
   - UI/landing touch → `design-constraints.md`

Never preload `product/` or the full KB. Broad scope → new phase.

**Code reads:** Grep first; offset/limit on large files.
**Narration:** act; don't dump docs into chat.

## Drift protocol (docs ↔ code)

Run `../shipjaw-build/scripts/validate-docs-drift.sh <root>` first — it
surfaces three signals automatically, all informational (never blocking,
still needs a human/agent judgment call): unresolved path references, code
changed since a KB file's last git update, and migrations changed since
`features-index.md` was last touched. WARN lines can be false positives
(abbreviated paths, dropped route-group folders) — read them, don't treat
them as a gate. It cannot see one direction at all (code ahead of docs with
no migration involved); eyeball the signals below for that.

Before implementing, if anything below is inconsistent with the repo,
**stop and choose explicitly** (ask once if unclear):

| Signal | Example |
|---|---|
| INDEX/features-index lists a feature as shipped but routes/files missing | Docs ahead of code |
| Routes/features exist but INDEX/features-index omit them | Code ahead of docs |
| `scaffolded-with` missing / far behind installed skill | Offer `/shipjaw-upgrade` |
| Phase status `done` but *User can…* e2e absent for a critical journey | Tests/docs debt |
| Architecture “practice gaps” P0 still open on the path you must touch | Prefer converge slice first or include in this task |

Resolution (pick one, don’t silently invent):

1. **Repair docs** to match code (usual for drift found mid-feature), or
2. **Fix code** to match docs (when docs are the agreed source), or
3. **Defer** with a changelog/roadmap note + handoff next command

Never leave INDEX/features-index lying after you ship a path change.

## Checklist

```
- [ ] Read / repair INDEX + handoff; stamp lag → nudge /shipjaw-upgrade
- [ ] Drift check: validate-docs-drift.sh, then table above, on touched area
- [ ] Non-trivial work → built-in challenge (subagent preferred) before code
- [ ] ≤1 clarifying Q; stop if core behavior still ambiguous
- [ ] Implement (journey-first; domain tests; e2e edges if critical)
- [ ] UI touch → design-constraints.md floor
- [ ] ../shipjaw-build/scripts/run-gate.sh <root> [--with-e2e]
- [ ] On 2nd fail → gate-failure-modes.md then one focused fix; else ask human
- [ ] Surgical doc updates; optional validate-docs.sh / validate-docs-drift.sh
- [ ] Overwrite documentation/handoff.md
- [ ] Suggest /compact or fresh chat
```

## Workflow

1. Read / repair INDEX. Compare `scaffolded-with` to installed skill
   VERSION when known — if lagging, **nudge `/shipjaw-upgrade`** (run
   `changelog-since-stamp.sh` for the delta) before large work unless the
   user wants the feature immediately. Read handoff.
2. Drift check on the area the task touches.
3. If non-trivial (new phase / auth / data / primary UI / money) →
   **built-in** challenger pass (prefer Task/subagent); escalate to
   `/shipjaw-challenge` only if needed; apply plan edits **before** coding.
4. ≤1 clarifying question. If the **core behavior** is still ambiguous
   after that → **stop** and ask the human; do not invent the business rule.
5. Implement via project config as source of truth:
   - prefer the active phase's *User can…* / journey over drive-by polish
   - do not implement Out-of-v1 / out-of-phase scope "while we're here"
   - place new types/constants/helpers per
     `../shipjaw-build/references/project-structure.md` (no utils grab-bag)
   - new outside deps → port file + infra impl + wire in composition;
     Server Actions stay thin (no SQL / no domain rules in adapters)
   - map domain errors to UI/HTTP per project-structure table
   - domain/application → Vitest; invariants owned there (not UI-only)
   - bug fix → regression test (fail before / pass after)
   - never weaken/skip existing tests just to green
   - critical flow → Playwright golden path + e2e edges + axe + keyboard/focus
   - unit edges per `testing-and-ci.md` — don’t duplicate pure validation in e2e
   - marketing/primary UI → obey `design-constraints.md` (+ design-brief)
   - critical auth/money/state/multi-client → slim BR +
     `regression-and-business-rules.md` if needed
   - contracts consumers only if package exists
   - actions/endpoints → authz + session + middleware as needed
6. Gate via `run-gate.sh`; on **second** failure open
   `../shipjaw-build/references/gate-failure-modes.md`, apply one matching
   fix; if still red → stop and ask human.
7. Surgical KB / product updates; validate-docs / validate-docs-drift optional.
8. **Handoff (mandatory):** overwrite `documentation/handoff.md`.
9. Suggest `/compact` or fresh chat; point at INDEX + handoff.
