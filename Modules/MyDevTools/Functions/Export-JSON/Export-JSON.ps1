<#
.SYNOPSIS
Exports the specified hashtable as a JSON file.

.PARAMETER LiteralPath
Specifies the destination path for the exported JSON file.

.PARAMETER Hashtable
Specifies the hashtable to export.

.PARAMETER Depth
Specifies the maximum depth of nested objects to include in the JSON representation.
#>
function Export-JSON {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$LiteralPath,
        [Parameter(Mandatory)]
        [hashtable]$Hashtable,
        [ValidateRange(1, 100)]
        [int]$Depth = 10
    )

    [string]$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LiteralPath)

    try {
        ConvertTo-Json -InputObject $Hashtable -Depth $Depth |
        Set-Content -LiteralPath $fullPath -ErrorAction 'Stop'
    }
    catch {
        throw "Failed to export JSON to '$fullPath'."
    }
}
