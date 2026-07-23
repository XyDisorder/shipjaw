# Feature: List todos

**Status:** shipped
**Critical user-facing flow (needs e2e coverage)?** yes
**Touches auth/other users' data/an unauthenticated write endpoint (needs security.md rules)?** no

## Description
Shows the user every todo they've created so far.

## Journey (prefer this over a page list)
- **Trigger:** open the app
- **Steps:** app loads → list renders from the repository
- **Success:** every created todo is visible
- **Failure states:** no todos yet — empty state, no error

## User stories
- As a user, I want to see all my todos, so that I know what's left to do.

## Acceptance criteria (business-first)
- [x] User can see every todo they created, in the list
- [x] Out of scope for this feature stays out: sorting, filtering, search

## Edge cases
- Domain/application (unit): n/a — pure read of repository state
- Critical journey UI (e2e): empty list shows empty-state copy, not a blank page
