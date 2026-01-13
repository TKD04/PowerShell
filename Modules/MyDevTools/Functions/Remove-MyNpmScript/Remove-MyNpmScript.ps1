<#
.SYNOPSIS
Removes the given name of npm script from package.json.

.PARAMETER ScriptName
A name of npm sciprt.
#>
function Remove-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string]$ScriptName
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath '.\package.json' -ErrorAction Stop).Path
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath -AsHashTable
    [boolean]$hasScript = $package['scripts'].ContainsKey($ScriptName)

    if ($hasScript) {
        $package['scripts'].Remove($ScriptName)
    }
    else {
        throw 'The key "{0}" could not be found in npm scripts.' -f $ScriptName
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -CustomObject $package
}
