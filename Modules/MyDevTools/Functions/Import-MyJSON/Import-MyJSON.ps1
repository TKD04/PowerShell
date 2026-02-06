<#
.SYNOPSIS
Imports a JSON file as [HashTable].

.PARAMETER LiteralPath
A source path to a JSON file.
#>
function Import-MyJSON {
    [OutputType([System.Collections.IDictionary])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-MyStrictPath -LiteralPath $_ -PathType 'Leaf')) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$LiteralPath
    )

    [string]$fullPath = (Resolve-Path -LiteralPath $LiteralPath -ErrorAction 'Stop').Path

    try {
        [string]$json = Get-Content -LiteralPath $fullPath -Raw

        ConvertFrom-Json -InputObject $json -AsHashtable
    }
    catch {
        throw "Failed to import JSON from $LiteralPath. $_"
    }
}
