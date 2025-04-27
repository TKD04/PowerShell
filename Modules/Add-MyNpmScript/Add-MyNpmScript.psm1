<#
.SYNOPSIS
Adds the given npm scripts to package.json.

.PARAMETER NameToScript
Pairs of script name and script.
#>
function Add-MyNpmScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable]$NameToScript
    )

    if (!(Test-MyStrictPath -LiteralPath './package.json')) {
        throw '.\package.json was not found.'
    }

    # NOTE: To add new properties we need to use [hashtable] instead of [PSCustomObject]
    # since [PSCustomObject] returns an error when new properties are added to it.
    [hashtable]$package = Import-MyJSON -LiteralPath './package.json' -AsHashTable
    $NameToScript.GetEnumerator() | ForEach-Object {
        if ($package.ContainsKey($_.Key)) {
            Write-Warning -Message 'The key "{0}" already exists in npm script.' -f $_.Key
        }
        else {
            $package.scripts.Add($_.Key, $_.Value)
        }
    }
    Export-MyJSON -LiteralPath './package.json' -CustomObject $package
}
