<#
.SYNOPSIS
Safely renames all files and directories within a specified target directory into sequential numbers.
.PARAMETER LiteralPath
Specifies the literal path to the target directory. Root drives (e.g., C:\) are prohibited via validation to prevent catastrophic bulk operations.
.NOTES
Automatically relocates the current working directory ($PWD) if it resides within or at the target tree to prevent file locks.
#>
function Rename-ItemsToSequential {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Container')) {
                    throw '$LiteralPath is not a directory or inaccessible.'
                }
                if ($null -eq (Get-Item -LiteralPath $_).Parent) {
                    throw 'Root drives are not allowed to prevent catastrophic bulk operations.'
                }

                $true
            })]
        [string]$LiteralPath
    )

    [System.IO.DirectoryInfo]$rootDirectory = Get-Item -LiteralPath $LiteralPath
    [string]$rootFullName = $rootDirectory.FullName
    [bool]$isInTargetTree = $PWD.ProviderPath -ieq $rootFullName -or
    $PWD.ProviderPath.StartsWith($rootFullName + [System.IO.Path]::DirectorySeparatorChar)

    if ($isInTargetTree) {
        if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, "Change location to $($rootDirectory.Parent.FullName) to avoid file locks")) {
            Set-Location -LiteralPath $rootDirectory.Parent.FullName
        }
    }

    Enable-SleepPrevention
    try {
        # 1. Rename files with sequential numbers.
        [System.IO.FileInfo[]]$files = Get-ChildItem -LiteralPath $rootFullName -File -Recurse
        [int]$fileIndex = 1

        foreach ($file in $files) {
            do {
                [string]$newName = $fileIndex.ToString()
                [string]$destPath = Join-Path -Path $file.DirectoryName -ChildPath $newName

                $fileIndex += 1
            } while (Test-StrictPath -LiteralPath $destPath)
            if ($PSCmdlet.ShouldProcess($file.FullName, "Rename file to $newName")) {
                Rename-Item -LiteralPath $file.FullName -NewName $newName
            }
        }

        # 2. Sort folders by depth in descending order and rename them with sequential numbers.
        [System.IO.DirectoryInfo[]]$directories = Get-ChildItem -LiteralPath $rootFullName -Directory -Recurse |
        Sort-Object -Property { ($_.FullName.Split('\')).Count } -Descending
        [int]$dirIndex = 1

        foreach ($directory in $directories) {
            do {
                [string]$newName = "d_$dirIndex"
                [string]$destPath = Join-Path -Path $directory.Parent.FullName -ChildPath $newName

                $dirIndex += 1
            } while (Test-StrictPath -LiteralPath $destPath)
            if ($PSCmdlet.ShouldProcess($directory.FullName, "Rename directory to $newName")) {
                Rename-Item -LiteralPath $directory.FullName -NewName $newName
            }
        }

        # 3. Finally, rename the root folder itself.
        do {
            [string]$newName = "d_$dirIndex"
            [string]$destPath = Join-Path -Path $rootDirectory.Parent.FullName -ChildPath $newName

            $dirIndex += 1
        } while (Test-StrictPath -LiteralPath $destPath)
        if ($PSCmdlet.ShouldProcess($rootDirectory.FullName, "Rename root directory to $newName")) {
            Rename-Item -LiteralPath $rootDirectory.FullName -NewName $newName
        }
    }
    finally {
        Disable-SleepPrevention
    }
}
