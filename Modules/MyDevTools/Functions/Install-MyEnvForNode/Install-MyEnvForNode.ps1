<#
.SYNOPSIS
Sets up a Node.js development environment in the current directory.

.PARAMETER AddWatch
Specifies whether to add a "watch" npm script.
#>
function Install-MyEnvForNode {
    [OutputType([System.Void])]
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
    $null = New-Item -Path './src/app.ts' -ItemType 'File' -Force
    git add './package.json' './src/app.ts'
    git commit -m 'Add environment for Node'
    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
