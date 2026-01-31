<#
.SYNOPSIS
Adds the Node develop environment to the current directory.

.PARAMETER AddWatch
Whether to add `watch` to npm scripts.
#>
function Install-MyEnvForNode {
    [OutputType([void])]
    param(
        [switch]$AddWatch
    )

    Initialize-MyGit -UseNode
    Initialize-MyNpm
    Install-MyTypeScript -Environment 'Node'
    Install-MyESLint -Environment 'Node'
    Install-MyVitest
    Install-MyPrettier
    if ($AddWatch) {
        Install-MyTSNode
        Install-MyNodemon
    }
    Install-MyTypeDoc
    Install-MyVSCodeSettingsForWeb
    $null = New-Item -Path '.\src\app.ts' -ItemType 'File' -Force
    git add '.\package.json' '.\src\app.ts'
    git commit -m 'Add environment for Node'
    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
