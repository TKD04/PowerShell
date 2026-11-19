<#
.SYNOPSIS
Removes the specified npm script from package.json.

.PARAMETER ScriptName
Specifies the name of npm script to remove.
#>
function Remove-NpmScript {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ScriptName
    )

    [string]$packageJsonFullName = Join-Path -Path $PWD.ProviderPath -ChildPath 'package.json'

    if (-not (Test-StrictPath -LiteralPath $packageJsonFullName -PathType 'Leaf')) {
        throw "The path '$($packageJsonFullName)' does not exist."
    }

    [hashtable]$package = Import-Json -LiteralPath $packageJsonFullName
    [boolean]$hasScript = $package.ContainsKey('scripts') -and $package['scripts'].ContainsKey($ScriptName)

    if (-not $hasScript) {
        throw "The npm script '$($ScriptName)' does not exist."
    }

    if ($PSCmdlet.ShouldProcess($packageJsonFullName, "Remove npm script: '$($ScriptName)'")) {
        $package['scripts'].Remove($ScriptName)
        if ($package['scripts'].Count -eq 0) {
            $package.Remove('scripts')
        }
        Export-Json -LiteralPath $packageJsonFullName -Hashtable $package -WhatIf $false
    }
}
