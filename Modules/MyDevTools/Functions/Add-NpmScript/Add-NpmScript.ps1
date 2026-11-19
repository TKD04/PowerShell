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

    [string]$packageJsonFullName = Join-Path -Path $PWD.ProviderPath -ChildPath 'package.json'

    if (-not (Test-StrictPath -LiteralPath $packageJsonFullName -PathType 'Leaf')) {
        throw "The path '$($packageJsonFullName)' does not exist."
    }

    [hashtable]$package = Import-Json -LiteralPath $packageJsonFullName
    [string]$scriptNames = $NameToScript.Keys -join ', '

    $package['scripts'] ??= @{}
    foreach ($key in $NameToScript.Keys) {
        $package['scripts'][$key] = $NameToScript[$key]
    }
    if ($PSCmdlet.ShouldProcess($packageJsonFullName, "Add npm script(s): [$($scriptNames)]")) {
        Export-Json -LiteralPath $packageJsonFullName -Hashtable $package -WhatIf $false
    }
}
