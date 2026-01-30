Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

[string]$scriptDir = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
[string[]]$scriptFiles = @()

if (-not (Test-Path -LiteralPath $scriptDir -PathType 'Container')) {
    throw "Functions directory could not be found: $scriptDir"
}

$scriptFiles = (Get-ChildItem -LiteralPath $scriptDir -File -Filter '*.ps1' -Recurse).FullName
foreach ($file in $scriptFiles) {
    . $file
}
