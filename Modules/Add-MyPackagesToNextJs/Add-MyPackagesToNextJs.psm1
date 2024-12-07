<#
.SYNOPSIS
Adds some needed packages to a Next.js project.

.PARAMETER DeployToGitHubPages
Whether to use GitHub Pages to publish a site

.PARAMETER UseDaisyUi
Whether to support daisyUI
#>
function Add-MyPackagesToNextJs {
    [OutputType([void])]
    param (
        [switch]$DeployToGitHubPages,
        [switch]$UseDaisyUi
    )

    [hashtable]$missingCompilerOptions = @{
        'allowUnreachableCode'               = $false
        'allowUnusedLabels'                  = $false
        'exactOptionalPropertyTypes'         = $true
        'noFallthroughCasesInSwitch'         = $true
        'noImplicitOverride'                 = $true
        'noImplicitReturns'                  = $true
        'noPropertyAccessFromIndexSignature' = $true
        'noUncheckedIndexedAccess'           = $true
        'noUnusedLocals'                     = $true
        'noUnusedParameters'                 = $true
        'forceConsistentCasingInFileNames'   = $true
    }

    <# TypeScript #>
    # Make tsconfig more strict
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable
    $missingCompilerOptions.GetEnumerator() | ForEach-Object {
        $tsConfig.compilerOptions.Add($_.Key, $_.Value)
    }
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add '.\tsconfig.json'
    git commit -m 'Make tsconfig more strict'

    <# ESLint #>
    # Make eslint config more strict
    Install-MyESLint -UseReact -IsNextJs

    <# Jest #>
    Install-MyJest -UseReact
    # Replace `<rootDir>/src` with `<rootDir>` in roots to work properly in Next.js
    Join-Path -Path $PSScriptRoot -ChildPath 'common\jest-nextjs.config.cjs' |
    Copy-Item -Destination '.\jest.config.cjs' -Force
    git add '.\jest.config.cjs'
    git commit -m 'Change `roots` from "<rootDir>/src" to "<rootDir>"'

    <# Prettier #>
    Install-MyPrettier -UseTailwindcss

    <# Tailwind CSS #>
    Install-MyTailwindCss -IsNextJs -UseDaisyUi:$UseDaisyUi
    Install-MyVSCodeSettingsForWeb

    <# Add next.yml to deploy to GitHub Pages #>
    if ($DeployToGitHubPages) {
        if (Test-MyStrictPath('.\.github\workflows\next.yml')) {
            throw 'next.yml is already in place.'
        }

        New-Item -Path '.\' -Name '.github' -ItemType 'directory'
        New-Item -Path '.\.github' -Name 'workflows' -ItemType 'directory'
        Join-Path -Path $PSScriptRoot -ChildPath 'common\next.yml' |
        Copy-Item -Destination '.\.github\workflows'
    }
}
