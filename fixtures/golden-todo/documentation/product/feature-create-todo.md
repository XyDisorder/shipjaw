# Feature: Create todo

**Status:** shipped
**Critical user-facing flow (needs e2e coverage)?** yes
**Touches auth/other users' data/an unauthenticated write endpoint (needs security.md rules)?** no

## Description
Lets a user add a new todo with a title so it shows up in their list.

## Journey (prefer this over a page list)
- **Trigger:** open app, use the create form
- **Steps:** enter title → submit → list updates
- **Success:** new todo visible in the list
- **Failure states:** empty title — validation error, no todo created

## User stories
- As a user, I want to add a todo with a title, so that I can track it.

## Acceptance criteria (business-first)
- [x] User can create a todo with a title and see it in the list
- [x] Out of scope for this feature stays out: due dates, priorities, tags

## Edge cases
- Domain/application (unit): empty title rejected; whitespace-only title rejected
- Critical journey UI (e2e): empty title shows inline error, no todo added
