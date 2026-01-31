<#
.SYNOPSIS
Removes the given name of npm script from package.json.

.PARAMETER ScriptName
A name of npm script.
#>
function Remove-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ScriptName
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath '.\package.json' -ErrorAction Stop).Path
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath
    [boolean]$hasScript = $package.ContainsKey('scripts') `
        -and $package['scripts'].ContainsKey($ScriptName)

    if ($hasScript) {
        $package['scripts'].Remove($ScriptName)
    }
    else {
        throw 'The key "{0}" could not be found in npm scripts.' -f $ScriptName
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -CustomObject $package
}
