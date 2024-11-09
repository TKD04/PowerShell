<#
.SYNOPSIS
Remove all files, not directories, from the current directory.
#>
function Remove-MyAllFiles {
    [Alias('rmallfiles')]
    [OutputType([void])]
    param ()

    Get-ChildItem -File | Remove-Item $allFiles -Confirm:$Confirm -WhatIf
}
