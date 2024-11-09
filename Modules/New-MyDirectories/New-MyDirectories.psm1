<#
.SYNOPSIS
Creates directories based on the provided array of directory paths.

.PARAMETER DirectoryPaths
An array of strings representing the directory paths to be created.
#>
function New-MyDirectories {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string[]]$DirectoryPaths
    )

    foreach ($path in $DirectoryPaths) {
        if (!(Test-MyStrictPath -LiteralPath $path)) {
            New-Item -Path $path -ItemType Directory
            Write-Host -Object "Created directory: $path"
        }
        else {
            Write-Host -Object "Directory already exists: $path"
        }
    }
}
