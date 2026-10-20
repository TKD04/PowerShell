<#
.SYNOPSIS
Converts image files in a specified directory into lossy WebP format using cwebp.
.PARAMETER LiteralPath
Specifies the path to the directory containing the target images.
.PARAMETER FileFilter
Specifies a file search pattern (e.g., "*.png", "*.jpg").
.PARAMETER Quality
Specifies the compression quality as an integer from 0 to 100.
Default is 75.
.PARAMETER Preset
Specifies a set of pre-defined parameters for various types of material.
.PARAMETER SleepOnCompletion
Specifies whether to put the computer to sleep after the image conversion is completed.
.NOTES
Prerequisite: The "cwebp" executable must be installed and available in the system's PATH.
.LINK
https://developers.google.com/speed/webp/docs/cwebp
#>
function ConvertTo-LossyWebP {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [ValidateScript({
                if (-not (Test-StrictPath -LiteralPath $_ -PathType 'Container')) {
                    throw '$LiteralPath is not a directory or inaccessible.'
                }

                $true
            })]
        [string]$LiteralPath,
        [Parameter(Mandatory)]
        [ValidatePattern('^(?=.*[\*\.])[^\\/:\<\>\|]+$')]
        [string]$FileFilter,
        [ValidateRange(0, 100)]
        [byte]$Quality = 75,
        [ValidateSet('default', 'photo', 'picture', 'drawing', 'icon', 'text')]
        [string]$Preset = 'default',
        [switch]$SleepOnCompletion
    )

    if (-not (Test-CommandExists -Command 'cwebp')) {
        throw 'The command "cwebp" was not found.'
    }

    [string]$outputDirName = 'webp_q' + $Quality.ToString()
    [string]$outputDirFullName = Join-Path -Path $LiteralPath -ChildPath "$outputDirName"
    [string[]]$WebpOptions = @(
        # Since -preset overwrites the other parameters' values (except the -q one),
        # this option should preferably appear first in the order of the arguments.
        '-preset', $Preset
        '-q', $Quality.ToString()
        '-m', '6'
        '-pass', '10'
        '-af'
        '-sharp_yuv'
        '-mt'
        '-progress'
    )

    Enable-SleepPrevention
    try {
        $null = New-Item -Path $outputDirFullName -ItemType 'Directory' -Force
        Get-ChildItem -LiteralPath $LiteralPath -File -Filter $FileFilter |
        ForEach-Object {
            [string]$destFullPath = Join-Path -Path $outputDirFullName -ChildPath ($_.BaseName + '.webp')

            if ($PSCmdlet.ShouldProcess($destFullPath, 'Convert to WebP')) {
                &'cwebp' $WebpOptions '-o' $destFullPath -- $_.FullName
            }
        }
    }
    finally {
        Disable-SleepPrevention
        if ($SleepOnCompletion) {
            Invoke-ComputerSleep
        }
    }
}
