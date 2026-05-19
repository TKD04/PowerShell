<#
.SYNOPSIS
Adds required packages to a Vite project.
Ensures that "pnpm" is installed on your system beforehand, for example by running "corepack enable pnpm".
Otherwise, this function will throw an error.

.PARAMETER UseReact
Specifies whether to set up React support.

.PARAMETER DeployToGitHubPages
Specifies whether to deploy the site using GitHub Page.
#>
function Initialize-ViteProject {
    [OutputType([System.Void])]
    param (
        [switch]$UseReact,
        [switch]$DeployToGitHubPages
    )

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }
    # Ensure "TypeScript + React Compiler (Rolldown)" is selected for React projects.
    if ($UseReact) {
        [hashtable]$package = Import-Json -LiteralPath './package.json'
        [bool]$hasBabelPluginReactCompiler = $package.ContainsKey('devDependencies') -and $package['devDependencies'].ContainsKey('babel-plugin-react-compiler')

        if (-not $hasBabelPluginReactCompiler) {
            throw 'The package "babel-plugin-react-compiler" was not found. Select "TypeScript + React Compiler (Rolldown)" in "Select a variant" when initializing Vite.'
        }
    }

    Initialize-GitRepository -UseNode
    corepack use pnpm@latest
    pnpm install
    # Add the "@/ -> ./src" alias and Tailwind @import to the Vite config and CSS.
    if ($UseReact) {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/vite-react.config.ts' |
        Copy-Item -Destination './vite.config.ts' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/vite-react-index.css' |
        Copy-Item -Destination './src/index.css' -Force
        git add './package.json' './pnpm-lock.yaml' './vite.config.ts' './src/index.css'
    }
    else {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/vite.config.mjs' |
        Copy-Item -Destination './vite.config.mjs' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/vite-style.css' |
        Copy-Item -Destination './src/style.css' -Force
        git add './vite.config.mjs' './src/style.css'
    }
    Install-TypeScript -Environment ($UseReact ? 'ViteReact' : 'Vite')
    Install-EsLint -Environment ($UseReact ? 'ViteReact' : 'Vite')
    Install-Vitest
    Install-Prettier -UseTailwindCss
    Install-TailwindCss -IsVite
    Initialize-VsCodeSetting -Environment 'Frontend'
    Add-NpmScript -NameToScript @{
        'dev'     = 'vite --open'
        'preview' = 'vite preview --open'
    }
    if ($DeployToGitHubPages) {
        [string]$workflowDirectory = './.github/workflows'
        [string]$workflowFileName = 'pnpm-vite.yml'
        [string]$workflowDestPath = Join-Path -Path $workflowDirectory -ChildPath $workflowFileName

        if (Test-Path -Path $workflowDestPath -PathType 'Leaf') {
            Write-Warning -Message 'The workflow file is already in place (skip).'
        }
        else {
            $null = New-Item -Path $workflowDirectory -ItemType 'Directory' -Force
            Join-Path -Path $PSScriptRoot -ChildPath "templates/$workflowFileName" |
            Copy-Item -Destination $workflowDestPath -Force
        }
    }

    git add .
    git commit -m 'chore(scaffold): Vite project setup'

    Write-Host -Object '✅ Setup complete: Vite project is now ready!' -ForegroundColor 'Green'
}
