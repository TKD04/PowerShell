<#
.SYNOPSIS
Adds the specified VS Code settings and extensions to the .vscode directory.
#>
function Install-MyVSCodeSettings {
    [OutputType([System.Void])]
    param (
        [hashtable]$Settings,
        [hashtable]$Extensions
    )

    if ($null -eq $Settings -and $null -eq $Extensions) {
        throw 'Either $Settings or $Extensions must be specified.'
    }
    $null = New-Item -Path './.vscode' -ItemType 'Directory' -Force
    Push-Location -LiteralPath './.vscode'
    if ($null -ne $Settings) {
        Export-MyJSON -LiteralPath './settings.json' -Hashtable $Settings
        git add './settings.json'
    }
    if ($null -ne $Extensions) {
        Export-MyJSON -LiteralPath './extensions.json' -Hashtable $Extensions
        git add './extensions.json'
    }
    Pop-Location
    git commit -m 'Add .vscode'
}
