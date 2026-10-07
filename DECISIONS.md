# Decisions

Short-form ADR for this repo itself (Shipjaw the framework) — same shape
as the `decisions.md` template Shipjaw hands to every scaffolded app, one
level up: these are decisions about Shipjaw, not about an app built with
it. `CHANGELOG.md` has the full narrative for anything dated below; this
file is the scannable "what's currently decided and why," so a fresh
session (or a contributor per `CONTRIBUTING.md`) doesn't have to
reconstruct it from git history.

Mark `Status: superseded` and add one line saying what replaced it —
don't delete an entry once it's shipped.

## 2026-08-16 — Roadmap docs are a backlog, not a spec
**Context:** RFC 0001 (and every follow-on vision doc since — see the
2026-09-07 entry below) proposes a full architecture/positioning/roadmap
before Shipjaw had run on more than the golden fixture.
**Decision:** Triage any such doc against real dogfood evidence section by
section; implement only confirmed gaps. ~23 RFC 0001 sections checked:
13 already covered, 5 partial, 3 real gaps (closed), 5 explicitly parked
(open-source strategy, community governance, 3-year roadmap, a 12-module
architecture, "reference framework" positioning).
**Alternatives:** Execute the RFC top-down, section by section.
**Challenge:** n/a — process decision, not a coding choice.
**Status:** active

## 2026-08-16/17 — Dev-audience launch first, no hosted product for non-devs
**Context:** Considered whether a "prompt-in, site-out" hosted product for
non-technical users would be a stronger launch than a plain README +
dev-channel posts (Reddit/HN/X).
**Decision:** Assessed as a fundamentally different product (hosted
backend, Claude API cost absorbed by the operator, auth/billing,
generated-code hosting) — positions Shipjaw against v0/Bolt/Lovable/
Replit Agent, which it explicitly isn't. Parked; ship the dev-audience
launch first.
**Alternatives:** Build the hosted MVP now. If revisited, the cheapest
real test of demand is `shipjaw-prompt` alone as a web form (prompt out,
no code generation/hosting/billing) — not the full app-builder.
**Challenge:** n/a
**Status:** active — parked, not rejected. Revisit only on real
post-launch signal (stars, non-dev users asking for it), not on its own.

## 2026-08-17 — Disable the `Co-Authored-By: Claude` commit trailer
**Context:** Once the repo went public, the trailer showed Claude as a
second GitHub-recognized author on every commit.
**Decision:** `.claude/settings.json` sets `attribution.commit`/`pr` to
`""`. Applies to future commits only.
**Alternatives:** Rewrite git history to strip existing trailers —
rejected (would need a force-push on an already-public repo).
**Challenge:** n/a
**Status:** active

## 2026-09-07 — Split TypeScript/Next rules into a technology profile; stop at Phase 1
**Context:** A second roadmap doc ("agnostic product engineering")
proposed generalizing Shipjaw beyond TypeScript/Next via a 9-phase plan
(Discovery, a Documentation Resolver, a stack-agnostic Regression Engine,
etc.). All 4 real dogfooded projects at the time were TS/Next.
**Decision:** Execute only Phase 1: classify `shipjaw-build`'s reference
files into stack-agnostic Core vs. TS/Next/Nest-specific implementation,
move the latter into `profiles/typescript-next/` (see its own `README.md`).
Structural move, no prose rewrite.
**Alternatives:** Execute the full roadmap now — rejected: generalizing
Core from a single validated ecosystem (Next.js) is the same
premature-abstraction risk the roadmap's own Phase 9 flags for itself.
**Challenge:** n/a — structural move, zero behavior change.
**Status:** active — Phases 2+ (Discovery, Regression Engine) stay
un-started until a real second-ecosystem project exists to validate
Core against.

## 2026-09-07 — Documentation Resolver: kept as a real idea, gated on a real trigger
**Context:** Same roadmap as above proposed just-in-time retrieval of
official library docs so Shipjaw isn't limited to a model's cached API
knowledge. Separately, real motivation surfaced: wanting genuinely
"wow-effect" visual sites (e.g. Three.js/React-Three-Fiber), where a
model's built-in knowledge is likely to be stale.
**Decision:** Don't build the general resolver speculatively. Added Core
principle 19 (`skill-principles.md`) — check installed types/source
before trusting model memory — as the cheap, already-motivated 80%
version (backed by 3 real version-drift bugs already found this way in
the scaffold templates). Build the full resolver only against a real
project that needs it, scoped to that project.
**Alternatives:** Build a general-purpose JIT doc-fetch system now —
rejected: a different order of magnitude of infra effort than anything
else in this repo (real web-fetch + version-matching, not a skill-file
edit), unvalidated.
**Challenge:** n/a
**Status:** active — gated, not rejected.

## 2026-09-09 — Scale the built-in challenge ritual to actual stakes
**Context:** A purely decorative, reversible, single-user 3D addition to
a real dogfooded project (`tcg-collection`, no auth/persisted data/other
users) triggered the full 5-axis subagent challenge pass and a wall of
output before any code existed — `challenge-built-in.md`'s trigger list
("ADR or stack fork", "primary UI") fires on shape, not actual risk.
**Decision:** Two tiers in `challenge-built-in.md`: the full pass stays
mandatory for auth, money, persisted/shared data, multi-user/authz, an
irreversible action, or removing/contradicting an existing documented
decision; a one-paragraph self-check (biggest real risk + how it's
handled) covers single-user, purely additive, reversible,
presentation-only changes. Unsure which tier → full pass, by default.
**Alternatives:** Keep one uniform trigger list — rejected: disproportionate
process is itself a Shipjaw defect, not a safe default.
**Challenge:** n/a — process decision about the challenge mechanism itself.
**Status:** active

## 2026-10-07 — Prod-readiness checklist: on-demand and stakes-tiered, not a gate
**Context:** user brought back real conference feedback to triage.
Several points were already covered (progressive disclosure, `shipjaw-prompt`,
`DECISIONS.md`, the Sept 9 challenge-tiering fix independently corroborated
by an external talk). One real gap: no single place answered "is this app
actually ready" once a project moves past its first phase into real
deployed use, despite scattered pieces (`security.md`, `modern-extras.md`,
per-phase Acceptance criteria) — both real current projects
(`tcg-collection`, `mtg-deck-optimizer`) are already deployed.
**Decision:** added `profiles/typescript-next/prod-readiness.md`, three
stakes tiers (every deployed app / auth+data / real-users-or-money),
every item checkable without ambiguity. Opt-in on deploy/launch intent —
explicitly not part of the mandatory per-phase gate.
**Alternatives:** make it a mandatory gate step for every phase — rejected,
disproportionate for a solo personal tool, same reasoning as the
challenge-tiering fix; write Tier 3 (real users/money) content now —
rejected, not yet dogfooded on any real project, would be speculative.
**Challenge:** n/a — additive on-demand reference, no behavior change to
existing gates.
**Status:** active

## 2026-09-12 — "Agentic OS" idea parked
**Context:** A much larger, unrelated infra idea (an operating system /
environment layer designed for AI agents as first-class users) came up
while this repo's own public launch was still mid-flight (most launch
channels not yet posted) and `tcg-collection`'s pivot was still open.
**Decision:** Sequence, don't parallelize. Park the idea; revisit only
once Shipjaw's launch settles, or if real environment-friction signal
shows up unprompted in feedback/issues (stronger validation than this
session noticing its own git/PATH friction while working).
**Alternatives:** Start it now, in parallel with the launch — rejected as
attention dilution across too many open fronts at once.
**Challenge:** n/a
**Status:** active — parked.
