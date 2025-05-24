<#
.SYNOPSIS
Adds ESLint and its settings to the current directory.
It installs the browser settings by default.

.PARAMETER UseNode
Whether to support the global varialbes in Node.

.PARAMETER IsViteReact
Whether to add the rules for React with Vite.

.PARAMETER IsNextJs
Whether to support a project created by Next.js
#>
function Install-MyESLint {
    [OutputType([void])]
    param (
        [switch]$UseNode,
        [switch]$IsViteReact,
        [switch]$IsNextJs
    )

    if ($UseNode -and ($IsViteReact -or $IsNextJs)) {
        throw '$UseNode cannot be used with $IsViteReact or $IsNextJs'
    }
    elseif ($IsViteReact -and $IsNextJs) {
        throw '$IsViteReact cannot be used with $IsNextJs'
    }
    [string]$eslintConfigSource = ''
    [string[]]$devDependencies = @(
        '@eslint/eslintrc'
        '@eslint/js'
        '@stylistic/eslint-plugin'
        '@typescript-eslint/eslint-plugin@^7'
        '@typescript-eslint/parser@^7'
        'eslint'
        'eslint-config-airbnb-typescript'
        'eslint-config-prettier'
        'eslint-import-resolver-typescript'
        'eslint-plugin-import'
        'eslint-plugin-jsdoc'
        'eslint-plugin-perfectionist'
        'eslint-plugin-regexp'
        'eslint-plugin-simple-import-sort'
        'eslint-plugin-unicorn'
        'eslint-plugin-vitest'
        'globals'
        'typescript-eslint'
    )

    <# No React #>
    if (!$IsViteReact -and !$IsNextJs) {
        $devDependencies += 'eslint-config-airbnb-base'
    }
    <# React #>
    if ($IsViteReact -or $IsNextJs) {
        $devDependencies += @(
            'eslint-config-airbnb'
            'eslint-plugin-jsx-a11y'
            'eslint-plugin-react'
            'eslint-plugin-react-compiler'
            'eslint-plugin-react-hooks'
            'eslint-plugin-react-refresh'
        )
    }
    <# Node.js #>
    if ($UseNode) {
        $eslintConfigSource = 'node\eslint.config.mjs'
    }
    <# Vite with React #>
    elseif ($IsViteReact) {
        $eslintConfigSource = 'browser\eslint-react.config.mjs'
        if (!(Test-MyStrictPath -LiteralPath '.\eslint.config.js')) {
            git rm '.\eslint.config.js'
        }
    }
    <# Next.js #>
    elseif ($IsNextJs) {
        [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
        [bool]$hasNpmScriptLint = $package.scripts.ContainsKey('lint')

        # Remove "lint" from npm scripts to replace "next lint" with "eslint . --cache"
        if ($hasNpmScriptLint) {
            Remove-MyNpmScript('lint')
            pnpm rm eslint-config-next
            git rm '.\eslint.config.mjs'
        }
        $devDependencies += '@next/eslint-plugin-next'
        $eslintConfigSource = 'browser\eslint-next.config.mjs'
    }
    <# No framework #>
    else {
        $eslintConfigSource = 'browser\eslint.config.mjs'
    }
    pnpm add -D @devDependencies
    Add-MyNpmScript -NameToScript @{
        'lint' = 'eslint . --cache'
    }
    Join-Path -Path $PSScriptRoot -ChildPath $eslintConfigSource |
    Copy-Item -Destination '.\eslint.config.mjs'
    git add '.\package.json' '.\pnpm-lock.yaml' '.\eslint.config.mjs'
    git commit -m 'Add ESLint'
}
