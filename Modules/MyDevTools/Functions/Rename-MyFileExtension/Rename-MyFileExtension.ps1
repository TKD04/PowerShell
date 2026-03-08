<#
.SYNOPSIS
Renames file extensions to a new one.

.PARAMETER OldExtension
Specifies the file extension to replace (without the leading dot).

.PARAMETER NewExtension
Specifies the new file extension (without the leading dot).

.PARAMETER Recurse
Specifies whether to rename matching files recursively.
#>
function Rename-MyFileExtension {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot from the extension '$_'."
                }

                $true
            })]
        [string]$OldExtension,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot from the extension '$_'."
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
