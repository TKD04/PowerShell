<#
.SYNOPSIS
Puts the local computer into a sleep state.
#>
function Invoke-ComputerSleep {
    [OutputType([System.Void])]
    param ()

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::SetSuspendState([System.Windows.Forms.PowerState]::Suspend, $false, $false)
}
