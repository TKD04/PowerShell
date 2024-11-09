﻿<#
.SYNOPSIS
Adds some needed packages to a Vite

.PARAMETER UseDaisyUi
Whether to support daisyUI
#>
function Add-MyPackagesToVite {
    [OutputType([void])]
    param (
        [switch]$UseDaisyUi
    )

    [hashtable]$missingCompilerOptions = [ordered]@{
        <# Vite Default Settings #>
        'useDefineForClassFields'    = $true
        'allowImportingTsExtensions' = $true
    }

    # Install npm packages according to package.json generated by Vite
    npm i
    <# Git #>
    Initialize-MyGit
    git add .
    git commit -m 'Add all the files generated by Vite'
    <# npm-check-updates #>
    Install-MyNpmCheckUpdates
    <# TypeScript #>
    # Make tsconfig more strict
    git rm '.\tsconfig.json'
    Install-MyTypeScript -UseReact -NoEmit
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable
    # Add Vite default settings
    $missingCompilerOptions.GetEnumerator() | ForEach-Object {
        $tsConfig.compilerOptions.Add($_.Key, $_.Value)
    }
    $tsConfig.compilerOptions.target = 'es2020'
    $tsConfig.compilerOptions.module = 'esnext'
    $tsConfig.compilerOptions.moduleResolution = 'bundler'
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add './tsconfig.json'
    git commit -m 'Make tsconfig more strict'
    <# ESLint #>
    # Use old version ESLint (v8) instead of new one (v9) which installed by Vite
    # because many packages which I use didn't support new one so far (2024-09-30)
    npm rm @esilnt/js eslint globals typescript-eslint eslint-plugin-react-hooks
    git rm '.\eslint.config.js'
    # Make eslintrc more strict
    Install-MyESLint -UseBrower -UseTypeScript -UseReact -UseJest
    [hashtable]$eslintrc = Import-MyJSON -LiteralPath '.\.eslintrc.json' -AsHashTable
    # Add Vite default settings
    $eslintrc.env.Remove('es2021')
    $eslintrc.env.Add('es2020', $true)
    $eslintrc.plugins += 'react-refresh'
    $eslintrc.rules.Add('react-refresh/only-export-components', @(
            'warn', @{
                allowConstantExport = $true
            }
        ))
    # Vite uses absolute path ('/') to access public directory
    $eslintrc.rules.Add('import/no-absolute-path', 'off')
    Export-MyJSON -LiteralPath '.\.eslintrc.json' -CustomObject $eslintrc
    git add '.\.eslintrc.json'
    git commit -m 'Make eslintrc more strict'
    <# Jest #>
    Install-MyJest -UseBrowser -UseReact
    <# Prettier #>
    Install-MyPrettier -UseTailwindcss
    <# Tailwind CSS #>
    Install-MyTailwindCss -IsVite -UseDaisyUi:$UseDaisyUi
    Install-MyVSCodeSettingsForWeb
    <# Rename .js .cjs for config files to work in type: module #>
    Rename-MyFileExtension -OldExtension 'js' -NewExtension 'cjs' -UseGitMv
    git commit -m 'Rename .js .cjs for config files to work in `type: module`'
    <# Add `--open` to `dev` and `preview` npm scirpts #>
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    $package.scripts.Remove('dev')
    $package.scripts.Remove('preview')
    $package.scripts.Add('dev', 'vite --open')
    $package.scripts.Add('preview', 'vite preview --open')
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
    git add '.\package.json'
    git commit -m 'Add `--open` to `dev` and `preview` npm scirpt'
    <# Format all files by Prettier #>
    npm run format
    git add .
    git commit -m 'Format all the files by Prettier'
}