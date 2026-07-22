import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/**
 * Gate only — not a substitute for application-layer authz.
 * Adapt `isAuthenticated` to the chosen auth provider (Auth.js/Clerk/…).
 * Protect route groups like /app, /dashboard — leave marketing public.
 */
const protectedPrefixes = ["/app", "/dashboard"];

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const needsAuth = protectedPrefixes.some(
    (prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`),
  );
  if (!needsAuth) {
    return NextResponse.next();
  }

  // Replace with real session lookup for the chosen provider.
  const isAuthenticated = Boolean(request.cookies.get("session")?.value);
  if (!isAuthenticated) {
    const login = new URL("/login", request.url);
    login.searchParams.set("next", pathname);
    return NextResponse.redirect(login);
  }
  return NextResponse.next();
}

export const config = {
  matcher: ["/app/:path*", "/dashboard/:path*"],
};
