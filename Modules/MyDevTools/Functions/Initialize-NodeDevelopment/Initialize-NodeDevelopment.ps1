<#
.SYNOPSIS
Sets up a Node.js development environment in the current directory.

.PARAMETER AddWatch
Specifies whether to add a "watch" npm script.
#>
function Initialize-NodeDevelopment {
    [OutputType([System.Void])]
    param(
        [switch]$AddWatch
    )

    Initialize-GitRepository -UseNode
    Initialize-NpmProject
    Install-TypeScript -Environment 'Node'
    Install-EsLint -Environment 'Node'
    Install-Vitest
    Install-Prettier
    if ($AddWatch) {
        Install-TsNode
        Install-Nodemon
    }
    Initialize-VsCodeSetting -Environment 'Frontend'
    $null = New-Item -Path './src/app.ts' -ItemType 'File' -Force
    git add './package.json' './src/app.ts'
    git commit -m 'Add environment for Node'
    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
