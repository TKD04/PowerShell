<#
.SYNOPSIS
Initializes a git repository in the current directory.

.PARAMETER UseNode
Specifies whether to add a gitignore file for Node.js projects.
#>
function Initialize-GitRepository {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param(
        [switch]$UseNode
    )

    if (-not (Test-CommandExists -Command 'git')) {
        throw 'The command "git" does not exist.'
    }
    if (Test-StrictPath -LiteralPath './.git' -PathType 'Container') {
        throw 'Git repository is already in place.'
    }

    [string]$templateFileName = $UseNode ? 'OS_Node.gitignore' : 'OS.gitignore'

    if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, 'Initialize Git repository')) {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates', $templateFileName |
        Copy-Item -Destination './.gitignore' -Force
        git init
        git add './.gitignore'
        git commit -m 'chore: initial commit'
    }
}

Set-Alias -Name 'ginit' -Value 'Initialize-GitRepository'
