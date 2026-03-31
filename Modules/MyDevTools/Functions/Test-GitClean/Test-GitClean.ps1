<#
.SYNOPSIS
Tests whether Git working tree and staging area are clean.
#>
function Test-GitClean {
    [OutputType([System.Boolean])]
    param ()

    if (-not (Test-CommandExists -Command 'git')) {
        'The command "git" was not found.'
    }

    [string]$changesWithoutBranch = (git status --porcelain | Where-Object { $_ -cnotmatch '^##' }) -join "`n"

    [string]::IsNullOrWhiteSpace($changesWithoutBranch)
}
