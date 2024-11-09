<#
.SYNOPSIS
Removes the node_modules directory from the current directory.
#>
function Remove-MyNodeModulesDir {
    [Alias('rmnodemodules')]
    [OutputType([void])]
    param()

    if (!(Test-MyStrictPath -LiteralPath '.\node_modules')) {
        throw '.\node_modules directory not found.'
    }

    Remove-Item -LiteralPath '.\node_modules' -Recurse -Force
}
