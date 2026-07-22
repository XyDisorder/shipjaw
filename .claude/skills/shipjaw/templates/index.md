# Project map

Stack: <one line — e.g. "Next.js <major> + TypeScript strict, no separate API">
Current phase: <phase N — name — status>

## Knowledge base
| File | What it covers | Open when |
|---|---|---|
| knowledge-base/architecture.md | folder layout, layering, stack choices | structure / layering change |
| knowledge-base/domain-model.md | entities & their relations | data-shape change |
| knowledge-base/api-reference.md | endpoints (if any) | endpoint / contract change |
| knowledge-base/features-index.md | every feature, status, key files | feature status / file map |
| knowledge-base/decisions.md | active non-obvious technical choices (see decisions-archive.md) | architectural choice or conflict with a past one |
| knowledge-base/changelog.md | recent dated history (see changelog-archive.md) | never by default — append only |

## Technical plan
| File | Status |
|---|---|
| technical-plan/phase-01-<slug>.md | todo |
<!-- done phases → technical-plan/phase-archive/; keep pointers in 00-roadmap.md only -->

## Product
| File | What it covers | Open when |
|---|---|---|
| product/overview.md | vision, audience, success criteria | scope / audience change |
| product/design-brief.md | style direction, palette, locales | visual / i18n change |
<!-- add product/business-rules/BR-*.md rows only when that folder exists -->

<!--
Keep this file short (~30-60 lines). It is the only file a continuation
session (shipjaw-ask) reads by default — update it only when
the table of contents itself changes (new file, new/archived phase,
status flip, KB split), not when a file's internal content changes but
its summary is still true. Treat "Open when" as a hard filter.
-->
