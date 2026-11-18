<#
.SYNOPSIS
Quickly removes the specified directory using Robocopy.

.PARAMETER LiteralPath
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
        [string]$LiteralPath
    )

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }

    [System.IO.DirectoryInfo]$targetDirectory = Get-Item -LiteralPath $LiteralPath
    [string]$EmptyDirPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid())
    [bool]$isCurrentInTarget = $PWD.ProviderPath -ieq $targetDirectory.FullName -or
    $PWD.ProviderPath.StartsWith($targetDirectory + [System.IO.Path]::DirectorySeparatorChar)

    if ($isCurrentInTarget) {
        if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, "Change location to '$($targetDirectory.Parent.FullName)' to avoid file locks")) {
            Set-Location -LiteralPath $targetDirectory.Parent.FullName
        }
    }

    if ($PSCmdlet.ShouldProcess($targetDirectory.FullName, 'Remove all contents of directory')) {
        Enable-SleepPrevention
        try {
            $null = New-Item -Path $EmptyDirPath -ItemType 'Directory' -Force
            $null = Robocopy.exe $EmptyDirPath $targetDirectory.FullName /MIR /NJH /NJS /NP /NS /NC /NFL /NDL
            if ($LASTEXITCODE -ge 8) {
                throw "Robocopy failed with exit code '$($LASTEXITCODE)'."
            }
            Remove-Item -LiteralPath $targetDirectory.FullName -Recurse -Force
        }
        finally {
            Remove-Item -LiteralPath $EmptyDirPath -Recurse -Force -ErrorAction 'SilentlyContinue'
            Disable-SleepPrevention
        }
    }
}

New-Alias -Name 'rmdirf' -Value 'Remove-DirectoryFast'
