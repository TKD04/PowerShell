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
                if (!(Test-MyStrictPath -LiteralPath $_)) {
                    throw "The path '$_' does not exist or is not accessible."
                }

                $true
            })]
        [string]$LiteralPath
    )

    [string]$dirName = Resolve-Path -LiteralPath $LiteralPath | Split-Path -Leaf
    [string]$destPath = '.\_{0}' -f $dirName

    if (!(Test-MyStrictPath -LiteralPath $destPath)) {
        New-Item -Path '.\' -Name $destPath -ItemType 'Directory'
    }
    # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
    xcopy.exe /E /T $LiteralPath $destPath
}

Set-Alias -Name 'copyfolderstructure' -Value 'Copy-MyFolderStructure'
