---
name: shipjaw
description: Shipjaw entrypoint — create a named project folder, cd into it, and explain the pipeline (shipjaw-prompt → shipjaw-build → shipjaw-ask; shipjaw-adopt for existing apps). Trigger on bare /shipjaw or "start a Shipjaw project". Do not scaffold here (use shipjaw-build). Do not craft the product prompt here (use shipjaw-prompt). If documentation/knowledge-base/ already exists, use shipjaw-ask instead.
---

# shipjaw (entrypoint)

**Onboarding only.** Does not scaffold code and does not write
`source-prompt.md`. It prepares a clean working directory, then routes
the user to the right next skill.

## Anti-triggers

- `documentation/knowledge-base/` already exists in the **current**
  workspace → explain that the app is already bootstrapped; use
  `/shipjaw-ask`. Do **not** create a sibling folder unless the user
  explicitly wants a **new** project.
- Current workspace is an existing app **without** Shipjaw KB →
  recommend `/shipjaw-adopt` (do not mkdir a sibling unless they want a
  new greenfield project).
- User already named a folder and only wants prompt craft →
  `/shipjaw-prompt`
- User already has a build-ready prompt → `/shipjaw-build`

## Workflow

### 1. Project folder

1. If the user message already contains a folder/project name, use it
   (sanitize to a safe directory name: lowercase, `a-z0-9-`, collapse
   spaces to `-`).
2. Otherwise ask **one** question (structured tool if available, else
   chat): *What should we name the project folder?* Offer 2–3 slug
   suggestions inferred from any product hint they gave.
3. Resolve the parent directory:
   - Default: the user's current workspace parent if already inside a
     mono-workspace, else the current working directory's parent, else
     `~/Documents` / the cwd — prefer **creating as a sibling of the
     current project** when cwd looks like an existing git app, otherwise
     create under the current cwd.
   - If unclear, ask once: create under current directory vs choose path.
4. `mkdir -p <path>/<slug>` if it does not exist. If it exists and is
   non-empty, stop and ask whether to reuse it or pick another name.
5. **Switch context into that folder** for all following work in this
   session: run subsequent shell commands with that working directory
   (and tell the user the absolute path). Do not scaffold yet.

### 2. Explain the pipeline (always, briefly)

After the folder exists, reply in the user's language with this map
(keep it short — no essay):

| Command | When | What it does |
|---|---|---|
| `/shipjaw-prompt` | Idea still rough | Turns notes into a dense build-ready prompt → `documentation/product/source-prompt.md` (no app code) |
| `/shipjaw-build` | Prompt ready (file or paste) | Docs + TypeScript/Next scaffold + v1 + gate |
| `/shipjaw-adopt` | Existing TS/Next app, no Shipjaw KB | Docs + continuation contract + tooling gaps — **no** rewrite |
| `/shipjaw-ask` | App already has `documentation/knowledge-base/` | Features / fixes — reads `INDEX.md` + 1–2 files |

Recommended next step for a greenfield folder:

```text
/shipjaw-prompt <your idea in your own words>
```

Then:

```text
/shipjaw-build
```

Existing app without Shipjaw docs:

```text
/shipjaw-adopt
```

Later sessions:

```text
/shipjaw-ask <feature or fix>
```

### 3. Stop

Do **not** start prompt-craft, build, or adopt unless the user
explicitly asks in the same message after onboarding. Hand off cleanly.

## Hard rules

- No `create-next-app`, no KB, no CI in this skill.
- One clarifying question max for the folder name/path.
- Narration budget: folder path + the table above + one recommended
  next command.

## Related skills

- `shipjaw-prompt` · `shipjaw-build` · `shipjaw-adopt` · `shipjaw-ask`
- Principles: `../shipjaw-build/references/skill-principles.md`
