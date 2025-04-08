import nodePath from "node:path";
import { fileURLToPath } from "node:url";

import { FlatCompat } from "@eslint/eslintrc";
import eslint from "@eslint/js";
import prettierConfig from "eslint-config-prettier";
import importPlugin from "eslint-plugin-import";
import jestPlugin from "eslint-plugin-jest";
import jestDomPlugin from "eslint-plugin-jest-dom";
import jsdocPlugin from "eslint-plugin-jsdoc";
import jsxA11yPlugin from "eslint-plugin-jsx-a11y";
import perfectionistPlugin from "eslint-plugin-perfectionist";
import reactPlugin from "eslint-plugin-react";
import reactCompilerPlugin from "eslint-plugin-react-compiler";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import reactRefreshPlugin from "eslint-plugin-react-refresh";
import regexpPlugin from "eslint-plugin-regexp";
import simpleImportSortPlugin from "eslint-plugin-simple-import-sort";
import tailwindPlugin from "eslint-plugin-tailwindcss";
import testingLibraryPlugin from "eslint-plugin-testing-library";
import unicornPlugin from "eslint-plugin-unicorn";
import globals from "globals";
import tseslint from "typescript-eslint";

// https://eslint.org/docs/latest/use/configure/migration-guide#using-eslintrc-configs-in-flat-config
const fileName = fileURLToPath(import.meta.url);
const directoryName = nodePath.dirname(fileName);
const compat = new FlatCompat({
  allConfig: eslint.configs.all,
  baseDirectory: directoryName,
  recommendedConfig: eslint.configs.recommended,
});

export default tseslint.config(
  eslint.configs.recommended,
  compat.extends("airbnb", "airbnb/hooks"),
  {
    // To avoid the error `"Key "plugins": Cannot redefine plugin "@typescript-eslint"`
    rules: {
      ...compat.extends("airbnb-typescript").rules,
    },
  },
  tseslint.configs.strictTypeChecked,
  tseslint.configs.stylisticTypeChecked,
  unicornPlugin.configs.all,
  perfectionistPlugin.configs["recommended-natural"],
  regexpPlugin.configs["flat/recommended"],
  jsdocPlugin.configs["flat/recommended-typescript-error"],
  {
    // To avoid the error `Key "plugins": Cannot redefine plugin "import"`
    rules: {
      ...importPlugin.flatConfigs.recommended.rules,
    },
  },
  tailwindPlugin.configs["flat/recommended"],
  {
    // https://eslint.org/docs/latest/use/configure/configuration-files#globally-ignoring-files-with-ignores
    ignores: ["dist/", "docs/", "public/"],
  },
  {
    files: ["**/*.{js,mjs,cjs,jsx,ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    name: "common",
    plugins: {
      jsdoc: jsdocPlugin,
      "simple-import-sort": simpleImportSortPlugin,
    },
    rules: {
      // https://johnnyreilly.com/typescript-5-importsnotusedasvalues-error-eslint-consistent-type-imports
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/no-import-type-side-effects": "error",
      "import/consistent-type-specifier-style": ["error", "prefer-top-level"],
      "import/no-extraneous-dependencies": [
        "error",
        {
          devDependencies: [
            "src/**/*.{test,spec}.{ts,tsx}",
            "*.config.{js,mjs,cjs,ts}",
            "gulpfile.{js,mjs,cjs}",
          ],
        },
      ],
      // Remove "ForOfStatement" from eslint-config-airnbnb to avoid conflict with "unicorn/no-array-for-each"
      // https://github.com/sindresorhus/eslint-plugin-unicorn/blob/v56.0.1/docs/rules/no-array-for-each.md
      // https://github.com/airbnb/javascript/issues/1271
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
      // Disable perfectionist/sort-imports to avoid conflicts with eslint-plugin-simple-import-sort
      "perfectionist/sort-imports": "off",
      "simple-import-sort/exports": "error",
      "simple-import-sort/imports": "error",
    },
    settings: {
      "import/resolver": {
        node: true,
        typescript: true,
      },
    },
  },
  {
    extends: [tseslint.configs.disableTypeChecked],
    files: ["*.{js,mjs,cjs}"],
    name: "js",
  },
  {
    extends: [
      reactPlugin.configs.flat.recommended,
      reactPlugin.configs.flat["jsx-runtime"],
      reactHooksPlugin.configs.recommended,
      reactRefreshPlugin.configs.vite,
      jsxA11yPlugin.flatConfigs.strict,
    ],
    files: ["src/**/*.tsx"],
    name: "react",
    plugins: {
      "react-compiler": reactCompilerPlugin,
    },
    rules: {
      "react-compiler/react-compiler": "error",
    },
    settings: {
      react: {
        version: "detect",
      },
    },
  },
  {
    extends: [
      jestPlugin.configs["flat/all"],
      jestDomPlugin.configs["flat/all"],
      testingLibraryPlugin.configs["flat/react"],
    ],
    files: ["src/**/*.{test,spec}.{ts,tsx}"],
    languageOptions: {
      globals: globals.jest,
    },
    name: "jest",
    plugins: {
      jest: jestPlugin,
    },
  },
  prettierConfig
);
