<#
.SYNOPSIS
Adds required packages to a Next.js project.
Uses the command "pnpm dlx create-next-app@latest --use-pnpm" to create the project first.
Otherwise, this function will throw an error.

.PARAMETER DeployToGitHubPages
Specifies whether to deploy the site using GitHub Pages.
#>
function Initialize-NextJsProject {
    [OutputType([System.Void])]
    param (
        [switch]$DeployToGitHubPages
    )

    if (-not (Test-GitClean)) {
        throw 'Git working tree or staging area contains uncommitted changes.'
    }

    [hashtable]$missingCompilerOptions = @{
        <# Type Checking #>
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
        <# Modules #>
        'noUncheckedSideEffectImports'       = $true
        <# Interop Constraints #>
        'erasableSyntaxOnly'                 = $true
        'forceConsistentCasingInFileNames'   = $true
        'verbatimModuleSyntax'               = $true
        <# Language and Environment #>
        'useDefineForClassFields'            = $true
        <# Projects #>
        'tsBuildInfoFile'                    = './node_modules/.tmp/tsconfig.tsbuildinfo'
    }
    [hashtable]$tsConfig = Import-Json -LiteralPath './tsconfig.json'

    if (-not (Test-StrictPath -LiteralPath './pnpm-lock.yaml' -PathType 'Leaf')) {
        throw 'The file "./pnpm-lock.yaml" was not found. Create the project using the command "pnpm dlx create-next-app@latest --use-pnpm".'
    }

    <# .gitignore #>
    # Replace the gitignore created by "create-next-app" with a custom gitignore
    # that combines rules for Windows, macOS, Linux, Node, and Next.js.
    Join-Path -Path $PSScriptRoot -ChildPath 'templates/OS_Node_Nextjs.gitignore' |
    Copy-Item -Destination './.gitignore' -Force
    git add './.gitignore'
    git commit -m 'Replace generated gitignore by Next.js with Node.gitignore from github/gitignore'

    <# globals.d.ts #>
    # Add globals.d.ts so layout.tsx can import "./global.css" without TypeScript errors.
    Join-Path -Path $PSScriptRoot -ChildPath 'templates/globals.d.ts' |
    Copy-Item -Destination './globals.d.ts' -Force
    git add './globals.d.ts'
    git commit -m 'Add `global.d.ts` to allow `layout.tsx` to import "./global.css"'

    <# tsconfig.json #>
    foreach ($key in $missingCompilerOptions.Keys) {
        $tsConfig['compilerOptions'][$key] = $missingCompilerOptions[$key]
    }
    Export-Json -LiteralPath './tsconfig.json' -Hashtable $tsConfig
    git add './tsconfig.json'
    git commit -m 'Make tsconfig.json more strict'

    Install-EsLint -Environment 'Next'
    Install-Vitest
    Install-Prettier -UseTailwindCss
    Initialize-VsCodeSetting -Environment 'Frontend'
    if ($DeployToGitHubPages) {
        [string]$workflowDirectory = './.github/workflows'
        [string]$workflowFileName = 'pnpm-nextjs.yml'
        [string]$workflowDestPath = Join-Path -Path $workflowDirectory -ChildPath $workflowFileName

        if (Test-Path -Path $workflowDestPath -PathType 'Leaf') {
            Write-Warning -Message 'The workflow file is already in place (skip).'
        }
        else {
            $null = New-Item -Path $workflowDirectory -ItemType 'Directory' -Force
            Join-Path -Path $PSScriptRoot -ChildPath "templates/$workflowFileName" |
            Copy-Item -Destination $workflowDestPath -Force
            git add $workflowDestPath
            git commit -m 'Add pnpm-nextjs.yml to deploy to GitHub Pages'
        }
    }

    Write-Host -Object '✅ Setup complete: Next.js project is now ready!' -ForegroundColor 'Green'
}
