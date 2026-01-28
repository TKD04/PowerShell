<#
.SYNOPSIS
Adds the given npm scripts to package.json.

.PARAMETER NameToScript
Pairs of script name and script.
#>
function Add-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$NameToScript
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath '.\package.json' -ErrorAction Stop).Path
    # NOTE: To add new properties we need to use [hashtable] instead of [PSCustomObject]
    # since [PSCustomObject] returns an error when new properties are added to it.
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath

    if (-not $package.ContainsKey('scripts')) {
        $package['scripts'] = [ordered]@{}
    }
    foreach ($key in $NameToScript.Keys) {
        $package['scripts'][$key] = $NameToScript[$key]
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -CustomObject $package
}
