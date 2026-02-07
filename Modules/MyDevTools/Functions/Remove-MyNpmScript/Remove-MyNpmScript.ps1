<#
.SYNOPSIS
Removes the given name of npm script from package.json.

.PARAMETER ScriptName
A name of npm script.
#>
function Remove-MyNpmScript {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ScriptName
    )

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath '.\package.json' -ErrorAction 'Stop').ProviderPath
    [hashtable]$package = Import-MyJSON -LiteralPath $packageJsonFullPath
    [boolean]$hasScript = $package.ContainsKey('scripts') `
        -and $package['scripts'].ContainsKey($ScriptName)

    if ($hasScript) {
        $package['scripts'].Remove($ScriptName)
        if ($package['scripts'].Count -eq 0) {
            $package.Remove('scripts')
        }
    }
    else {
        throw "The key '$ScriptName' could not be found in npm scripts."
    }
    Export-MyJSON -LiteralPath $packageJsonFullPath -CustomObject $package
}
