<#
.SYNOPSIS
Removes the given name of npm script from package.json.

.PARAMETER ScriptName
#>
function Remove-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ScriptName
    )

    [string]$packagePath = '.\package.json'

    if (!(Test-MyStrictPath -LiteralPath $packagePath)) {
        throw '.\package.json was not found.'
    }

    [hashtable]$package = Import-MyJSON -LiteralPath $packagePath -AsHashTable
    [boolean]$hasScript = $package.scripts.ContainsKey($ScriptName)

    if ($hasScript) {
        $package.scripts.Remove($ScriptName)
    }
    else {
        throw 'The key "{0}" was not found in npm scripts.' -f $ScriptName
    }
    Export-MyJSON -LiteralPakh $packagePath -CustomObject $package
}
