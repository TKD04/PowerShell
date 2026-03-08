<#
.SYNOPSIS
Removes all files and subdirectories in the current directory.
#>
function Clear-MyCurrentDirectory {
    [OutputType([System.Void])]
    param ()

    Remove-MyDirectoryFast -Directory $PWD
}

Set-Alias -Name 'cldir' -Value 'Clear-MyCurrentDirectory'
