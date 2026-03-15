<#
.SYNOPSIS
Copies the folder structure of the specified directory to the current directory.

.PARAMETER LiteralPath
Specifies the path of the source directory to copy.
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
        [string]$LiteralPath
    )

    [string]$dirName = Resolve-Path -LiteralPath $LiteralPath | Split-Path -Leaf
    [string]$destPath = "./_$dirName"

    $null = New-Item -Path $destPath -ItemType 'Directory' -Force
    # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
    xcopy.exe /E /T $LiteralPath $destPath
}

Set-Alias -Name 'cptree' -Value 'Copy-DirectoryStructure'
