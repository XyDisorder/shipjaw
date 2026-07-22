# Security guidelines

> Read once at scaffold time, alongside `project-structure.md` /
> `code-standards.md` / `testing-and-ci.md`. Most of this becomes config
> (headers, CI audit step) or a fixed pattern reused throughout
> implementation — not something to re-derive per feature.

## Secrets

- Never commit secrets. `.env*` (except `.env.example`) stays in
  `.gitignore` from the first commit. Commit `.env.example` with every
  required key present, values replaced by placeholders.
- Env vars are parsed once at startup through a zod schema
  (`templates/scaffold/src/env.ts`) — never scatter `process.env.X`;
  import the parsed, typed object instead.
- No secret ever appears in a log line, an error message returned to a
  client, or a committed fixture/test file.
- Never expose server env to the client: only explicitly prefixed public
  keys (e.g. `NEXT_PUBLIC_*`) may cross the boundary.

## Authentication & authorization

- Prefer a vetted auth provider (Auth.js, Clerk, Supabase Auth...) unless
  the prompt has a specific reason to roll custom auth. If custom: hash
  passwords with argon2id (bcrypt as a fallback), never store or log them
  in plaintext, never compare with `===`.
- Session cookies: `httpOnly`, `secure`, `sameSite: 'lax'` (or `'strict'`
  where it doesn't break the flow).
- **Authorization is enforced in `application/`, server-side, always** —
  a check that only exists in a React component or a hidden button is not
  a security control, it's UX. Every use-case that touches another user's
  data re-checks ownership/role itself.
- Put an auth **port** in `application/` and one adapter in
  `infrastructure/` (e.g. Auth.js). Presentation never talks to the
  provider SDK directly for authorization decisions.

## Server Actions & middleware (Next App Router)

- Every Server Action that mutates state **re-checks the session and
  authorization** inside the action (or the use-case it calls) — never
  trust that the UI only rendered for logged-in users.
- Prefer framework/session CSRF protections (Auth.js / SameSite cookies);
  for sensitive mutations, also verify `Origin`/`Host` when not using a
  battle-tested auth library's built-in checks.
- Use `middleware.ts` (see `templates/scaffold/middleware.ts`) to redirect
  unauthenticated users away from protected route groups — middleware is a
  gate, **not** a substitute for application-layer authz.
- Rate-limit unauthenticated write-capable actions the same as public
  route handlers.

## Input handling

- Boundary validation via zod (see `code-standards.md`). Never build SQL
  by concatenation; never interpolate user input into a shell command;
  never trust a client-supplied ID without an ownership/role check.
- User-generated HTML goes through a sanitizer before any
  `dangerouslySetInnerHTML` — default to not needing it; React escapes
  text.

## When applicable

- **Uploads:** allowlist MIME types + max size; store outside the repo
  (S3/Blob); never serve user uploads from a path that executes code.
- **Webhooks:** verify provider signatures (HMAC) before processing; make
  handlers idempotent.
- **CI e2e secrets:** use GitHub Actions secrets / env, never commit
  real credentials into Playwright fixtures.

## Transport & headers

Copy `templates/scaffold/next.config.ts` as the baseline. Minimum
headers: `X-Content-Type-Options: nosniff`,
`Referrer-Policy: strict-origin-when-cross-origin`,
`Strict-Transport-Security` (HTTPS), and a **starter CSP**:

```
default-src 'self';
base-uri 'self';
frame-ancestors 'none';
object-src 'none';
img-src 'self' data-blob:;
script-src 'self' 'unsafe-inline';
style-src 'self' 'unsafe-inline';
connect-src 'self';
```

Tighten `script-src` / add provider domains (auth, analytics, images)
once real third parties land — record deviations in
`knowledge-base/architecture.md`. NestJS: `helmet()` globally + explicit
CORS allowlist (never `origin: '*'` with `credentials: true`).

## Rate limiting

Apply only where there's attack surface — auth endpoints, public forms,
unauthenticated write-capable actions/handlers. NestJS:
`@nestjs/throttler`. Next: token-bucket backed by an existing store
(Redis/Upstash) — don't add a dependency solely for this if unused.

## Dependency hygiene

- CI runs a dependency audit (`templates/ci-workflow.yml`) — high/critical
  fails the build.
- Scaffold `.github/dependabot.yml` (`templates/dependabot.yml`).
