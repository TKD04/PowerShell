<#
.SYNOPSIS
Initializes git in the current directory.

.PARAMETER UseNode
Whether to adds .gitignore for Node.js.

.PARAMETER UsePython
Whether to adds .gitignore for Python.
#>
function Initialize-MyGit {
    [Alias('ginit')]
    [OutputType([void])]
    param(
        [switch]$UseNode,
        [switch]$UsePython
    )

    if (Test-MyStrictPath -LiteralPath '.\.git') {
        throw 'Git repository is already in place (abort).'
    }

    git init @args
    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath '\common\Node.gitignore' |
        Copy-Item -Destination '.\.gitignore' -Force
    }
    elseif ($UsePython) {
        Join-Path -Path $PSScriptRoot -ChildPath '\common\Python.gitignore' |
        Copy-Item -Destination '.\.gitignore' -Force
    }
    elseif (!(Test-MyStrictPath -LiteralPath '.\.gitignore')) {
        New-Item -Path '.\' -Name '.gitignore' -ItemType 'file'
    }
    else {
        Write-Warning -Message '.gitignore is already in place (skip).'
    }
    git add '.\.gitignore'
    git commit -m 'First commit'
}
