<#
.SYNOPSIS
Adds ESLint and its settings to the current directory.
It installs the browser settings by default.

.PARAMETER UseNode
Whether to support the global varialbes in Node.

.PARAMETER UseReact
Whether to add the rules for React.

.PARAMETER IsNextJs
Whether to support a project created by Next.js
#>
function Install-MyESLint {
    [OutputType([void])]
    param (
        [switch]$UseNode,
        [switch]$UseReact,
        [switch]$IsNextJs
    )

    if ($UseNode -and ($UseReact -or $IsNextJs)) {
        throw '$UseNode cannot be used with $UseReact or $IsNextJs'
    }
    [string]$eslintConfigSource = ''
    [string[]]$devDependencies = @(
        '@eslint/eslintrc',
        '@eslint/js',
        '@typescript-eslint/eslint-plugin@^7'
        '@typescript-eslint/parser@^7'
        'eslint@^8'
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
            'eslint-plugin-tailwindcss'
            'eslint-plugin-testing-library'
        )
    }
    <# Not React #>
    if (!$UseReact -and !$IsNextJs) {
        $devDependencies += 'eslint-config-airbnb-base'
    }
    <# React #>
    if ($UseReact -or $IsNextJs) {
        $devDependencies += @(
            'babel-plugin-react-compiler@beta'
            'eslint-config-airbnb'
            'eslint-plugin-jsx-a11y'
            'eslint-plugin-react'
            'eslint-plugin-react-compiler@beta'
            'eslint-plugin-react-hooks'
            'eslint-plugin-react-refresh'
        )
    }

    <# Node.js #>
    if ($UseNode) {
        $eslintConfigSource = 'node\eslint.config.mjs'
    }
    <# Vanilla #>
    if (!$UseReact -and !$IsNextJs) {
        $devDependencies += 'eslint-config-airbnb-base'
        $eslintConfigSource = 'browser\eslint.config.mjs'
    }
    <# React #>
    if ($UseReact -and !$IsNextJs) {
        $eslintConfigSource = 'browser\eslint-react.config.mjs'
    }
    <# Next.js #>
    if ($IsNextJs) {
        [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable

        $devDependencies += '@next/eslint-plugin-next'
        $eslintConfigSource = 'browser\eslint-next.config.mjs'
        pnpm rm eslint-config-next
        git rm '.\.eslintrc.json'
        # Remove "lint" from npm scripts to replace "next lint" with "eslint ."
        $package.scripts.Remove('lint')
        Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
    }
    pnpm add -D @devDependencies
    Add-MyNpmScript -NameToScript @{
        'lint' = 'eslint .'
    }
    Copy-MyPSScriptRootItem -ChildPath $eslintConfigSource -Destination '.\eslint.config.mjs'

    git add '.\package.json' '.\pnpm-lock.yaml' '.\eslint.config.mjs'
    git commit -m 'Add ESLint'
}
