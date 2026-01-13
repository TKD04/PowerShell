<#
.SYNOPSIS
Removes the .git directory from the current directory.
#>
function Remove-MyGitHistory {
    [OutputType([void])]
    param()

    Remove-MyDirectoryFast -Directory '.\.git'
}

Set-Alias -Name 'rmgh' -Value 'Remove-MyGitHistory'
