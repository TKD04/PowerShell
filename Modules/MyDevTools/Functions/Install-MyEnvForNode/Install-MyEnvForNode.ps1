<#
.SYNOPSIS
Adds the Node develop environment to the current directory.

.PARAMETER UseVitest
Whether to use Vitest.

.PARAMETER AddWatch
Whether to add `watch` to npm scripts.
#>
function Install-MyEnvForNode {
    [OutputType([void])]
    param(
        [switch]$UseVitest,
        [switch]$AddWatch
    )

    Initialize-MyGit -UseNode
    Initialize-MyNpm
    Install-MyTypeScript -Environment 'Node'
    Install-MyESLint -Environment 'Node'
    if ($UseVitest) {
        Install-MyVitest
    }
    Install-MyPrettier
    if ($AddWatch) {
        Install-MyTSNode
        Install-MyNodemon
    }
    Install-MyTypeDoc
    Install-MyVSCodeSettingsForWeb
    if (-not (Test-MyStrictPath -LiteralPath '.\.gitignore')) {
        Join-Path -Path $PSScriptRoot -ChildPath 'common\Node.gitignore' |
        Copy-Item -Destination '.\.gitignore'
    }
    New-Item -Path '.\' -Name 'src' -ItemType 'Directory'
    New-Item -Path '.\src' -Name 'app.ts' -ItemType 'File'
    git add '.\package.json' '.\src\app.ts'
    git commit -m 'Add environment for Node'
    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
