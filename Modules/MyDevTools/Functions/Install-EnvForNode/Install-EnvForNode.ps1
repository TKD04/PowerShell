<#
.SYNOPSIS
Sets up a Node.js development environment in the current directory.

.PARAMETER AddWatch
Specifies whether to add a "watch" npm script.
#>
function Install-EnvForNode {
    [OutputType([System.Void])]
    param(
        [switch]$AddWatch
    )

    Initialize-Git -UseNode
    Initialize-Npm
    Install-TypeScript -Environment 'Node'
    Install-ESLint -Environment 'Node'
    Install-Vitest
    Install-Prettier
    if ($AddWatch) {
        Install-TSNode
        Install-Nodemon
    }
    Install-TypeDoc
    Install-VSCodeSettingsForWeb
    $null = New-Item -Path './src/app.ts' -ItemType 'File' -Force
    git add './package.json' './src/app.ts'
    git commit -m 'Add environment for Node'
    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
