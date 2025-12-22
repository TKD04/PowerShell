<#
.SYNOPSIS
Removes the given name of npm script from package.json.

.PARAMETER ScriptName
A name of npm sciprt.
#>
function Remove-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ScriptName
    )

    if (!(Test-MyStrictPath -LiteralPath '.\package.json')) {
        throw '.\package.json could not be found.'
    }
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    [boolean]$hasScript = $package.scripts.ContainsKey($ScriptName)

    if ($hasScript) {
        $package.scripts.Remove($ScriptName)
    }
    else {
        throw 'The key "{0}" could not be found in npm scripts.' -f $ScriptName
    }
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
}
