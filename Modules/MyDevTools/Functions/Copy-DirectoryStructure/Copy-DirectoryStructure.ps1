<#
.SYNOPSIS
Copies the folder structure of the specified directory to the current directory.

.PARAMETER LiteralPath
Specifies the path of the source directory to copy.

.PARAMETER DestPath
Specifies the path of the destination directory.
#>
function Copy-DirectoryStructure {
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Container')) {
                    throw "The path '$_' does not exist."
                }

                $true
            })]
        [string]$LiteralPath,
        [string]$DestPath
    )

    [string]$dirName = Resolve-Path -LiteralPath $LiteralPath | Split-Path -Leaf

    $null = New-Item -Path $DestPath -ItemType 'Directory' -Force
    # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
    xcopy.exe /E /T $LiteralPath $DestPath
}

Set-Alias -Name 'cptree' -Value 'Copy-DirectoryStructure'
