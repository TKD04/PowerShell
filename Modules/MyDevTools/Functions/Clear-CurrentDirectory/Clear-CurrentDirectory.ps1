<#
.SYNOPSIS
Removes all files and subdirectories in the current directory.
#>
function Clear-CurrentDirectory {
    [OutputType([System.Void])]
    param ()

    Remove-DirectoryFast -Directory $PWD
}

Set-Alias -Name 'cldir' -Value 'Clear-CurrentDirectory'
