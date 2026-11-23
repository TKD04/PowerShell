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
function Rename-FileExtension {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot from the extension '$($_)'."
                }

                $true
            })]
        [string]$OldExtension,
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if ($_ -like '*.*') {
                    throw "Omit the leading dot from the extension '$($_)'."
                }

                $true
            })]
        [string]$NewExtension,
        [switch]$Recurse
    )

    [System.IO.FileInfo[]]$targetFiles = Get-ChildItem -File -Filter "*.$($OldExtension)" -Recurse:$Recurse

    foreach ($targetFile in $targetFiles) {
        [string]$newFileName = $targetFile.BaseName + '.' + $NewExtension

        if ($PSCmdlet.ShouldProcess($targetFile.FullName, "Rename to $($newFileName)")) {
            Rename-Item -LiteralPath $targetFile.FullName -NewName $newFileName
        }
    }
}

Set-Alias -Name 'renext' -Value 'Rename-FileExtension'
