import { z } from "zod";

/**
 * Parse once at startup. Import `env` everywhere instead of process.env.
 * Add keys as the project needs them; keep .env.example in sync.
 */
const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  // DATABASE_URL: z.string().url().optional(),
  // AUTH_SECRET: z.string().min(32).optional(),
});

export const env = envSchema.parse(process.env);
export type Env = z.infer<typeof envSchema>;
