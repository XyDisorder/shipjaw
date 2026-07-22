# documentation/ folder structure

Created at the project root during scaffolding and **committed with the
repo** — do **not** add `documentation/` to `.gitignore`. It is the
shared, AI-facing map that makes `shipjaw-ask` work after clone, on another
machine, or for a teammate. Always keep it current, and keep it **cheap
to re-read** (paths/signatures only, no secrets, no pasted code).

If a user explicitly wants docs local-only, they may gitignore it — but
warn that `shipjaw-ask` will then fail for anyone who doesn't have those
files. Default = versioned.

```
documentation/
  INDEX.md                      # the map — see below. Read first, every session.
  technical-plan/
    00-roadmap.md                # ordered phase list with status, links to phase files
    phase-01-<slug>.md            # active phases only — templates/technical-plan-phase.md
    phase-02-<slug>.md
    phase-archive/                # completed phases moved here on demand
      phase-01-<slug>.md
  product/
    overview.md                  # vision, target users, value prop, success criteria
    design-brief.md               # style, palette, fonts, references, i18n, dark mode
    features/
      <feature-slug>.md           # one file per feature/epic — templates/product-feature.md
    business-rules/               # create when ≥1 critical rule (auth/money/state/multi-client)
      BR-001-<slug>.md            # slim rule — templates/business-rule.md
  knowledge-base/
    architecture.md               # the REAL, current architecture & folder layout
    domain-model.md                # entities/DTOs/relations as they exist in code today
    api-reference.md               # endpoints + request/response shapes + auth (if an API exists)
    features-index.md               # live status table: feature -> shipped? -> key files
    decisions.md                     # active ADR-style log (short entries only)
    decisions-archive.md             # superseded/rotated decisions (created on demand)
    changelog.md                      # dated running log, most recent entry first
    changelog-archive.md               # older entries rotated out of changelog.md (created on demand)
```

## `documentation/INDEX.md` — the map (this is the token-optimization lever)

This is the **only file a continuation session reads by default**. Keep it
short (roughly 30-60 lines) and factual — a table of contents with
one-line summaries, an "open when" hint, and current status, not prose:

```markdown
# Project map

Stack: <one line — e.g. "Next.js 15 + TypeScript strict, no separate API">
Current phase: <phase N — name — status>

## Knowledge base
| File | What it covers | Open when |
|---|---|---|
| knowledge-base/architecture.md | folder layout, layering, stack choices | structure / layering change |
| knowledge-base/domain-model.md | entities & their relations | data-shape change |
| knowledge-base/api-reference.md | endpoints (if any) | endpoint / contract change |
| knowledge-base/features-index.md | every feature, status, key files | feature status / file map |
| knowledge-base/decisions.md | active non-obvious technical choices | architectural choice or conflict with a past one |
| knowledge-base/changelog.md | recent dated history | never by default — append only |

## Technical plan
| File | Status |
|---|---|
| technical-plan/phase-02-<slug>.md | in-progress |
<!-- done phases live under technical-plan/phase-archive/ — listed in 00-roadmap.md only -->

## Product
| File | What it covers | Open when |
|---|---|---|
| product/overview.md | vision, audience, success criteria | scope / audience change |
| product/design-brief.md | style direction, palette, locales | visual / i18n change |
| product/business-rules/BR-*.md | critical invariants (if folder exists) | auth / money / state / contract change |
```

A session should be able to decide, from `INDEX.md` alone, exactly which
one or two other files it needs to open for the task at hand — and open
nothing else. Treat the **Open when** column as a hard filter, not a hint.

## Rules

- **`technical-plan/` is written before code**, and each phase file must
  be self-contained enough that an AI agent opening *only that file* (no
  other context) can implement it: exact file paths to create/modify,
  which architecture layer each belongs to, the types/interfaces involved,
  and acceptance criteria. Update status in `00-roadmap.md` and
  `INDEX.md` as phases complete.
- **Archive completed phases.** When a phase flips to `done`, move its
  file into `technical-plan/phase-archive/` (create the folder if
  missing), keep a one-line pointer in `00-roadmap.md`, and remove it
  from the `INDEX.md` Technical plan table. INDEX lists only
  `todo` / `in-progress` phases — done phase bodies are for humans and
  rare audits, not default agent context.
- **`product/` changes when the product surface changes** — new feature,
  changed scope, changed design direction. Not on every commit.
  Create `product/business-rules/` only when there is at least one
  **critical** invariant (authz, money, multi-state, multi-client,
  migration). Slim `BR-XXX` files (`templates/business-rule.md`); simple
  apps keep invariants in feature docs + domain tests. See
  `regression-and-business-rules.md`.
- **`knowledge-base/` is the single source of truth for "how the site
  works today"** and must be updated in the same session as any of: a
  shipped feature, a changed API contract, a changed data model, or an
  architectural decision. Update it **surgically** — edit the relevant
  section, don't rewrite the whole file; this keeps both the diff and the
  next read cheap.
- **Paths and signatures only — never paste code blocks into docs.** Point
  at file paths, type/export names, and one-line shapes. The repo is the
  source of truth for implementations; duplicating code in markdown burns
  tokens on every re-read and rots immediately.
- **Split oversized knowledge-base files.** If `api-reference.md`,
  `domain-model.md`, or similar grows past roughly **200 lines**, split by
  domain/area (e.g. `api-reference-auth.md`), add each slice to `INDEX.md`
  with its own Open-when hint, and leave a one-line pointer in the
  original file. Prefer more small files over one fat file.
- **Keep `changelog.md` short.** Once it passes roughly 50 entries, move
  the oldest half into `changelog-archive.md` (create it if missing) and
  leave only recent history in `changelog.md`. Nobody needs to read
  changelog history to make today's change; the archive exists for
  humans, not for the agent's default context.
- **Keep `decisions.md` short and active-only.** Each entry is short-form
  ADR (see template): Context / Decision / Alternatives / Status, one line
  each. Move any decision marked `superseded` into
  `decisions-archive.md` immediately. If `decisions.md` still passes
  roughly **20–25 active entries**, move the oldest half that are no
  longer constraining today's work into the archive too. Do not open the
  archive unless auditing history.
- **`INDEX.md` is updated whenever the table of contents itself changes**
  — a new knowledge-base file, a new phase, a phase archived, a phase's
  status flipping, a feature shipping, a KB file split. If only a file's
  *internal content* changed but its one-line summary in `INDEX.md` is
  still accurate, leave `INDEX.md` alone.
