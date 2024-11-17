<#
.SYNOPSIS
Adds ESLint and its settings to the current directory.

.PARAMETER UseBrowser
Whether to support the global variables in browser.

.PARAMETER UseNode
Whether to support the global varialbes in Node.

.PARAMETER IsNextJs
Whether to support a project created by Next.js

.PARAMETER UseTypeScript
Whether to add the rules for TypeScript.

.PARAMETER UseReact
Whether to add the rules for React.

.PARAMETER UseJest
Whether to add the rules for Jest.
#>
function Install-MyESLint {
    [OutputType([void])]
    param (
        [switch]$UseBrower,
        [switch]$UseNode,
        [switch]$IsNextJs,
        [switch]$UseTypeScript,
        [switch]$UseReact,
        [switch]$UseJest
    )
    [string]$eslintrcPath = '.\.eslintrc.json'
    [hashtable]$eslintrc = @{
        root           = $true
        env            = @{
            es2021 = $true
        }
        parserOptions  = @{
            ecmaVersion = 'latest'
            sourceType  = 'module'
        }
        extends        = @()
        plugins        = @()
        ignorePatterns = @(
            '/dist/'
        )
        rules          = @{
            # https://stackoverflow.com/questions/44939304/eslint-should-be-listed-in-the-projects-dependencies-not-devdependencies
            'import/no-extraneous-dependencies' = @(
                'error'
                @{
                    'devDependencies' = @(
                        '**/*.test.*'
                        'gulpfile.*js'
                        '*.config.*js'
                        '*.config.ts'
                    )
                }
            )
        }
    }
    [string[]]$neededDevPackages = @(
        'eslint'
        'eslint-plugin-import'
        'eslint-plugin-tailwindcss'
        'eslint-config-prettier'
    )

    if ($UseBrower) {
        $eslintrc.env.Add('browser', $true)
    }
    if ($UseNode) {
        $eslintrc.env.Add('node', $true)
        # Since we can't omit the extension on the import statements in ESM.
        $eslintrc.rules.Add(
            'import/extensions', @(
                'error'
                'always'
            )
        )
    }
    if ($UseReact) {
        # https://www.npmjs.com/package/eslint-config-airbnb
        $neededDevPackages += @(
            'eslint-config-airbnb'
            'eslint-plugin-react'
            'eslint-plugin-react-hooks'
            'eslint-plugin-jsx-a11y'
            'eslint-plugin-react-compiler@beta'
            'babel-plugin-react-compiler@beta'
        )
        $eslintrc.extends += @(
            'airbnb'
            'airbnb/hooks'
        )
        $eslintrc.plugins += 'eslint-plugin-react-compiler'
    }
    else {
        # https://www.npmjs.com/package/eslint-config-airbnb-base
        $neededDevPackages += 'eslint-config-airbnb-base'
        $eslintrc.extends += 'airbnb-base'
    }
    if ($UseTypeScript) {
        # https://www.npmjs.com/package/eslint-config-airbnb-typescript
        # https://typescript-eslint.io/linting/typed-linting/
        # https://typescriptbook.jp/tutorials/eslint#typescript-eslint%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E4%BD%9C%E3%82%8B
        $neededDevPackages += @(
            'eslint-config-airbnb-typescript'
            '@typescript-eslint/eslint-plugin'
            '@typescript-eslint/parser'
        )
        $eslintrc.Add('parser', '@typescript-eslint/parser')
        $eslintrc.parserOptions.Add('project', './tsconfig.eslint.json')
        $eslintrc.parserOptions.Add('tsconfigRootDir', './')
        $eslintrc.plugins += '@typescript-eslint'
        if ($UseReact) {
            $eslintrc.extends += 'airbnb-typescript'
            $eslintrc.rules.Add('react/react-in-jsx-scope', 'off')
            $eslintrc.rules.Add('react-compiler/react-compiler', 'error')
        }
        else {
            $eslintrc.extends += 'airbnb-typescript/base'
        }
        $eslintrc.extends += 'plugin:@typescript-eslint/recommended-requiring-type-checking'
        # Use ESLint rules instead of `verbatimModuleSyntax`, as it still has some compatibility issues.
        # https://zenn.dev/teppeis/articles/2023-04-typescript-5_0-verbatim-module-syntax#verbatimmodulesyntax%E3%81%A8-cjs-%E3%81%AE%E7%9B%B8%E6%80%A7%E3%81%8C%E6%82%AA%E3%81%84
        # https://johnnyreilly.com/typescript-5-importsnotusedasvalues-error-eslint-consistent-type-imports
        $eslintrc.rules.Add('@typescript-eslint/consistent-type-imports', 'error')
        $eslintrc.rules.Add('@typescript-eslint/no-import-type-side-effects', 'error')
        $eslintrc.rules.Add('import/consistent-type-specifier-style', @(
                'error'
                'prefer-top-level'
            )
        )
        <# Create tsconfig.eslint.json to avoid the error below. #>
        # https://typescript-eslint.io/linting/troubleshooting/#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file
        [string]$tsconfigEslintPath = '.\tsconfig.eslint.json'
        [hashtable]$tsconfigEslint = [ordered]@{
            extends         = './tsconfig'
            include         = @(
                'src',
                '*.*js',
                '*.ts'
            )
            compilerOptions = @{
                noEmit = $true
            }
        }
        if ($IsNextJs) {
            $tsconfigEslint = [ordered]@{
                extends         = './tsconfig'
                include         = @(
                    'next-env.d.ts',
                    '*.*js',
                    '**/*.ts',
                    '**/*.tsx',
                    '.next/types/**/*.ts'
                )
                compilerOptions = @{
                    noEmit = $true
                }
            }
            # To fix error importing "nextConfig.mjs"
            $eslintrc.rules.Add('import/extensions', 'off')
            # To fix error importing non ts files like images
            $eslintrc.rules.Add('import/order', 'off')
        }
        Export-MyJSON -LiteralPath $tsconfigEslintPath -CustomObject $tsconfigEslint
        git add $tsconfigEslintPath
    }
    if ($UseJest) {
        # https://www.npmjs.com/package/eslint-plugin-jest
        # https://github.com/jest-community/eslint-plugin-jest#running-rules-only-on-test-related-files
        $neededDevPackages += 'eslint-plugin-jest'
        [hashtable]$eslintOverridesJest = [ordered]@{
            env     = @{
                jest = $true
            }
            plugins = @('jest')
            extends = 'plugin:jest/all'
            files   = @('*.test.js')
        }
        if ($UseTypeScript) {
            $eslintOverridesJest.files = @('*.test.ts')
        }
        $eslintrc.Add('overrides', @($eslintOverridesJest))
    }
    $eslintrc.extends += @(
        'plugin:tailwindcss/recommended'
        'prettier'
    )
    pnpm add -D @neededDevPackages
    Export-MyJSON -LiteralPath $eslintrcPath -CustomObject $eslintrc
    Add-MyNpmScript -NameToScript @{
        'lint' = 'eslint .'
    }

    git add '.\.eslintrc.json' '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add ESLint'
}
