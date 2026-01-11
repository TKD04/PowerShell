<#
.SYNOPSIS
Removes the .git directory from the current directory.
#>
function Remove-MyGitHistory {
    [OutputType([void])]
    param()

    [string]$gitFullPath = (Resolve-Path -LiteralPath '.\.git' -ErrorAction Stop).Path

    Remove-Item -LiteralPath $gitFullPath -Recurse -Force -Confirm
}

Set-Alias -Name 'rmgh' -Value 'Remove-MyGitHistory'
