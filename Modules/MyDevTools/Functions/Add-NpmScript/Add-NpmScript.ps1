<#
.SYNOPSIS
Adds one or more npm scripts to the "scripts" section of package.json.

.PARAMETER NameToScript
Specifies a hashtable containing pairs of script names and their corresponding commands.
#>
function Add-NpmScript {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [hashtable]$NameToScript
    )

    [string]$packageRelativeName = './package.json'

    if (-not (Test-StrictPath -LiteralPath $packageRelativeName -PathType 'Leaf')) {
        throw "$($packageRelativeName) was not found."
    }

    [string]$packageJsonFullPath = Convert-Path -LiteralPath $packageRelativeName
    [hashtable]$package = Import-Json -LiteralPath $packageJsonFullPath
    [string]$scriptNames = $NameToScript.Keys -join ', '

    $package['scripts'] ??= @{}
    foreach ($key in $NameToScript.Keys) {
        $package['scripts'][$key] = $NameToScript[$key]
    }
    if ($PSCmdlet.ShouldProcess($packageJsonFullPath, "Add npm script(s): [$scriptNames]")) {
        Export-Json -LiteralPath $packageJsonFullPath -Hashtable $package -WhatIf $false
    }
}
