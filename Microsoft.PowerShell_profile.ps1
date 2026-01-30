Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    [string]$currentEdition = $PSVersionTable.PSEdition
    [string]$currentVersion = $PSVersionTable.PSVersion

    Write-Error -Message "Unsupported PowerShell environment (Edition: $currentEdition, Version: $currentVersion)."
    Write-Warning -Message 'This profile and associated scripts require PowerShell 7+ (Core edition).'
    throw 'Environment specification mismatch.'
}
