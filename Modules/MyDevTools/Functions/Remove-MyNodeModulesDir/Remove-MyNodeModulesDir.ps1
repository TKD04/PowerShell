<#
.SYNOPSIS
Removes the node_modules directory from the current directory.
#>
function Remove-MyNodeModulesDir {
    [OutputType([void])]
    param()

    Remove-MyDirectoryFast -Directory '.\node_modules'
}

New-Alias -Name 'rmnode' -Value 'Remove-MyNodeModulesDir'
