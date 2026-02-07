<#
.SYNOPSIS
Exports the given [hashtable] as a JSON file.

.PARAMETER LiteralPath
A destination path for an export.

.PARAMETER Hashtable
A hashtable to be export.

.PARAMETER Depth
Specifies how many levels of contained objects are included in the JSON representation.
#>
function Export-MyJSON {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$LiteralPath,
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Hashtable,
        [int]$Depth = 4
    )

    [string]$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LiteralPath)

    try {
        ConvertTo-Json -InputObject $Hashtable -Depth $Depth |
        Set-Content -LiteralPath $fullPath -ErrorAction 'Stop'
    }
    catch {
        throw "Failed to export JSON to '$fullPath': $_"
    }
}
