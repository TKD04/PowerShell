<#
.SYNOPSIS
Initializes a git repository in the current directory.

.PARAMETER UseNode
Specifies whether to add a .gitignore file for Node.js projects.
#>
function Initialize-GitRepository {
    [OutputType([System.Void])]
    param(
        [switch]$UseNode
    )

    if (Test-StrictPath -LiteralPath './.git' -PathType 'Container') {
        throw 'Git repository is already in place.'
    }

    git init
    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/OS_Node.gitignore' |
        Copy-Item -Destination './.gitignore' -Force
    }
    elseif (-not (Test-StrictPath -LiteralPath './.gitignore' -PathType 'Leaf')) {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/OS.gitignore' |
        Copy-Item -Destination './.gitignore' -Force
    }
    else {
        Write-Warning -Message '.gitignore is already in place (skip).'
    }
    git add './.gitignore'
    git commit -m 'First commit'
}

Set-Alias -Name 'ginit' -Value 'Initialize-GitRepository'
