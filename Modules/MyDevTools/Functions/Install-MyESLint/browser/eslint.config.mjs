import js from "@eslint/js";
import { defineConfig, globalIgnores } from "eslint/config";
import {
  configs as airbnbXConfigs,
  plugins as airbnbXPlugins,
  rules as airbnbXRules,
} from "eslint-config-airbnb-extended";
import eslintConfigPrettier from "eslint-config-prettier";
import { createTypeScriptImportResolver } from "eslint-import-resolver-typescript";
import { createNodeResolver } from "eslint-plugin-import-x";
import jsdocPlugin from "eslint-plugin-jsdoc";
import perfectionistPlugin from "eslint-plugin-perfectionist";
import regexpPlugin from "eslint-plugin-regexp";
import eslintPluginSimpleImportSort from "eslint-plugin-simple-import-sort";
import eslintPluginUnicorn from "eslint-plugin-unicorn";
import vitestPlugin from "eslint-plugin-vitest";
import globals from "globals";
import tseslint from "typescript-eslint";

export default defineConfig([
  globalIgnores(["dist/", "docs/", "public/", "coverage/"]),
  {
    extends: [
      js.configs.recommended,
      airbnbXPlugins.stylistic,
      airbnbXPlugins.importX,
      airbnbXPlugins.typescriptEslint,
      airbnbXConfigs.base.recommended,
      airbnbXConfigs.base.typescript,
      /*
       * Overrides the recommended Import and TypeScript-ESLint rules with
       * the stricter ones.
       */
      airbnbXRules.base.importsStrict,
      airbnbXRules.typescript.typescriptEslintStrict,
      eslintPluginUnicorn.configs.all,
      jsdocPlugin.configs["flat/recommended-typescript-error"],
      regexpPlugin.configs["flat/all"],
      perfectionistPlugin.configs["recommended-natural"],
    ],
    files: ["src/**/*.ts", "*.{js,mjs,cjs,ts}"],
    languageOptions: {
      globals: globals.browser,
      parserOptions: {
        /*
         * "projectService" is intentionally NOT specified here.
         * It is already enabled by "airbnbXConfigs.base.typescript" and is
         * preserved via deep-merge behavior in ESLint flat config.
         * https://github.com/eslint-config/airbnb-extended/blob/master/packages/eslint-config-airbnb-extended/rules/typescript/typescriptEslint.ts#L13
         */
        tsconfigRootDir: import.meta.dirname,
      },
    },
    name: "base",
    plugins: {
      jsdoc: jsdocPlugin,
      "simple-import-sort": eslintPluginSimpleImportSort,
    },
    rules: {
      /*
       * Disabled since Vite allows importing assets from the public folder
       * via root-relative paths.
       */
      "import-x/no-absolute-path": "off",
      // Disabled "import-x/order" in favor of "simple-import-sort/imports"
      "import-x/order": "off",
      /*
       * Re-enabled "ForOfStatement" (previously restricted by eslint-config-airbnb-extended)
       * in favor of "unicorn/no-array-for-each".
       * https://github.com/sindresorhus/eslint-plugin-unicorn/blob/v56.0.1/docs/rules/no-array-for-each.md
       * https://github.com/airbnb/javascript/issues/1271
       * https://github.com/airbnb/javascript/blob/0e2ef178a26ba9ac3495402a182891ad8096d3a0/packages/eslint-config-airbnb-base/rules/style.js#L340
       */
      "no-restricted-syntax": [
        "error",
        {
          message:
            "for..in loops iterate over the entire prototype chain, which is virtually never what you want. Use Object.{keys,values,entries}, and iterate over the resulting array.",
          selector: "ForInStatement",
        },
        {
          message:
            "Labels are a form of GOTO; using them makes code confusing and hard to maintain and understand.",
          selector: "LabeledStatement",
        },
        {
          message:
            "`with` is disallowed in strict mode because it makes code impossible to predict and optimize.",
          selector: "WithStatement",
        },
      ],
      // Disabled "perfectionist/sort-imports" in favor of "simple-import-sort/imports"
      "perfectionist/sort-imports": "off",
      "regexp/require-unicode-sets-regexp": "off",
      "simple-import-sort/exports": "error",
      "simple-import-sort/imports": "error",
      /*
       * Keep "unicorn/all" enabled and disable this unnecessary rule.
       * https://github.com/sindresorhus/eslint-plugin-unicorn/blob/bd0901b160e7cbef7a3e3140ea628fc41b8b215d/docs/rules/prefer-json-parse-buffer.md
       */
      "unicorn/prefer-json-parse-buffer": "off",
    },
    settings: {
      "import-x/resolver-next": [
        createTypeScriptImportResolver(),
        createNodeResolver(),
      ],
    },
  },
  {
    extends: [tseslint.configs.disableTypeChecked],
    files: ["*.{js,mjs,cjs}"],
    name: "js",
  },
  {
    extends: [vitestPlugin.configs.all],
    files: ["src/**/*.test.ts"],
    name: "test",
    settings: {
      vitest: {
        typecheck: true,
      },
    },
  },
  {
    extends: [eslintConfigPrettier],
    name: "prettier",
  },
]);
