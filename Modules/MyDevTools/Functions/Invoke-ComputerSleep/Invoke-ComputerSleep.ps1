<#
.SYNOPSIS
Puts the local computer into a sleep state.

.NOTES
Prerequisite: Must be run on a Windows OS environment.
#>
function Invoke-ComputerSleep {
    [OutputType([System.Void])]
    param ()

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::SetSuspendState([System.Windows.Forms.PowerState]::Suspend, $false, $false)
}
