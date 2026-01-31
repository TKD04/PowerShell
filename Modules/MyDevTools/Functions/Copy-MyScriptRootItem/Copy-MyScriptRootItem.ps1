<#
.SYNOPSIS
Copies an item from the script's root directory to a destination.

.PARAMETER ChildPath
Specifies the relative path to the file or folder located within the script's root directory.

.PARAMETER Destination
Specifies the path to the location where the item is to be copied.

.PARAMETER Force
Indicates that the function should overwrite the destination item if it already exists.
#>
function Copy-MyScriptRootItem {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ChildPath,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$Destination,
        [switch]$Force
    )

    [string]$fullPath = Join-Path -Path $PSScriptRoot -ChildPath $ChildPath

    Copy-Item -LiteralPath $fullPath -Destination $Destination -Recurse -Force:$Force -ErrorAction 'Stop'
}
