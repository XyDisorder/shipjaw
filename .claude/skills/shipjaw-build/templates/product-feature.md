# Feature: <Name>

**Status:** planned | in-progress | shipped
**Critical user-facing flow (needs e2e coverage)?** yes | no
**Touches auth/other users' data/an unauthenticated write endpoint (needs security.md rules)?** yes | no

## Description
<What it does, in plain language — product outcome, not tech.>

## Journey (prefer this over a page list)
- **Trigger:** <how the user starts>
- **Steps:** <1 → 2 → 3>
- **Success:** <observable result>
- **Failure states:** empty · error · unauthorized — <expected behavior each>

## User stories
- As a <role>, I want <action>, so that <benefit>.

## Acceptance criteria (business-first)
- [ ] <User can … — checkable without opening DevTools>
- [ ] Out of scope for this feature stays out: <…>

## Edge cases
- Domain/application (unit): <validation · not-found · authz · boundary · …>
- Critical journey UI (e2e): <empty · form error · unauthorized · not-found · n/a>
<!-- Map to testing-and-ci.md tables; avoid duplicating the same case in both. -->
