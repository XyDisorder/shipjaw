# Code standards: typing & quality rules

> Read once at scaffold time — this gets **compiled into
> `tsconfig.json`/`eslint.config.*`**, so future sessions enforce it via
> the type-checker/linter instead of re-reading this file.

## Typing rules

- `tsconfig.json`: `"strict": true`, `"noUncheckedIndexedAccess": true`,
  `"noImplicitOverride": true`, `"exactOptionalPropertyTypes": true` — turn
  a flag off only if it causes real friction with a specific library, and
  record that deviation in `knowledge-base/architecture.md`.
- ESLint: `@typescript-eslint/no-explicit-any: "error"`,
  `@typescript-eslint/no-unsafe-*: "error"`, disallow `as any` and
  `// @ts-ignore` (use `// @ts-expect-error` with a comment only as an
  absolute last resort, never to paper over a real typing gap).
- `unknown` is allowed **only** at the exact boundary where untyped data
  enters: `catch (e: unknown)`, `JSON.parse(...)`, a raw fetch/HTTP
  response body, a return value from an untyped third-party SDK. In every
  one of those cases, narrow it immediately (a zod `.parse`/`.safeParse`,
  or a hand-written type guard) into a concrete domain/contract type
  before it's used or returned. `unknown` must never appear in an exported
  function's parameter or return type, and must never be stored in
  state/DB.
- Validate at every boundary with **zod**: API request bodies, API
  responses (in the web app's data-fetching layer), form inputs,
  environment variables (parsed once at startup, e.g. `env.ts`).
- Prefer discriminated unions over optional-everything types for anything
  with real variants (e.g. request state:
  `{status: 'idle'} | {status: 'loading'} | {status: 'error', error: string} | {status: 'success', data: T}`).

## Code quality rules

- **Errors are typed, not generic.** Domain/application code throws or
  returns specific error types (a small `class NotFoundError extends
  DomainError` hierarchy, or a `Result<T, E>`/`Either`-style return),
  never a bare `throw new Error("...")` or a silently swallowed
  `catch {}`. Presentation **must** map known errors to UI/HTTP using the
  table in `project-structure.md` (Error → HTTP / UI mapping) — no naked
  generic 500 catch-alls that hide the cause.
- **Thin adapters.** Server Actions / Route Handlers only:
  validate → (authz) → use-case from `composition` → map error. No SQL,
  no domain rules, no direct infra imports in those files.
- **Ports + composition root.** Outside capabilities are interfaces under
  `application/ports/` (one file each). Wire concretes once in
  `server/composition.ts`. Presentation never new’s a repository.
- **No layer barrels.** Avoid `domain/index.ts` / `application/index.ts`
  re-export grab-bags; import concrete modules.
- **No magic literals.** A string/number repeated more than once, or one
  whose meaning isn't obvious at the call site (a role name, a status
  code, a limit), becomes a named constant or a union/enum in a
  **dedicated** `*.constants.ts` (or next to the owning domain module) —
  not a hardcoded literal sprinkled across actions/components. Placement
  → `project-structure.md` (Types, constants, helpers).
- **Types travel with their owner.** Domain shapes live under
  `server/domain/`; zod boundary schemas under `application/` (or
  `packages/contracts` when Nest monorepo). Do not redefine the same
  model as ad-hoc interfaces inside React files.
- **Helpers follow the dependency rule.** Pure business helpers →
  `domain/`; orchestration → `application/`; UI-only →
  `features/<f>/lib/`. Never a repo-wide `lib/utils.ts` / `helpers.ts`
  grab-bag. Extract when reused or when it clouds the host file.
- **Domain logic is pure.** Functions in `domain/` take inputs and return
  outputs with no hidden I/O, no `Date.now()`/`Math.random()` called
  directly inside business rules (inject a clock/id-generator port
  instead) — this is also what makes them trivially unit-testable.
- **Dependency injection over hidden singletons/globals.** Anything
  `application/` needs from the outside (a repository, a clock, an email
  sender) is passed in (constructor/param), never imported as a
  module-level singleton — again, this is a testability requirement as
  much as a design one. Construction happens in the composition root.
- **No `console.*` in committed code.** Use
  `templates/scaffold/src/lib/logger.ts` (or equivalent).
- **Server Components by default** in Next presentation; `'use client'`
  only at interactive leaves; never import secret `env` into client code.
- **No dead code.** Delete unused exports, commented-out blocks, and
  `// TODO` without a linked phase/issue — if it's worth doing later, it
  belongs in a `technical-plan/` phase, not a comment.
