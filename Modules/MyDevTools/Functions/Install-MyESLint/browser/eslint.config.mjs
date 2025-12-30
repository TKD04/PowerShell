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
const rulesToBeRemovedFromAirbnbTypeScript = [
  /*
   * This extension rule is no longer needed because the base rule added support for numeric separators.
   * https://eslint.org/docs/latest/rules/no-loss-of-precision
   * https://typescript-eslint.io/rules/no-loss-of-precision/
   * https://github.com/airbnb/javascript/blob/0e2ef178a26ba9ac3495402a182891ad8096d3a0/packages/eslint-config-airbnb-base/rules/errors.js#L99
   * https://github.com/iamturns/eslint-config-airbnb-typescript/blob/a81480efa6b0e3f6dbaf4dbf6317142bc58fbb3a/lib/shared.js#L142
   */
  "no-loss-of-precision",
  "@typescript-eslint/no-loss-of-precision",
  /*
   * This rule was deprecated in ESLint v8.46.0. There is no replacement rule.
   * https://eslint.org/docs/latest/rules/no-return-await
   * https://github.com/iamturns/eslint-config-airbnb-typescript/blob/a81480efa6b0e3f6dbaf4dbf6317142bc58fbb3a/lib/shared.js#L217
   */
  "no-return-await",
];
/**
 * Replace the deprecated "@typescript-eslint@^7" rules with the latest ones in "eslint-config-airbnb-typescript"
 * https://gist.github.com/xfournet/ed9f2f02e411b86188bad4aeb9b1bddb
 */
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
    "no-extra-parens",
    "no-extra-semi",
    "space-before-blocks",
    "quotes",
    "semi",
    "space-before-function-paren",
    "space-infix-ops",
    "object-curly-spacing",
  ].map((rule) => [`@typescript-eslint/${rule}`, `@stylistic/${rule}`]),
]);
const fixupDeprecatedAirbnb = (configs) =>
  configs.map((config) => {
    if (config["rules"] === undefined) {
      return config;
    }

    /*
     * This rule was deprecated in ESLint v8.46.0. There is no replacement rule.
     * https://eslint.org/docs/latest/rules/no-return-await
     * https://github.com/airbnb/javascript/blob/0e2ef178a26ba9ac3495402a182891ad8096d3a0/packages/eslint-config-airbnb-base/rules/best-practices.js#L310
     */
    if (config.rules["no-return-await"] !== undefined) {
      // eslint-disable-next-line no-param-reassign
      delete config.rules["no-return-await"];
    }

    return config;
  });
const fixupDeprecatedAirbnbTypeScript = (configs) =>
  configs.map((config) => {
    if (config["languageOptions"] !== undefined) {
      // eslint-disable-next-line no-param-reassign
      delete config["languageOptions"];
    }
    if (config["plugins"] !== undefined) {
      // eslint-disable-next-line no-param-reassign
      delete config["plugins"];
    }
    if (config["rules"] === undefined) {
      return config;
    }

    for (const ruleToBeRemoved of rulesToBeRemovedFromAirbnbTypeScript) {
      if (config.rules[ruleToBeRemoved]) {
        // eslint-disable-next-line no-param-reassign, @typescript-eslint/no-dynamic-delete
        delete config.rules[ruleToBeRemoved];
      }
    }
    /*
     * This avoids setting the rule value to [undefined, "try-in-catch"].
     * "eslint-config-airbnb-typescript" plugin dynamically determines
     * rule values by importing "eslint-config-airbnb/base" plugin.
     * I removed the original "no-return-await" rule in the "fixupDeprecatedAirbnb"
     * function. This resulted in the rule value being set to [undefined, "try-in-catch"].
     * https://typescript-eslint.io/rules/return-await/
     * https://github.com/iamturns/eslint-config-airbnb-typescript/blob/a81480efa6b0e3f6dbaf4dbf6317142bc58fbb3a/lib/shared.js#L219
     */
    if (config.rules["@typescript-eslint/return-await"] !== undefined) {
      // eslint-disable-next-line no-param-reassign
      config.rules["@typescript-eslint/return-await"] = [
        "error",
        "in-try-catch",
      ];
    }
    for (const [legacyRule, latestRule] of legacyRulesToLatestOnes.entries()) {
      if (config.rules[legacyRule] !== undefined) {
        const ruleValue = config.rules[legacyRule];

        // eslint-disable-next-line no-param-reassign, @typescript-eslint/no-dynamic-delete
        delete config.rules[legacyRule];
        // eslint-disable-next-line no-param-reassign
        config.rules[latestRule] = ruleValue;
      }
    }

    return config;
  });

export default tseslint.config(
  {
    // https://eslint.org/docs/latest/use/configure/configuration-files#globally-ignoring-files-with-ignores
    ignores: ["dist/", "docs/", "public/", "coverage/"],
  },
  {
    extends: [
      fixupDeprecatedAirbnb(compat.extends("airbnb-base")),
      tseslint.configs.strictTypeChecked,
      tseslint.configs.stylisticTypeChecked,
      fixupDeprecatedAirbnbTypeScript(compat.extends("airbnb-typescript/base")),
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
        projectService: true,
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
      "regexp/require-unicode-sets-regexp": "off",
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
