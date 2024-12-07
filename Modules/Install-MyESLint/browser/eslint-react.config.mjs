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
import perfectionitstPlugin from "eslint-plugin-perfectionist";
import reactPlugin from "eslint-plugin-react";
import reactCompiler from "eslint-plugin-react-compiler";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import reactRefreshPlugin from "eslint-plugin-react-refresh";
import regexpPlugin from "eslint-plugin-regexp";
import simpleImportSortPlugin from "eslint-plugin-simple-import-sort";
import tailwindPlugin from "eslint-plugin-tailwindcss";
import testingLibraryPlugin from "eslint-plugin-testing-library";
import unicornPlugin from "eslint-plugin-unicorn";
import globals from "globals";
import tseslint from "typescript-eslint";

const { dirname } = nodePath;

const fileName = fileURLToPath(import.meta.url);
const directoryName = dirname(fileName);
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
  unicornPlugin.configs["flat/recommended"],
  perfectionitstPlugin.configs["recommended-natural"],
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
    ignores: ["**/dist/", "**/build/", "**/doc/"],
    name: "global ignores",
  },
  {
    files: ["**/*.{js,mjs,cjs,jsx,ts,tsx}"],
    languageOptions: {
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
      // Use ESLint rules instead of `verbatimModuleSyntax`, as it still has some compatibility issues.
      // https://zenn.dev/teppeis/articles/2023-04-typescript-5_0-verbatim-module-syntax#verbatimmodulesyntax%E3%81%A8-cjs-%E3%81%AE%E7%9B%B8%E6%80%A7%E3%81%8C%E6%82%AA%E3%81%84
      // https://johnnyreilly.com/typescript-5-importsnotusedasvalues-error-eslint-consistent-type-imports
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/no-import-type-side-effects": "error",
      "import/consistent-type-specifier-style": ["error", "prefer-top-level"],
      // Since we can't omit the extension on the import statements in ESM.
      // https://stackoverflow.com/questions/44939304/eslint-should-be-listed-in-the-projects-dependencies-not-devdependencies
      "import/no-extraneous-dependencies": [
        "error",
        {
          devDependencies: [
            "**/*.test.ts",
            "**/*.config.{js,mjs,cjs,ts}",
            "**/gulpfile.{js,mjs,cjs}",
          ],
        },
      ],
      // Disable perfectionist/sort-imports to avoid conflicts with eslint-plugin-simple-import-sort
      "perfectionist/sort-imports": "off",
      "simple-import-sort/exports": "error",
      "simple-import-sort/imports": "error",
    },
    settings: {
      // Require eslint-import-resolver-typescript
      "import/resolver": {
        node: true,
        typescript: true,
      },
    },
  },
  {
    // https://typescript-eslint.io/getting-started/typed-linting/#how-can-i-disable-type-aware-linting-for-a-subset-of-files
    extends: [tseslint.configs.disableTypeChecked],
    files: ["**/*.{js,mjs,cjs}"],
    name: "js",
  },
  {
    extends: [
      reactPlugin.configs.recommended,
      reactHooksPlugin.configs.recommended,
      reactRefreshPlugin.configs.recommended,
      jsxA11yPlugin.configs.strict,
    ],
    files: ["**/*.{js,ts}x"],
    languageOptions: {
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    name: "react",
    plugins: {
      "react-compiler": reactCompiler,
    },
    rules: {
      "react-compiler/react-compiler": "error",
      "react-refresh/only-export-components": [
        "warn",
        { allowConstantExport: true },
      ],
      "react/react-in-jsx-scope": "off",
    },
  },
  {
    extends: [
      jestPlugin.configs["flat/all"],
      jestDomPlugin.configs["flat/all"],
      testingLibraryPlugin.configs["flat/react"],
    ],
    files: ["**/*.spec.{js,mjs,cjs,ts}", "**/*.test.{js,mjs,cjs,ts}"],
    languageOptions: {
      globals: globals.jest,
    },
    name: "jest",
    plugins: {
      jest: jestPlugin,
    },
  },
  {
    files: ["**/*.config.{js,mjs,cjs,ts}"],
    languageOptions: {
      parserOptions: {
        project: "./tsconfig.eslint.json",
      },
    },
    name: "config files",
  },
  prettierConfig
);