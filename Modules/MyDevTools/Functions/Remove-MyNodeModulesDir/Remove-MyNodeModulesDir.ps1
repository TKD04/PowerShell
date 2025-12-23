<#
.SYNOPSIS
Removes the node_modules directory from the current directory.
#>
function Remove-MyNodeModulesDir {
    [OutputType([void])]
    param()

    if (!(Test-MyStrictPath -LiteralPath '.\node_modules')) {
        throw '.\node_modules directory could not be found.'
    }
    Remove-Item -LiteralPath '.\node_modules' -Recurse -Force
}

New-Alias -Name 'rmnodemodules' -Value 'Remove-MyNodeModulesDir'
