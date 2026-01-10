<#
.SYNOPSIS
Exports the given [PSCustomObject] as a JSON file.

.PARAMETER LiteralPath
A destination path for an export.

.PARAMETER CustomObject
A [PSCustomObject] to be export.

.PARAMETER Depth
Specifies how many levels of contained objects are included in the JSON representation.
#>
function Export-MyJSON {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string]$LiteralPath,
        [Parameter(Mandatory)]
        [PSCustomObject]$CustomObject,
        [int]$Depth = 4
    )

    try {
        ConvertTo-Json -InputObject $CustomObject -Depth $Depth |
        Set-Content -LiteralPath $LiteralPath -ErrorAction Stop
    }
    catch {
        throw "Failed to export JSON to $LiteralPath. $_"
    }
}
