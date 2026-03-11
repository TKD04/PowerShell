<#
.SYNOPSIS
Removes all files and subdirectories in the current directory.
#>
function Clear-Directory {
    [OutputType([System.Void])]
    param ()

    Remove-DirectoryFast -Directory $PWD
}

Set-Alias -Name 'cldir' -Value 'Clear-Directory'
