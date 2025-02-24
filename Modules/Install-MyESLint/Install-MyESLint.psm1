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

    if (($UseNode -and $UseReact) -or ($UseNode -and $IsNextJs)) {
        throw '$UseNode cannot be used with $UseReact or $IsNextJs'
    }
    [string]$eslintConfigDest = '.\eslint.config.mjs'
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

    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath 'node\eslint.config.mjs' |
        Copy-Item -Destination $eslintConfigDest
    }
    else {
        $devDependencies += @(
            'eslint-plugin-jest-dom'
            'eslint-plugin-tailwindcss'
            'eslint-plugin-testing-library'
        )
        if ($UseReact) {
            $devDependencies += @(
                'babel-plugin-react-compiler@beta'
                'eslint-config-airbnb'
                'eslint-plugin-jsx-a11y'
                'eslint-plugin-react'
                'eslint-plugin-react-compiler@beta'
                'eslint-plugin-react-hooks'
                'eslint-plugin-react-refresh'
            )
            if ($IsNextJs) {
                # Make configs more strict and add support for FlatConfig
                $devDependencies += '@next/eslint-plugin-next'
                # Remove "lint" from npm scripts to replace "next lint" with "eslint ."
                [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
                $package.scripts.Remove('lint')
                Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
                # Remove unused existing .eslintrc.json
                git rm '.\.eslintrc.json'
                # Remove unused "esilnt-config-next"
                pnpm rm eslint-config-next
                Join-Path -Path $PSScriptRoot -ChildPath 'browser\eslint-next.config.mjs' |
                Copy-Item -Destination $eslintConfigDest
            }
            else {
                Join-Path -Path $PSScriptRoot -ChildPath 'browser\eslint-react.config.mjs' |
                Copy-Item -Destination $eslintConfigDest
            }
        }
        else {
            $devDependencies += 'eslint-config-airbnb-base'
            Join-Path -Path $PSScriptRoot -ChildPath 'browser\eslint.config.mjs' |
            Copy-Item -Destination $eslintConfigDest
        }
    }
    pnpm add -D @devDependencies
    Add-MyNpmScript -NameToScript @{
        'lint' = 'eslint .'
    }

    git add '.\package.json' '.\pnpm-lock.yaml' $eslintConfigDest
    git commit -m 'Add ESLint'
}
