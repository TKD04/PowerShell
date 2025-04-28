<#
.SYNOPSIS
Imports a JSON file as [PSCustomObject] or [HashTable].

.PARAMETER LiteralPath
A source path to a JSON file.

.PARAMETER AsHashTable
Whether to import a JSON file as [HashTable].
#>
function Import-MyJSON {
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({
                if (!(Test-MyStrictPath -LiteralPath $_)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$LiteralPath,
        [switch]$AsHashTable
    )

    try {
        [string]$json = Get-Content -LiteralPath $LiteralPath -Raw

        ConvertFrom-Json -InputObject $json -AsHashtable:$AsHashTable
    }
    catch {
        throw "Failed to import JSON from $LiteralPath. $_"
    }
    Write-MySuccess -Message ('Imported JSON from "{0}".' -f $LiteralPath)
}
