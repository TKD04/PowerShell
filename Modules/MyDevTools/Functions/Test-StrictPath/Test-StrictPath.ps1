<#
.SYNOPSIS
Tests whether the specified path is valid, with stricter rules than Test-Path.

.PARAMETER LiteralPath
Specifies the path to test.

.PARAMETER PathType
Specifies the type of item the path should represent. Acceptable values are:

- 'Any'      : Any item (default)
- 'Container': A directory
- 'Leaf'     : A file

.NOTES
This function was created to handle some edge cases of Test-Path:

- In Windows PowerShell, Test-Path throws an error instead of returning $false for an empty string (e.g., '').
- In Windows PowerShell, Test-Path returns $true for a blank string (e.g., ' ') instead of $false.
- In Windows PowerShell and PowerShell Core, Test-Path returns $true for a valid path with trailing whitespace (e.g., '/path/to/file ') instead of $false.
#>
function Test-StrictPath {
    [OutputType([System.Boolean])]
    param (
        [AllowEmptyString()]
        [string]$LiteralPath,
        [ValidateSet('Any', 'Container', 'Leaf')]
        [string]$PathType = 'Any'
    )

    [bool]$LiteralPath `
        -and -not $LiteralPath.EndsWith(' ') `
        -and (Test-Path -LiteralPath $LiteralPath -PathType $PathType)
}
