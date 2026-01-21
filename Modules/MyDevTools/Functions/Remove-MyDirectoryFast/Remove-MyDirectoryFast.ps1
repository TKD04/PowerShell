<#
.SYNOPSIS
Removes all the files and directories inside the specified directory using a fast robocopy trick.

.PARAMETER Directory
The directory to remove.
#>
function Remove-MyDirectoryFast {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({
                if (-not (Test-MyStrictPath -LiteralPath $_ -PathType Container)) {
                    throw "Invalid path: $_"
                }

                $true
            })]
        [string]$Directory
    )

    [string]$EmptyDirPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid())
    [string]$DirectoryFullPath = (Resolve-Path -LiteralPath $Directory).Path
    [bool]$isCurrentDir = $PWD.Path -ieq $DirectoryFullPath

    if ($DirectoryFullPath -match '^[A-Z]:\\$|^\\\\[^\\]+\\[^\\]+$') {
        throw "Refusing to remove drive root: $DirectoryFullPath"
    }

    if ($PSCmdlet.ShouldProcess($DirectoryFullPath, 'Remove all contents of directory')) {
        $null = New-Item -Path $EmptyDirPath -ItemType Directory -Force
        try {
            $null = Robocopy.exe $EmptyDirPath $DirectoryFullPath /MIR /NJH /NJS /NP /NS /NC /NFL /NDL
            if ($LASTEXITCODE -ge 8) {
                throw "Robocopy failed with exit code $LASTEXITCODE"
            }
            if (-not $isCurrentDir) {
                Remove-Item -LiteralPath $DirectoryFullPath -Recurse -Force -ErrorAction Stop
            }

        }
        finally {
            Remove-Item -LiteralPath $EmptyDirPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

New-Alias -Name 'rmdirf' -Value 'Remove-MyDirectoryFast'
