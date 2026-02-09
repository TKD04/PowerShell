<#
.SYNOPSIS
Initializes git in the current directory.

.PARAMETER UseNode
Whether to adds .gitignore for Node.js.
#>
function Initialize-MyGit {
    [OutputType([System.Void])]
    param(
        [switch]$UseNode
    )

    if (Test-MyStrictPath -LiteralPath '.\.git' -PathType 'Container') {
        throw 'Git repository is already in place (abort).'
    }

    git init
    if ($UseNode) {
        Copy-MyScriptRootItem -ChildPath '\common\Node.gitignore' -Destination '.\.gitignore' -Force
    }
    elseif (-not (Test-MyStrictPath -LiteralPath '.\.gitignore' -PathType 'Leaf')) {
        Copy-MyScriptRootItem -ChildPath '\common\OS.gitignore' -Destination '.\.gitignore' -Force
    }
    else {
        Write-Warning -Message '.gitignore is already in place (skip).'
    }
    git add '.\.gitignore'
    git commit -m 'First commit'
}

Set-Alias -Name 'ginit' -Value 'Initialize-MyGit'
