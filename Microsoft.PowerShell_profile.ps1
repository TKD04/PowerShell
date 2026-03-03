Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    throw "Unsupported PowerShell environment (Edition: $($PSVersionTable.PSEdition), Version: $($PSVersionTable.PSVersion)). Requires PowerShell 7+ (Core)."
}
