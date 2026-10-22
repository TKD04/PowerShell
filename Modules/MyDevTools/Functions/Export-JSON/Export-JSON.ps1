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
function Export-Json {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-Path -LiteralPath $_ -IsValid)) {
                    throw "The path '$($_)' is not valid."
                }
                if (-not ([System.IO.Path]::GetExtension($_) -in '.json', '.jsonc')) {
                    throw "The file '$($_)' must have a .json or .jsonc extension."
                }

                $true
            })]
        [string]$LiteralPath,
        [Parameter(Mandatory)]
        [hashtable]$Hashtable,
        [ValidateRange(1, 100)]
        [int]$Depth = 10
    )

    [string]$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LiteralPath)

    if ($PSCmdlet.ShouldProcess($fullPath, 'Export json file')) {
        ConvertTo-Json -InputObject $Hashtable -Depth $Depth |
        Set-Content -LiteralPath $fullPath
    }
}
