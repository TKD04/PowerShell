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
import reactHooksPlugin from "eslint-plugin-react-hooks";
import reactRefreshPlugin from "eslint-plugin-react-refresh";
import regexpPlugin from "eslint-plugin-regexp";
import eslintPluginSimpleImportSort from "eslint-plugin-simple-import-sort";
import eslintPluginUnicorn from "eslint-plugin-unicorn";
import vitestPlugin from "eslint-plugin-vitest";
import globals from "globals";
import tseslint from "typescript-eslint";

export default defineConfig([
  globalIgnores([
    "dist/",
    "docs/",
    "public/",
    "coverage/",
    "components/ui/",
    ".next/",
    "out/",
  ]),
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
      regexpPlugin.configs["flat/all"],
      perfectionistPlugin.configs["recommended-natural"],
    ],
    files: [
      "{app,components,features}/**/*.{ts,tsx}",
      "{constants,hooks,lib}/**/*.ts",
      "*.{js,mjs,cjs,ts}",
    ],
    ignores: ["next-env.d.ts", "lib/utils.ts"],
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
      "unicorn/prevent-abbreviations": [
        "error",
        {
          allowList: {
            params: true,
            Params: true,
            props: true,
            Props: true,
            ref: true,
            Ref: true,
          },
        },
      ],
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
    extends: [jsdocPlugin.configs["flat/recommended-typescript-error"]],
    files: [
      "{app,components,features}/**/*.ts",
      "{constants,hooks,lib}/**/*.ts",
    ],
    ignores: ["lib/utils.ts"],
    name: "jsdoc",
    plugins: {
      jsdoc: jsdocPlugin,
    },
  },
  {
    extends: [
      /*
       * Rules from eslint-plugin-react-compiler are now included in
       * eslint-plugin-react-hooks' recommended rules.
       * https://react.dev/blog/2025/10/07/react-compiler-1#migrating-from-eslint-plugin-react-compiler-to-eslint-plugin-react-hooks
       */
      reactHooksPlugin.configs.flat.recommended,
      airbnbXPlugins.react,
      airbnbXPlugins.reactHooks,
      airbnbXPlugins.reactA11y,
      airbnbXPlugins.next,
      /*
       * "jsx-runtime" configs from eslint-react-plugin are already included in
       * airbnbXConfigs.next.recommended.
       * https://github.com/eslint-config/airbnb-extended/blob/1b7d222c1f6ab866b84541f5e176e015547cbb71/packages/eslint-config-airbnb-extended/extensions/next/recommended.ts#L14
       */
      airbnbXConfigs.next.recommended,
      airbnbXConfigs.next.typescript,
      // Overrides the recommended React rules with the stricter ones.
      airbnbXRules.react.strict,
      reactRefreshPlugin.configs.next,
    ],
    files: ["{app,components,features}/**/*.tsx"],
    ignores: ["{app,components,features}/**/*.test.tsx}"],
    name: "react",
    rules: {
      // Disabled "react/jsx-sort-props" in favor of "perfectionist/sort-jsx-props"
      "react/jsx-sort-props": "off",
    },
  },
  {
    extends: [vitestPlugin.configs.all],
    files: [
      "{app,components,features}/**/*.test.{ts,tsx}",
      "{constants,hooks,lib}/**/*.test.ts",
    ],
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
