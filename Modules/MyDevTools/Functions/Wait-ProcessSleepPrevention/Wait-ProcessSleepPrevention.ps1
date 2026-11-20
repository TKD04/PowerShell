<#
.SYNOPSIS
Prevents the computer from sleeping while a specified process is running.
.PARAMETER ProcessName
Specifies the name of process to monitor (without file extension).
#>
function Wait-ProcessSleepPrevention {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ProcessName
    )

    [bool]$isProcessRunning = [bool](Get-Process -Name $ProcessName)

    Enable-SleepPrevention
    while ($isProcessRunning) {
        Start-Sleep -Seconds 60
        $isProcessRunning = [bool](Get-Process -Name $ProcessName -ErrorAction 'SilentlyContinue')
    }
    Disable-SleepPrevention
}
