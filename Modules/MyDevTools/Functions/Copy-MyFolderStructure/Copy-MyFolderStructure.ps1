<#
.SYNOPSIS
Copies the folder structure of the given directory to the current directory.

.PARAMETER SrcPath
A source path to a directory to be copied.
#>
function Copy-MyFolderStructure {
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({
                if (-not (Test-MyStrictPath -LiteralPath $_ -PathType Container)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$LiteralPath
    )

    [string]$dirName = Resolve-Path -LiteralPath $LiteralPath | Split-Path -Leaf
    [string]$destPath = '.\_{0}' -f $dirName

    New-Item -Path $destPath -ItemType 'Directory' -Force
    # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
    xcopy.exe /E /T $LiteralPath $destPath
}

Set-Alias -Name 'cptree' -Value 'Copy-MyFolderStructure'
