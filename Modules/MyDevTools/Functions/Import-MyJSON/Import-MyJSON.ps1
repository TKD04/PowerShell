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
        [Parameter(Mandatory)]
        [ValidateScript({
                if (-not (Test-MyStrictPath -LiteralPath $_ -PathType Leaf)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$LiteralPath,
        [switch]$AsHashTable
    )

    [string]$fullPath = (Resolve-Path -LiteralPath $LiteralPath -ErrorAction Stop).Path

    try {
        [string]$json = Get-Content -LiteralPath $fullPath -Raw

        ConvertFrom-Json -InputObject $json -AsHashtable:$AsHashTable
    }
    catch {
        throw "Failed to import JSON from $LiteralPath. $_"
    }
}
