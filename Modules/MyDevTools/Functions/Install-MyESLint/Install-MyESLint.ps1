<#
.SYNOPSIS
Adds ESLint and its settings to the current directory.
It installs the browser settings by default.

.PARAMETER Environment
Specifies the target environment.
- Node
- Vite (this is same to the default browser settings)
- ViteReact
- Next
#>
function Install-MyESLint {
    [OutputType([void])]
    param (
        [ValidateSet('Node', 'Vite', 'ViteReact', 'Next')]
        [string]$Environment
    )

    [string]$eslintConfigSource = ''
    [string[]]$devDependencies = @(
        '@eslint/js'
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
        'eslint-plugin-vitest'
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
            $eslintConfigSource = 'node\eslint.config.mjs'
        }
        'ViteReact' {
            $eslintConfigSource = 'browser\eslint-vite-react.config.mjs'
            if (Test-MyStrictPath -LiteralPath '.\eslint.config.js' -PathType Leaf) {
                git rm '.\eslint.config.js'
            }
        }
        'Next' {
            [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
            [bool]$hasNpmScriptLint = $package.ContainsKey('scripts') `
                -and $package['scripts'].ContainsKey('lint')

            # Remove "lint" from npm scripts to replace "next lint" with "eslint . --cache"
            if ($hasNpmScriptLint) {
                Remove-MyNpmScript -ScriptName 'lint'
                pnpm rm eslint-config-next
                if (Test-MyStrictPath -LiteralPath '.\eslint.config.mjs' -PathType Leaf) {
                    git rm '.\eslint.config.mjs'
                }
            }
            $devDependencies += '@next/eslint-plugin-next'
            $eslintConfigSource = 'browser\eslint-next.config.mjs'
        }
        default {
            # Vite (Plain) or Browser
            $eslintConfigSource = 'browser\eslint.config.mjs'
        }
    }
    pnpm add -D @devDependencies
    Add-MyNpmScript -NameToScript @{
        'lint' = 'eslint . --cache'
    }
    Join-Path -Path $PSScriptRoot -ChildPath $eslintConfigSource |
    Copy-Item -Destination '.\eslint.config.mjs' -Force
    git add '.\package.json' '.\pnpm-lock.yaml' '.\eslint.config.mjs'
    git commit -m 'Add ESLint'
}
