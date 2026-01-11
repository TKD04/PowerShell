<#
.SYNOPSIS
Tests whether the given path is a valid path, more strictly than Test-Path.

.PARAMETER LiteralPath
A path to be tested.

.PARAMETER PathType
A type of item the path should represent.
Acceptable values are:

- 'Any'         : Any item (default)
- 'Container'   : A directory
- 'Leaf'        : A file

.NOTES
For these reasons, this script was created:

- Test-Path in Windows PowerShell returns an error instead of $false
if a path is an empty string (i.e. '').
- Test-Path in Windows PowerShell returns $true instead of $false
if a path is a blank string (e.g. ' ').
- Test-Path in Windows PowerShell and PowerShell returns $true instead of $false
if a path is a valid one and has trailing whitespace (e.g. '/path/to/file ').
#>
function Test-MyStrictPath {
    [OutputType([bool])]
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
