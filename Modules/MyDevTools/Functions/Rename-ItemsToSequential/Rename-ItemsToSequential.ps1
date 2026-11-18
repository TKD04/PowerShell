<#
.SYNOPSIS
Safely renames all files and directories within a specified target directory into sequential numbers.

.PARAMETER LiteralPath
Specifies the literal path to the target directory. Root drives (e.g., C:\) are prohibited via validation to prevent catastrophic bulk operations.

.NOTES
Automatically relocates the current working directory ($PWD) if it resides within or at the target directory tree to prevent file locks.
#>
function Rename-ItemsToSequential {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_)) {
                    throw "The path '$($_)' does not exist."
                }
                if (Test-StrictPath -LiteralPath $_ -PathType 'Leaf') {
                    throw "The path '$($_)' is a file."
                }
                if ($null -eq (Get-Item -LiteralPath $_).Parent) {
                    throw 'Root drives are not allowed to prevent catastrophic bulk operations.'
                }

                $true
            })]
        [string]$LiteralPath
    )

    [System.IO.DirectoryInfo]$targetDirectory = Get-Item -LiteralPath $LiteralPath
    [bool]$isCurrentInTarget = $PWD.ProviderPath -ieq $targetDirectory.FullName -or
    $PWD.ProviderPath.StartsWith($targetDirectory.FullName + [System.IO.Path]::DirectorySeparatorChar)

    if ($isCurrentInTarget) {
        if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, "Change location to $($targetDirectory.Parent.FullName) to avoid file locks")) {
            Set-Location -LiteralPath $targetDirectory.Parent.FullName
        }
    }

    Enable-SleepPrevention
    try {
        # 1. Rename files with sequential numbers.
        [System.IO.FileInfo[]]$files = Get-ChildItem -LiteralPath $targetDirectory.FullName -File -Recurse
        [int]$fileIndex = 1

        foreach ($file in $files) {
            do {
                [string]$newName = $fileIndex.ToString()
                [string]$newFullName = Join-Path -Path $file.DirectoryName -ChildPath $newName

                $fileIndex += 1
            } while (Test-StrictPath -LiteralPath $newFullName)
            if ($PSCmdlet.ShouldProcess($file.FullName, "Rename file to $($newName)")) {
                Rename-Item -LiteralPath $file.FullName -NewName $newName
            }
        }

        # 2. Sort folders by depth in descending order and rename them with sequential numbers.
        [char[]]$pathSeparators = @(
            [System.IO.Path]::DirectorySeparatorChar
            [System.IO.Path]::AltDirectorySeparatorChar
        )
        [System.IO.DirectoryInfo[]]$directories = Get-ChildItem -LiteralPath $targetDirectory.FullName -Directory -Recurse |
        Sort-Object -Property {
            ($_.FullName.Split($pathSeparators, [System.StringSplitOptions]::RemoveEmptyEntries)).Count
        } -Descending
        [int]$dirIndex = 1

        foreach ($directory in $directories) {
            do {
                [string]$newName = "d_$dirIndex"
                [string]$newFullName = Join-Path -Path $directory.Parent.FullName -ChildPath $newName

                $dirIndex += 1
            } while (Test-StrictPath -LiteralPath $newFullName)
            if ($PSCmdlet.ShouldProcess($directory.FullName, "Rename directory to $($newName)")) {
                Rename-Item -LiteralPath $directory.FullName -NewName $newName
            }
        }

        # 3. Finally, rename the root folder itself.
        do {
            [string]$newName = "d_$dirIndex"
            [string]$newFullName = Join-Path -Path $targetDirectory.Parent.FullName -ChildPath $newName

            $dirIndex += 1
        } while (Test-StrictPath -LiteralPath $newFullName)
        if ($PSCmdlet.ShouldProcess($targetDirectory.FullName, "Rename root directory to $($newName)")) {
            Rename-Item -LiteralPath $targetDirectory.FullName -NewName $newName
        }
    }
    finally {
        Disable-SleepPrevention
    }
}
