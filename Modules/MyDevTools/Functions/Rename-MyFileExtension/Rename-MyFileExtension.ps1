<#
.SYNOPSIS
Renames the file extensions the new one.

.PARAMETER OldExtension
The file extension which you want to replace with the new one.

.PARAMETER NewExtension
The file extension which you want to replace the old one with

.PARAMETER Recurse
Whether to rename the matched files recursively.

.PARAMETER UseGitMv
Whether to use git mv to rename files.
#>
function Rename-MyFileExtension {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$OldExtension,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$NewExtension,
        [switch]$Recurse,
        [switch]$UseGitMv
    )

    $files = Get-ChildItem -File -Recurse:$Recurse -Filter "*.$OldExtension"

    foreach ($file in $files) {
        $newName = $file.FullName -replace "\.$OldExtension$", ".$NewExtension"
        if ($UseGitMv) {
            git mv $file.FullName $newName
        }
        else {
            Rename-Item -LiteralPath $file.FullName -NewName $newName
        }
    }
}

Set-Alias -Name 'renext' -Value 'Rename-MyFileExtension'
