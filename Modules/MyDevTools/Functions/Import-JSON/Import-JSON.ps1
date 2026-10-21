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
                if (-not ([System.IO.Path]::GetExtension($_) -in '.json', '.jsonc')) {
                    throw "The file '$_' must have a .json or .jsonc extension."
                }

                $true
            })]
        [string]$LiteralPath
    )

    Get-Content -LiteralPath $LiteralPath -Raw |
    ConvertFrom-Json -AsHashtable
}
