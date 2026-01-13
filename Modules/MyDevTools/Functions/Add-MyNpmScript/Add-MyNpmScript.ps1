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
        [hashtable]$NameToScript
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath '.\package.json' -ErrorAction Stop).Path
    # NOTE: To add new properties we need to use [hashtable] instead of [PSCustomObject]
    # since [PSCustomObject] returns an error when new properties are added to it.
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath -AsHashTable

    if (-not $package.ContainsKey('scripts')) {
        $package['scripts'] = @{}
    }
    foreach ($kv in $NameToScript.GetEnumerator()) {
        $package['scripts'][$kv.Key] = $kv.Value
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -CustomObject $package
}
