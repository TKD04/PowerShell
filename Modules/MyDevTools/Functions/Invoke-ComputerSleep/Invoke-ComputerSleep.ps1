<#
.SYNOPSIS
Puts the local computer into a sleep state.

.PARAMETER Minutes
Specifies the delay in minutes before putting the computer into a sleep state.

.NOTES
Prerequisite: Must be run on a Windows OS environment.
#>
function Invoke-ComputerSleep {
    [OutputType([System.Void])]
    param (
        [ValidateRange(0, 1440)]
        [int]$Minutes = 0
    )

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }
    if ($Minutes -gt 0) {
        Start-Sleep -Seconds ($Minutes * 60)
    }

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::SetSuspendState([System.Windows.Forms.PowerState]::Suspend, $false, $false)
}
