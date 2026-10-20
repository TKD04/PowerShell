<#
.SYNOPSIS
Copies the folder structure of the specified directory to the current directory.

.PARAMETER LiteralPath
Specifies the path of the source directory to copy.
#>
function Copy-DirectoryStructure {
    [CmdletBinding(SupportsShouldProcess)]
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

    [System.IO.DirectoryInfo]$targetDir = Get-Item -LiteralPath $LiteralPath
    [string]$destDirName = "_$($targetDir.Name)"
    [string]$destFullName = Join-Path -Path (Get-Location).Path -ChildPath $destDirName

    if (Test-StrictPath -LiteralPath $destFullName) {
        throw "The path '$destFullName' is already in place."
    }

    if ($PSCmdlet.ShouldProcess($destFullName, 'Copy directory structure')) {
        $null = New-Item -Path $destFullName -ItemType 'Directory' -Force
        # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
        $null = xcopy.exe /E /T $targetDir.FullName $destFullName
    }
}

Set-Alias -Name 'cptree' -Value 'Copy-DirectoryStructure'
