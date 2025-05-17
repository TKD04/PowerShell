<#
.SYNOPSIS
Adds ESLint and its settings to the current directory.
It installs the browser settings by default.

.PARAMETER UseNode
Whether to support the global varialbes in Node.

.PARAMETER UseViteReact
Whether to add the rules for React with Vite.

.PARAMETER IsNextJs
Whether to support a project created by Next.js
#>
function Install-MyESLint {
    [OutputType([void])]
    param (
        [switch]$UseNode,
        [switch]$UseViteReact,
        [switch]$IsNextJs
    )

    if ($UseNode -and ($UseViteReact -or $IsNextJs)) {
        throw '$UseNode cannot be used with $UseViteReact or $IsNextJs'
    }
    elseif ($UseViteReact -and $IsNextJs) {
        throw '$UseViteReact cannot be used with $IsNextJs'
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
        'eslint-plugin-jest'
        'eslint-plugin-jsdoc'
        'eslint-plugin-perfectionist'
        'eslint-plugin-regexp'
        'eslint-plugin-simple-import-sort'
        'eslint-plugin-unicorn'
        'globals'
        'typescript-eslint'
    )

    <# Browser #>
    if (!$UseNode) {
        $devDependencies += @(
            'eslint-plugin-jest-dom'
            'eslint-plugin-testing-library'
        )
    }
    <# Not React #>
    if (!$UseViteReact -and !$IsNextJs) {
        $devDependencies += 'eslint-config-airbnb-base'
    }
    <# React #>
    if ($UseViteReact -or $IsNextJs) {
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
    <# React with Vite #>
    elseif ($UseViteReact) {
        $eslintConfigSource = 'browser\eslint-react.config.mjs'
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
    <# Vanilla #>
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
    Write-MySuccess -Message 'Added ESLint, its configs, and its npm script "lint".'
}
