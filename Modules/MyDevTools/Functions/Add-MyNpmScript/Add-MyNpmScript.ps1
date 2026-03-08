<#
.SYNOPSIS
Adds one or more npm scripts to the "scripts" section of package.json.

.PARAMETER NameToScript
Specifies a hashtable containing pairs of script names and their corresponding commands.
#>
function Add-MyNpmScript {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [hashtable]$NameToScript
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath './package.json' -ErrorAction 'Stop').ProviderPath
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath

    if (-not $package.ContainsKey('scripts')) {
        $package['scripts'] = @{}
    }
    foreach ($key in $NameToScript.Keys) {
        $package['scripts'][$key] = $NameToScript[$key]
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -Hashtable $package
}
