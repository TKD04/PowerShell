<#
.SYNOPSIS
Remove all files, not directories, from the current directory.
#>
function Remove-MyAllFiles {
    [OutputType([void])]
    param ()

    Get-ChildItem -File | Remove-Item -Confirm
}

Set-Alias -Name 'rmfiles' -Value 'Remove-MyAllFiles'
