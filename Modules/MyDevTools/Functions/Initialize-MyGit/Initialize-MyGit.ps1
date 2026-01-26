<#
.SYNOPSIS
Initializes git in the current directory.

.PARAMETER UseNode
Whether to adds .gitignore for Node.js.
#>
function Initialize-MyGit {
    [OutputType([void])]
    param(
        [switch]$UseNode
    )

    if (Test-MyStrictPath -LiteralPath '.\.git' -PathType Container) {
        throw 'Git repository is already in place (abort).'
    }

    git init @args
    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath '\common\Node.gitignore' |
        Copy-Item -Destination '.\.gitignore' -Force
    }
    elseif (-not (Test-MyStrictPath -LiteralPath '.\.gitignore' -PathType Leaf)) {
        $null = New-Item -Path '.\.gitignore' -ItemType 'File'
    }
    else {
        Write-Warning -Message '.gitignore is already in place (skip).'
    }
    git add '.\.gitignore'
    git commit -m 'First commit'
}

Set-Alias -Name 'ginit' -Value 'Initialize-MyGit'
