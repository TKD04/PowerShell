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
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable

    # Make .\tsconfig.json more strict
    $missingCompilerOptions.GetEnumerator() | ForEach-Object {
        $tsConfig.compilerOptions.Add($_.Key, $_.Value)
    }
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add '.\tsconfig.json'
    git commit -m 'Make .\tsconfig.json more strict'
    Install-MyESLint -IsNextJs
    Install-MyJest -UseReact
    # Replace `<rootDir>/src` with `<rootDir>` in roots for Jest to work properly in Next.js
    Join-Path -Path $PSScriptRoot -ChildPath 'common\jest-nextjs.config.cjs' |
    Copy-Item -Destination '.\jest.config.cjs' -Force
    git add '.\jest.config.cjs'
    git commit -m 'Change `roots` from "<rootDir>/src" to "<rootDir>"'
    Install-MyPrettier -UseTailwindcss
    Install-MyTailwindCss -IsNextJs -UseDaisyUi:$UseDaisyUi
    Install-MyVSCodeSettingsForWeb
    # Add next.yml to deploy to GitHub Pages
    if ($DeployToGitHubPages) {
        if (Test-MyStrictPath('.\.github\workflows\next.yml')) {
            Write-Warning -Message '.\.github\workflows\next.yml is already in place.'
        }
        else {
            New-Item -Path '.\' -Name '.github' -ItemType 'directory'
            New-Item -Path '.\.github' -Name 'workflows' -ItemType 'directory'
            Join-Path -Path $PSScriptRoot -ChildPath 'common\next.yml' |
            Copy-Item -Destination '.\.github\workflows'
        }
    }
    Write-MySuccess -Message 'Added the needed packages and configs to the Next.js project.'
}
