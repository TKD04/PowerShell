<#
.SYNOPSIS
Adds some needed packages to a Next.js project.

.PARAMETER DeployToGitHubPages
Whether to use GitHub Pages to publish a site
#>
function Add-MyPackagesToNextJs {
    [OutputType([void])]
    param (
        [switch]$DeployToGitHubPages
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
        'noUncheckedSideEffectImports'       = $true
        'forceConsistentCasingInFileNames'   = $true
        'verbatimModuleSyntax'               = $true
    }
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable

    # Add .\.npmrc for pnpm
    # https://eslint.org/docs/latest/use/getting-started#manual-set-up
    Join-Path -Path $PSScriptRoot -ChildPath 'common\.npmrc' |
    Copy-Item -Destination '.\.npmrc'
    # Make .\tsconfig.json more strict
    $missingCompilerOptions.GetEnumerator() | ForEach-Object {
        $tsConfig.compilerOptions.Add($_.Key, $_.Value)
    }
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add '.\tsconfig.json'
    git commit -m 'Make tsconfig.json more strict'
    Install-MyESLint -IsNextJs
    Install-MyJest -UseReact
    # Replace `<rootDir>/src` with `<rootDir>` in roots for Jest to work properly in Next.js
    Join-Path -Path $PSScriptRoot -ChildPath 'common\jest-nextjs.config.cjs' |
    Copy-Item -Destination '.\jest.config.cjs' -Force
    git add '.\jest.config.cjs'
    git commit -m 'Change `roots` from "<rootDir>/src" to "<rootDir>"'
    Install-MyPrettier -UseTailwindcss
    Install-MyVSCodeSettingsForWeb
    # Add nextjs.yml to deploy to GitHub Pages
    if ($DeployToGitHubPages) {
        if (Test-MyStrictPath('.\.github\workflows\nextjs.yml')) {
            Write-Warning -Message '.\.github\workflows\nextjs.yml is already in place.'
        }
        else {
            New-Item -Path '.\' -Name '.github' -ItemType 'directory'
            New-Item -Path '.\.github' -Name 'workflows' -ItemType 'directory'
            Join-Path -Path $PSScriptRoot -ChildPath 'common\nextjs.yml' |
            Copy-Item -Destination '.\.github\workflows'
        }
    }
    Write-MySuccess -Message 'Added the needed packages and configs to the Next.js project.'
}
