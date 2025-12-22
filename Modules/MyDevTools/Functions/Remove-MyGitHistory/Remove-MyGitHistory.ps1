<#
.SYNOPSIS
Removes the .git directory from the current directory.
#>
function Remove-MyGitHistory {
    [Alias('rmgithis')]
    [OutputType([void])]
    param()

    if (!(Test-MyStrictPath -LiteralPath '.\.git')) {
        throw '.\.git directory could not be found.'
    }
    Remove-Item -LiteralPath '.\.git' -Recurse -Force -Confirm
}
