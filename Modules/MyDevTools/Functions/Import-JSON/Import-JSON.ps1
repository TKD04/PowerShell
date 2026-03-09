<#
.SYNOPSIS
Imports a JSON file as a hashtable.

.PARAMETER LiteralPath
Specifies the path to the JSON file to import.
#>
function Import-Json {
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Leaf')) {
                    throw "The path '$_' does not exist."
                }

                $true
            })]
        [string]$LiteralPath
    )

    [string]$fullPath = (Resolve-Path -LiteralPath $LiteralPath -ErrorAction 'Stop').ProviderPath

    try {
        [string]$json = Get-Content -LiteralPath $fullPath -Raw

        ConvertFrom-Json -InputObject $json -AsHashtable
    }
    catch {
        throw "Failed to import JSON from '$LiteralPath'."
    }
}
