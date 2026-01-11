<#
.SYNOPSIS
Removes the node_modules directory from the current directory.
#>
function Remove-MyNodeModulesDir {
    [OutputType([void])]
    param()

    [string]$nodeModulesFullPath = (Resolve-Path -LiteralPath '.\node_modules' -ErrorAction Stop).Path

    Remove-Item -LiteralPath $nodeModulesFullPath -Recurse -Force
}

New-Alias -Name 'rmnodemods' -Value 'Remove-MyNodeModulesDir'
