<#
.SYNOPSIS
Removes all the files and directories from the current directory.
#>
function Clear-MyCurrentDirectory {
    [Alias('cldir')]
    [OutputType([void])]
    param ()

    try {
        $files = Get-ChildItem -LiteralPath '.\' -Force -ErrorAction Stop
        if ($files.Count -eq 0) {
            throw 'No files or directories found in the current directory.'
        }
        $files | Remove-Item -Recurse -Force -ErrorAction Stop
    }
    catch {
        Write-Error -Message "Failed to clear the current directory: $_"
    }
}
