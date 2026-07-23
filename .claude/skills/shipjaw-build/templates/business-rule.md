# BR-<XXX> — <short name>

**Status:** draft | active | superseded
**Feature / area:** `product/feature-<slug>.md` (if any)
**Owner layer:** domain | application
**Tests:** `path/to/file.test.ts` · (e2e if critical) `path/to/flow.spec.ts`

## Purpose
<One or two sentences: why this rule exists.>

## Invariant
<The non-negotiable statement — framework-agnostic.>

## Actors / triggers
- Actors: <who or what>
- Triggers: <when it applies>

## Preconditions
- <must be true before the rule applies>

## Permitted
- <allowed outcomes / transitions>

## Forbidden
- <must never happen>

## Expected errors
- <domain/application error or result type — path/name only>

## Notes (only if needed)
- Concurrency: <one line or "n/a">
- Authorization: <one line or "n/a">
- Side effects: <one line or "none before primary success">
- State transitions: <link or "n/a">

<!--
Keep this file short. Do not paste code. Do not restate UI/DB details.
Expand Notes only for auth, money, multi-state, multi-client, or migrations.
-->
