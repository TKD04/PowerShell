<#
.SYNOPSIS
Copies a file in the $PSScriptPath directory to a specified destination path.

.PARAMETER ChildPath
A relative path to the file in the $PSScriptRoot directory.

.PARAMETER Destination
A destination path.
#>
function Copy-MyPSScriptRootItem {
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({
                [string]$fullPath = Join-Path -Path $PSScriptRoot -ChildPath $_
                if (!(Test-MyStrictPath -LiteralPath $fullPath)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$ChildPath,
        [Parameter(Mandatory)]
        [ValidateScript({
                if (!(Test-MyStrictPath -LiteralPath $_)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$Destination
    )

    Join-Path -Path $PSScriptRoot -ChildPath $ChildPath |
    Copy-Item -Destination $Destination
}
