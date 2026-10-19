<#
.SYNOPSIS
Enables system sleep prevention.
#>
function Enable-SleepPrevention {
    [OutputType([System.Void])]
    param ()

    if (-not ([System.Management.Automation.PSTypeName]'SleepBlocker').Type) {
        Add-Type -TypeDefinition @'
        using System;
        using System.Runtime.InteropServices;

        public class SleepBlocker {
            [DllImport("kernel32.dll", SetLastError = true)]
            public static extern uint SetThreadExecutionState(uint esFlags);

            public const uint ES_CONTINUOUS = 0x80000000;
            public const uint ES_SYSTEM_REQUIRED = 0x00000001;

            public static void Prevent() {
                SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED);
            }

            public static void Allow() {
                SetThreadExecutionState(ES_CONTINUOUS);
            }
        }
'@
    }

    [SleepBlocker]::Prevent()
}
