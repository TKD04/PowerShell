Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    [string]$currentEdition = $PSVersionTable.PSEdition
    [string]$currentVersion = $PSVersionTable.PSVersion

    throw "Unsupported PowerShell environment (Edition: $currentEdition, Version: $currentVersion). Requires PowerShell 7+ (Core)."
}
