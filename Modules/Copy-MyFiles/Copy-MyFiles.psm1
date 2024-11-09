<#
.SYNOPSIS
Copies files from source locations to destination locations.

.PARAMETER SourcesToDestinations
A hashtable containing the paths of the files sources and destinations.
Each entry'skey is the source path, and the value is the destination path.
e.g. $SourcesToDestinations = @{ "SourcePath" = "DestinationPath" }
#>
function Copy-MyFiles {
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$SourcesToDestinations
    )

    $jobs = @()

    $SourcesToDestinations.GetEnumerator() | ForEach-Object {
        $job = Start-Job -ScriptBlock {
            param($source, $destination)
            try {
                Copy-Item -LiteralPath $source -Destination $destination -ErrorAction Stop
                Write-Host -Object "File copied: ($source) to ($destination)"
            }
            catch {
                Write-Error -Message "Failed to copy files: ($source) to ($destination). Error: $_"
            }
        } -ArgumentList $_.Key, $_.Value
        $jobs += $job
    }

    $null = $jobs | Wait-Job | Receive-Job
}
