<#
.SYNOPSIS
Adds some required packages to a Next.js project.
You should use the command "npx create-next-app@latest --use-pnpm" to create the project.
Otherwise this function will throw an error.

.PARAMETER DeployToGitHubPages
Whether to use GitHub Pages to publish a site.
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

    if (!(Test-MyStrictPath -LiteralPath '.\pnpm-lock.yaml')) {
        throw 'You should use the command "npx create-next-app@latest --use-pnpm" to create the project.'
    }

    <# .gitignore #>
    # Replace generated .gitignore by Next.js with Node.gitignore from github/gitignore
    # https://github.com/github/gitignore
    git rm '.\.gitignore'
    Join-Path -Path $PSScriptRoot -ChildPath 'common\Node.gitignore' |
    Copy-Item -Destination '.\.gitignore' -Force
    git add '.\.gitignore'
    git commit -m 'Replace generated .gitignore by Next.js with Node.gitignore from github/gitignore'

    <# .npmrc #>
    # Add .npmrc for pnpm to be more compatible with npm
    # https://eslint.org/docs/latest/use/getting-started#manual-set-up
    Join-Path -Path $PSScriptRoot -ChildPath 'common\.npmrc' |
    Copy-Item -Destination '.\.npmrc'
    git add '.\.npmrc'
    git commit -m 'Add .npmrc for pnpm to be more compatible with npm'

    <# globals.d.ts #>
    # Add globals.d.ts to fix error when importing like *.css files
    # https://www.typescriptlang.org/tsconfig/#noUncheckedSideEffectImports
    if (!(Test-MyStrictPath -LiteralPath '.\types')) {
        New-Item -Path '.\' -Name 'types' -ItemType 'Directory'
    }
    Join-Path -Path $PSScriptRoot -ChildPath 'common\globals.d.ts' |
    Copy-Item -Destination '.\types\globals.d.ts'
    git add '.\types\globals.d.ts'
    git commit -m 'Add globals.d.ts to fix error when importing like *.css files'

    <# tscofnig.json #>
    # Make tsconfig.json more strict
    foreach ($kv in $missingCompilerOptions.GetEnumerator()) {
        <# $kv is the current item #>
        $tsConfig.compilerOptions[$kv.Key] = $kv.Value
    }
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add '.\tsconfig.json'
    git commit -m 'Make tsconfig.json more strict'

    Install-MyESLint -IsNextJs
    Install-MyVitest
    Install-MyPrettier -UseTailwindcss
    Install-MyVSCodeSettingsForWeb

    <# pnpm-nextjs.yml #>
    # Add nextjs.yml to deploy to GitHub Pages
    if ($DeployToGitHubPages) {
        if (Test-MyStrictPath -LiteralPath '.\.github\workflows\nextjs.yml') {
            Write-Warning -Message '.\.github\workflows\nextjs.yml is already in place (skip).'
        }
        else {
            if (!(Test-MyStrictPath -LiteralPath '.\.github')) {
                New-Item -Path '.\' -Name '.github' -ItemType 'directory'
            }
            if (!(Test-MyStrictPath -LiteralPath '.\.github\workflows')) {
                New-Item -Path '.\.github' -Name 'workflows' -ItemType 'directory'
            }
            Join-Path -Path $PSScriptRoot -ChildPath 'common\pnpm-nextjs.yml' |
            Copy-Item -Destination '.\.github\workflows\pnpm-nextjs.yml'
            git add '.\.github\workflows\pnpm-nextjs.yml'
            git commit -m 'Add pnpm-nextjs.yml to deploy to GitHub Pages'
        }
    }

    Write-Host -Object '✅ Setup complete: Next.js project is now ready!' -ForegroundColor Green
}
