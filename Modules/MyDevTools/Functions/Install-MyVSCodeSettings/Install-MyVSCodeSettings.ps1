<#
.SYNOPSIS
Adds the given VSCode settings and extensions to the current directory.
#>
function Install-MyVSCodeSettings {
    [OutputType([System.Void])]
    param (
        [PSCustomObject]$Settings,
        [PSCustomObject]$Extensions
    )

    if ($null -eq $Settings -and $null -eq $Extensions) {
        throw 'Either $Settings or $Extensions must be [PSCustomObject] at least.'
    }
    $null = New-Item -Path '.\.vscode' -ItemType 'Directory' -Force
    Push-Location -LiteralPath '.\.vscode'
    if ($null -ne $Settings) {
        Export-MyJSON -LiteralPath '.\settings.json' -Hashtable $Settings
        git add '.\settings.json'
    }
    if ($null -ne $Extensions) {
        Export-MyJSON -LiteralPath '.\extensions.json' -Hashtable $Extensions
        git add '.\extensions.json'
    }
    Pop-Location
    git commit -m 'Add .vscode'
}
