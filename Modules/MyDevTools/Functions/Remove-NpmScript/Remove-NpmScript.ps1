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

    [string]$packageRelativeName = './package.json'

    if (-not (Test-StrictPath -LiteralPath $packageRelativeName -PathType 'Leaf')) {
        throw "$($packageRelativeName) was not found."
    }

    [string]$packageJsonFullPath = Convert-Path -LiteralPath $packageRelativeName
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
