<#
.SYNOPSIS
Adds the given npm scripts to package.json.

.PARAMETER NameToScript
Pairs of script name and script.
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
