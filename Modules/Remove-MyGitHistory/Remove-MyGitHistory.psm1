<#
.SYNOPSIS
Removes the .git directory from the current directory.
#>
function Remove-MyGitHistory {
    [Alias('rmgithis')]
    [OutputType([void])]
    param()

    Remove-Item -LiteralPath '.\.git' -Recurse -Force -Confirm
    Write-MySuccess -Message 'Removed .\.git directory.'
}
