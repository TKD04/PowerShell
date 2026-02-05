<#
.SYNOPSIS
Renames the file extensions the new one.

.PARAMETER OldExtension
The file extension which you want to replace with the new one.

.PARAMETER NewExtension
The file extension which you want to replace the old one with

.PARAMETER UseGitMv
Whether to use git mv to rename files.

.PARAMETER Recurse
Whether to rename the matched files recursively.
#>
function Rename-MyFileExtension {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$OldExtension,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$NewExtension,
        [switch]$UseGitMv,
        [switch]$Recurse
    )

    $files = Get-ChildItem -File -Filter "*.$OldExtension" -Recurse:$Recurse

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
