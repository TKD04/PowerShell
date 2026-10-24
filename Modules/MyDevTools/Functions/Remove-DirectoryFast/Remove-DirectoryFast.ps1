<#
.SYNOPSIS
Quickly removes all contents of the specified directory using Robocopy.

.PARAMETER Directory
Specifies the directory whose contents will be removed.

.NOTES
Prerequisite: Must be run on a Windows OS environment.
#>
function Remove-DirectoryFast {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Container')) {
                    throw "The path '$($_)' does not exist."
                }
                if ($null -eq (Get-Item -LiteralPath $_).Parent) {
                    throw "Refusing to remove drive root '$($_)'."
                }

                $true
            })]
        [string]$Directory
    )

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }

    [string]$DirectoryFullPath = Convert-Path -LiteralPath $Directory
    [string]$EmptyDirPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid())
    [bool]$isCurrentDir = $PWD.Path -ieq $DirectoryFullPath

    if ($PSCmdlet.ShouldProcess($DirectoryFullPath, 'Remove all contents of directory')) {
        Enable-SleepPrevention
        try {
            $null = New-Item -Path $EmptyDirPath -ItemType 'Directory' -Force
            $null = Robocopy.exe $EmptyDirPath $DirectoryFullPath /MIR /NJH /NJS /NP /NS /NC /NFL /NDL
            if ($LASTEXITCODE -ge 8) {
                throw "Robocopy failed with exit code '$($LASTEXITCODE)'."
            }
            if (-not $isCurrentDir) {
                Remove-Item -LiteralPath $DirectoryFullPath -Recurse -Force
            }

        }
        finally {
            Remove-Item -LiteralPath $EmptyDirPath -Recurse -Force -ErrorAction 'SilentlyContinue'
            Disable-SleepPrevention
        }
    }
}

New-Alias -Name 'rmdirf' -Value 'Remove-DirectoryFast'
