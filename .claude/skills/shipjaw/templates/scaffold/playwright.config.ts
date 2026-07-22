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
  workers: process.env.CI ? 1 : undefined,
  reporter: "list",
  use: {
    baseURL,
    trace: "on-first-retry",
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
  webServer: {
    command: process.env.CI
      ? `pnpm start -- --port ${e2ePort}`
      : `pnpm dev -- --port ${e2ePort}`,
    url: baseURL,
    // Locally reuse; in CI never attach to a random process on the port.
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
