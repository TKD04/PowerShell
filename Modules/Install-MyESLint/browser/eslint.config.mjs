import { FlatCompat } from "@eslint/eslintrc";
import eslint from "@eslint/js";
import stylisticPlugin from "@stylistic/eslint-plugin";
import prettierConfig from "eslint-config-prettier";
import jsdocPlugin from "eslint-plugin-jsdoc";
import perfectionistPlugin from "eslint-plugin-perfectionist";
import regexpPlugin from "eslint-plugin-regexp";
import simpleImportSortPlugin from "eslint-plugin-simple-import-sort";
import unicornPlugin from "eslint-plugin-unicorn";
import vitestPlugin from "eslint-plugin-vitest";
import globals from "globals";
import tseslint from "typescript-eslint";

// https://eslint.org/docs/latest/use/configure/migration-guide#using-eslintrc-configs-in-flat-config
const compat = new FlatCompat({
  allConfig: eslint.configs.all,
  baseDirectory: import.meta.dirname,
  recommendedConfig: eslint.configs.recommended,
});
// Replace the deprecated "@typescript-eslint@^7" rules with the latest ones in "eslint-config-airbnb-typescript"
// https://gist.github.com/xfournet/ed9f2f02e411b86188bad4aeb9b1bddb
const legacyRulesToLatestOnes = new Map([
  [
    "@typescript-eslint/no-throw-literal",
    "@typescript-eslint/only-throw-error",
  ],
  ...[
    "brace-style",
    "comma-dangle",
    "comma-spacing",
    "func-call-spacing",
    "indent",
    "keyword-spacing",
    "lines-between-class-members",
    "no-extra-semi",
    "space-before-blocks",
    "quotes",
    "semi",
    "space-before-function-paren",
    "space-infix-ops",
    "object-curly-spacing",
  ].map((rule) => [`@typescript-eslint/${rule}`, `@stylistic/${rule}`]),
]);
const fixupDeprecatedTsEslintRules = (configs) =>
  configs.map((config) => {
    const copiedConfig = config;
    const hasRules = copiedConfig.rules !== undefined;

    delete copiedConfig.plugins;
    delete copiedConfig.parser;
    if (hasRules) {
      for (const [
        legacyRule,
        latestRule,
      ] of legacyRulesToLatestOnes.entries()) {
        const hasLegacyRule = copiedConfig.rules[legacyRule] !== undefined;
        const hasLatestRule = copiedConfig.rules[latestRule] !== undefined;

        if (hasLegacyRule) {
          const ruleValue = copiedConfig.rules[legacyRule];

          // eslint-disable-next-line @typescript-eslint/no-dynamic-delete
          delete copiedConfig.rules[legacyRule];
          if (!hasLatestRule) {
            copiedConfig.rules[latestRule] = ruleValue;
          }
        }
      }
    }

    return copiedConfig;
  });
const config = tseslint.config(
  {
    // https://eslint.org/docs/latest/use/configure/configuration-files#globally-ignoring-files-with-ignores
    ignores: ["dist/", "docs/", "public/"],
  },
  {
    extends: [
      compat.extends("airbnb-base"),
      tseslint.configs.strictTypeChecked,
      tseslint.configs.stylisticTypeChecked,
      fixupDeprecatedTsEslintRules(compat.extends("airbnb-typescript/base")),
      unicornPlugin.configs.all,
      jsdocPlugin.configs["flat/recommended-typescript-error"],
      regexpPlugin.configs["flat/all"],
      perfectionistPlugin.configs["recommended-natural"],
      prettierConfig,
    ],
    files: ["src/**/*.ts", "*.{js,mjs,cjs,ts}"],
    languageOptions: {
      globals: globals.browser,
      parserOptions: {
        project: "./tsconfig.json",
        tsconfigRootDir: import.meta.dirname,
      },
    },
    name: "base",
    plugins: {
      "@stylistic": stylisticPlugin,
      jsdoc: jsdocPlugin,
      "simple-import-sort": simpleImportSortPlugin,
    },
    rules: {
      // https://johnnyreilly.com/typescript-5-importsnotusedasvalues-error-eslint-consistent-type-imports
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/no-import-type-side-effects": "error",
      "import/consistent-type-specifier-style": ["error", "prefer-top-level"],
      "import/no-absolute-path": "off",
      "import/no-extraneous-dependencies": [
        "error",
        {
          devDependencies: [
            "src/**/*.test.ts",
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
      // Merge "node" in eslint-config-airbnb-typescript and "typescript"
      "import/resolver": {
        node: {
          extensions: [".mjs", ".js", ".json", ".ts", ".d.ts"],
        },
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
    extends: [vitestPlugin.configs.all],
    files: ["src/**/*.test.ts"],
    name: "test",
    settings: {
      vitest: {
        typecheck: true,
      },
    },
  }
);

export default config;
