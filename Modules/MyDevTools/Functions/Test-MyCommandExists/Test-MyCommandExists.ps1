using namespace System.Management.Automation

# https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
<#
.SYNOPSIS
Tests whether the specified command exists.

.PARAMETER Command
Specifies the name of the command to test.
#>
function Test-MyCommandExists {
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$Command
    )

    [ActionPreference]$oldErrorActionPreference = $ErrorActionPreference

    $ErrorActionPreference = 'Stop'
    try {
        if (Get-Command -Name $Command) {
            $true
        }
    }
    catch {
        $false
    }
    finally {
        $ErrorActionPreference = $oldErrorActionPreference
    }
}
