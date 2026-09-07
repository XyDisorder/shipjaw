// Copy to eslint.config.mjs. Requires:
// eslint, @eslint/js, typescript-eslint, eslint-config-next (or equivalent)
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommendedTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        projectService: {
          // This file itself (and any plain-JS config like postcss.config.mjs)
          // isn't in tsconfig's `include` — let type-checked rules lint it
          // without a real project instead of erroring on every run.
          allowDefaultProject: ["eslint.config.mjs"],
        },
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      "@typescript-eslint/no-explicit-any": "error",
      "@typescript-eslint/no-unsafe-assignment": "error",
      "@typescript-eslint/no-unsafe-call": "error",
      "@typescript-eslint/no-unsafe-member-access": "error",
      "@typescript-eslint/no-unsafe-return": "error",
      "@typescript-eslint/ban-ts-comment": [
        "error",
        { "ts-expect-error": "allow-with-description", "ts-ignore": true },
      ],
      "no-console": "error",
    },
  },
  { ignores: [".next/**", "dist/**", "coverage/**", "playwright-report/**"] },
);
