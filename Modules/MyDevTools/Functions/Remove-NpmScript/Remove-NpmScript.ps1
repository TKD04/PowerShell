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

    [string]$packageJsonFullPath = (Resolve-Path -LiteralPath './package.json').ProviderPath
    [hashtable]$package = Import-Json -LiteralPath $packageJsonFullPath
    [boolean]$hasScript = $package.ContainsKey('scripts') -and $package['scripts'].ContainsKey($ScriptName)

    if (-not $hasScript) {
        throw "The npm script '$ScriptName' was not found."
    }

    if ($PSCmdlet.ShouldProcess($packageJsonFullPath, "Remove npm script: $ScriptName")) {
        $package['scripts'].Remove($ScriptName)
        if ($package['scripts'].Count -eq 0) {
            $package.Remove('scripts')
        }
        Export-Json -LiteralPath $packageJsonFullPath -Hashtable $package -WhatIf $false
    }
}
