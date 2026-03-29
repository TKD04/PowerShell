<#
.SYNOPSIS
Adds ESLint and its configuration to the current directory.

.PARAMETER Environment
Specifies the target environment:
- Node
- Vite (uses the browser configuration)
- ViteReact
- Next
#>
function Install-EsLint {
    [OutputType([System.Void])]
    param (
        [ValidateSet('Node', 'Vite', 'ViteReact', 'Next')]
        [string]$Environment
    )

    [string]$eslintConfigSource = ''
    [string[]]$devDependencies = @(
        '@eslint/js'
        '@vitest/eslint-plugin'
        # eslint-config-airbnb-extended@2.3.3 uses @^3
        '@stylistic/eslint-plugin@^3'
        'eslint'
        'eslint-config-airbnb-extended'
        'eslint-config-prettier'
        'eslint-import-resolver-typescript'
        'eslint-plugin-import-x'
        'eslint-plugin-jsdoc'
        'eslint-plugin-perfectionist'
        'eslint-plugin-regexp'
        'eslint-plugin-simple-import-sort'
        'eslint-plugin-unicorn'
        'globals'
        'typescript-eslint'
    )

    if ($Environment -cmatch 'React$|^Next$') {
        $devDependencies += @(
            'eslint-plugin-jsx-a11y'
            'eslint-plugin-react'
            'eslint-plugin-react-hooks'
            'eslint-plugin-react-refresh'
        )
    }
    switch ($Environment) {
        'Node' {
            $devDependencies += 'eslint-plugin-n'
            $eslintConfigSource = 'templates/eslint-node.config.mjs'
        }
        'Vite' {
            $eslintConfigSource = 'templates/eslint-browser-vite.config.mjs'
        }
        'ViteReact' {
            $eslintConfigSource = 'templates/eslint-browser-vite-react.config.mjs'
            if (Test-StrictPath -LiteralPath './eslint.config.js' -PathType 'Leaf') {
                git rm './eslint.config.js'
            }
        }
        'Next' {
            [hashtable]$package = Import-Json -LiteralPath './package.json'
            [bool]$hasNpmScriptLint = $package.ContainsKey('scripts') -and $package['scripts'].ContainsKey('lint')

            if ($hasNpmScriptLint) {
                pnpm rm eslint-config-next
            }
            $devDependencies += '@next/eslint-plugin-next'
            $eslintConfigSource = 'templates/eslint-browser-next.config.mjs'
        }
    }
    pnpm add -D @devDependencies
    Add-NpmScript -NameToScript @{
        'lint' = 'eslint . --cache'
    }
    Join-Path -Path $PSScriptRoot -ChildPath $eslintConfigSource |
    Copy-Item -Destination './eslint.config.mjs' -Force
    git add './package.json' './pnpm-lock.yaml' './eslint.config.mjs'
    git commit -m 'Add ESLint'
}
