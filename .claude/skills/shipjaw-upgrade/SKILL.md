---
name: shipjaw-upgrade
description: Upgrades an existing Shipjaw app's docs and continuation contract to the installed skill VERSION — applies migration table gaps, refreshes AGENTS.md / Cursor rule, stamps scaffolded-with, ensures handoff.md. Use when skill version changed, legacy stamps, docs look outdated, upgrade Shipjaw on this repo, or refresh contract only. Do not use for greenfield (shipjaw-build), first-time foreign apps (shipjaw-adopt), vague ideas (shipjaw-prompt), or normal features/fixes (shipjaw-ask). Do not rewrite product code.
disable-model-invocation: true
---

# shipjaw-upgrade

**Upgrade only.** Bring docs + continuation contract in line with the
current Shipjaw skill VERSION. Does **not** re-scaffold the app and does
**not** implement product features.

After upgrade → `/shipjaw-ask` for product work or converge-arch slices.

**Principles:** `../shipjaw-build/references/skill-principles.md`.
**Migration table:** `../shipjaw-build/references/migration.md`.
**VERSION:** `../shipjaw-build/VERSION`.

## Anti-triggers

- No app / empty folder → `/shipjaw` then prompt/build
- App with code but **no** `documentation/knowledge-base/` →
  `shipjaw-adopt` first
- Feature/fix request → `shipjaw-ask`
- Vague product idea → `shipjaw-prompt`
- Want a new Next app → `shipjaw-build` in a new folder

## Checklist

```
- [ ] Confirm KB exists (else hand off adopt)
- [ ] Read VERSION + architecture scaffolded-with / adopted-with
- [ ] Apply migration.md gaps (idempotent, one pass)
- [ ] copy-continuation-contract.sh (refresh AGENTS/rule if missing/stale)
- [ ] stamp-provenance.sh (refresh scaffolded-with to current VERSION)
- [ ] Ensure handoff.md exists (template); don’t invent a fake next task
- [ ] validate-docs.sh
- [ ] Update changelog + handoff; stop
```

## Workflow

### 1. Detect

Require `documentation/knowledge-base/` + preferably `INDEX.md`.
If missing → stop; recommend `/shipjaw-adopt`.

Read current stamps in `architecture.md`. Note installed skill VERSION.

### 2. Apply migration gaps

Follow `../shipjaw-build/references/migration.md` **era-specific upgrades**
for everything that still applies (INDEX banner, AGENTS/rule, docs
committed, practice-gaps section, etc.). Idempotent: don’t overwrite
custom content with blank templates.

Do **not** mass-move folders or rewrite features. Structural clean-arch
convergence stays on the converge-arch phase via `shipjaw-ask`.

### 3. Refresh contract + stamp

```bash
../shipjaw-build/scripts/copy-continuation-contract.sh <project-root>
../shipjaw-build/scripts/stamp-provenance.sh <project-root>
# if adopted originally, also keep/refresh adopted-with via:
# ../shipjaw-build/scripts/stamp-provenance.sh <project-root> --adopted
../shipjaw-build/scripts/validate-docs.sh <project-root>
```

If `handoff.md` missing, copy `../shipjaw-build/templates/handoff.md` and
fill next command from INDEX current phase (or ask once).

### 4. Record + stop

- Append `changelog.md`: upgraded docs/contract to `shipjaw-build@VERSION`
- Overwrite `handoff.md` with next recommended `/shipjaw-ask …`
- Brief reply: from-stamp → to-stamp, files touched, what was left alone

## Hard rules

- No `create-next-app`, no product rewrite, no drive-by features.
- Prefer merge/fill over overwrite.
- Narration budget: stamp delta + migration items applied + handoff.
