import { defineConfig, devices } from "@playwright/test";

/** Dedicated port so a stray `next dev` on :3000 does not break e2e/CI. */
const e2ePort = process.env.PLAYWRIGHT_PORT ?? "3005";
const baseURL =
  process.env.PLAYWRIGHT_BASE_URL ?? `http://127.0.0.1:${e2ePort}`;

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  // exactOptionalPropertyTypes forbids `workers: undefined` — omit the key
  // entirely locally instead of assigning undefined to it.
  ...(process.env.CI ? { workers: 1 } : {}),
  reporter: "list",
  use: {
    baseURL,
    trace: "on-first-retry",
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
  webServer: {
    // `pnpm exec next ...` directly — `pnpm <script> -- --port N` double
    // dashes can make a framework CLI treat --port as a positional arg
    // instead of a flag (seen with Next 16's dev/start CLI).
    command: process.env.CI
      ? `pnpm exec next start --port ${e2ePort}`
      : `pnpm exec next dev --port ${e2ePort}`,
    url: baseURL,
    // Locally reuse; in CI never attach to a random process on the port.
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
