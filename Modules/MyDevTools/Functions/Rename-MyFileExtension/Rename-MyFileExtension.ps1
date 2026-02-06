<#
.SYNOPSIS
Renames the file extensions the new one.

.PARAMETER OldExtension
The file extension which you want to replace with the new one.

.PARAMETER NewExtension
The file extension which you want to replace the old one with

.PARAMETER Recurse
Whether to rename the matched files recursively.
#>
function Rename-MyFileExtension {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot: $_"
                }

                $true
            })]
        [string]$OldExtension,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot: $_"
                }

                $true
            })]
        [string]$NewExtension,
        [switch]$Recurse
    )

    [System.IO.FileInfo[]]$files = Get-ChildItem -File -Filter "*.$OldExtension" -Recurse:$Recurse

    foreach ($file in $files) {
        [string]$newFileName = $file.BaseName + '.' + $NewExtension

        Rename-Item -LiteralPath $file.FullName -NewName $newFileName
    }
}

Set-Alias -Name 'renext' -Value 'Rename-MyFileExtension'
