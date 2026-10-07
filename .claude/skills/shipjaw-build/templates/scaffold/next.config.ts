import type { NextConfig } from "next";
import path from "node:path";
import { fileURLToPath } from "node:url";

/** Pin tracing/turbopack to this app when a parent lockfile exists. */
const configDir = path.dirname(fileURLToPath(import.meta.url));

// Turbopack/React dev tooling calls eval() for HMR and stack-trace
// reconstruction — a strict `script-src` with no 'unsafe-eval' throws a
// blocking console error in the browser in dev mode (never needed, and
// never added, in production).
const scriptSrc = process.env.NODE_ENV === "development"
  ? "script-src 'self' 'unsafe-inline' 'unsafe-eval'"
  : "script-src 'self' 'unsafe-inline'";

const securityHeaders = [
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  { key: "X-Frame-Options", value: "DENY" },
  {
    key: "Permissions-Policy",
    value: "camera=(), microphone=(), geolocation=()",
  },
  {
    key: "Content-Security-Policy",
    value: [
      "default-src 'self'",
      "base-uri 'self'",
      "frame-ancestors 'none'",
      "object-src 'none'",
      "img-src 'self' data: blob:",
      scriptSrc,
      "style-src 'self' 'unsafe-inline'",
      "connect-src 'self'",
    ].join("; "),
  },
  // Enable HSTS only when the site is always served over HTTPS:
  // { key: "Strict-Transport-Security", value: "max-age=63072000; includeSubDomains; preload" },
];

const nextConfig: NextConfig = {
  poweredByHeader: false,
  outputFileTracingRoot: configDir,
  // Playwright's dedicated e2e port (playwright.config.ts) hits the dev
  // server over 127.0.0.1; Next blocks cross-origin dev resources (HMR,
  // client chunks) from an origin not in this list by default.
  allowedDevOrigins: ["127.0.0.1", "localhost"],
  turbopack: {
    root: configDir,
  },
  headers() {
    return [{ source: "/:path*", headers: securityHeaders }];
  },
};

export default nextConfig;
