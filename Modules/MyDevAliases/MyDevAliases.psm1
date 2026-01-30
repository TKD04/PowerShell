Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

if (!(Test-Path -LiteralPath "$PSScriptRoot\Functions")) {
    throw 'Functions directory could not be found.'
}

# Loads all the functions under the modules by dot-source
$functionFiles = Get-ChildItem -LiteralPath "$PSScriptRoot\Functions" -File -Filter '*.ps1' |
Select-Object -Property FullName

foreach ($functionFile in $functionFiles) {
    . $functionFile.FullName
}
