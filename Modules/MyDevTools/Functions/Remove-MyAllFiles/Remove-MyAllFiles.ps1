<#
.SYNOPSIS
Remove all files, not directories, from the current directory.
#>
function Remove-MyAllFiles {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param ()

    if ($PSCmdlet.ShouldProcess("$PWD\*.*", 'Remove all the files in the directory')) {
        Get-ChildItem -File | Remove-Item
    }
}

Set-Alias -Name 'rmfiles' -Value 'Remove-MyAllFiles'
