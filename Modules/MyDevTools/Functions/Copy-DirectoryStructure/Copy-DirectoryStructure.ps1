<#
.SYNOPSIS
Copies the folder structure of the specified directory to the current directory.

.PARAMETER LiteralPath
Specifies the path of the source directory to copy.

.NOTES
Prerequisite: Must be run on a Windows OS environment.
#>
function Copy-DirectoryStructure {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Container')) {
                    throw "The path '$($_)' does not exist."
                }

                $true
            })]
        [string]$LiteralPath
    )

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }

    [System.IO.DirectoryInfo]$targetDirectory = Get-Item -LiteralPath $LiteralPath
    [string]$destDirectoryFullName = Join-Path -Path $PWD.ProviderPath -ChildPath "_$($targetDirectory.Name)"

    if (Test-StrictPath -LiteralPath $destDirectoryFullName) {
        throw "The path '$($destDirectoryFullName)' is already in place."
    }

    if ($PSCmdlet.ShouldProcess($destDirectoryFullName, 'Copy directory structure')) {
        $null = New-Item -Path $destDirectoryFullName -ItemType 'Directory' -Force
        # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy#parameter
        $null = xcopy.exe /E /T $targetDirectory.FullName $destDirectoryFullName
    }
}

Set-Alias -Name 'cptree' -Value 'Copy-DirectoryStructure'
