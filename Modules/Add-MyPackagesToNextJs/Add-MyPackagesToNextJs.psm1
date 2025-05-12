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

    # Replace generated .gitignore by Next.js with Node.gitignore from github/gitignore
    # https://github.com/github/gitignore
    git rm '.\.gitignore'
    Join-Path -Path $PSScriptRoot -ChildPath 'common\Node.gitignore' |
    Copy-Item -Destination '.\.gitignore'
    git add '.\.gitignore'
    git commit -m 'Replace generated .gitignore by Next.js with Node.gitignore from github/gitignore'
    Write-MySuccess -Message 'Replace generated .gitignore by Next.js with Node.gitignore from github/gitignore'
    # Add .\.npmrc for pnpm
    # https://eslint.org/docs/latest/use/getting-started#manual-set-up
    Join-Path -Path $PSScriptRoot -ChildPath 'common\.npmrc' |
    Copy-Item -Destination '.\.npmrc'
    git add '.\.npmrc'
    git commit -m 'Add .npmrc for pnpm to work properly'
    # Add globals.d.ts to fix error when importing like *.css files
    # https://www.typescriptlang.org/tsconfig/#noUncheckedSideEffectImports
    if (!(Test-MyStrictPath -LiteralPath '.\lib')) {
        New-Item -Path '.\' -Name 'lib' -ItemType 'Directory'
    }
    New-Item -Path '.\lib' -Name 'types' -ItemType 'Directory'
    Join-Path -Path $PSScriptRoot -ChildPath 'common\globals.d.ts' |
    Copy-Item -Destination '.\lib\types\globals.d.ts'
    git add '.\lib\types\globals.d.ts'
    git commit -m 'Add globals.d.ts to fix error when importing like *.css files'
    Write-MySuccess -Message 'Added globals.d.ts to fix error when importing like *.css files'
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
            Copy-Item -Destination '.\.github\workflows\nextjs.yml'
            git add '.\.github\workflows\nextjs.yml'
            git commit -m 'Add nextjs.yml to deploy to GtiHub Pages'
            Write-MySuccess -Message 'Add nextjs.yml to deploy to GtiHub Pages'
        }
    }
    Write-MySuccess -Message 'Added the needed packages and configs to the Next.js project.'
}
