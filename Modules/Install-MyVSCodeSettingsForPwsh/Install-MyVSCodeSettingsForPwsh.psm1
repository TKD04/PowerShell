<#
.SYNOPSIS
Adds the VSCode settings for PowerShell to the current directory.
#>
function Install-MyVSCodeSettingsForPwsh {
    [OutputType([void])]
    param ()

    [PSCustomObject]$settings = [PSCustomObject]@{
        <# General #>
        'editor.formatOnSave'                          = $true
        'files.autoGuessEncoding'                      = $true
        'files.insertFinalNewline'                     = $true
        'files.trimFinalNewlines'                      = $true
        'files.trimTrailingWhitespace'                 = $true
        <# PowerShell #>
        'powershell.codeFormatting.autoCorrectAliases' = $true
        'powershell.codeFormatting.useCorrectCasing'   = $true
        'powershell.codeFormatting.useConstantStrings' = $true
        '[powershell]'                                 = @{
            'files.encoding' = 'utf8bom'
        }
    }
    [PSCustomObject]$extensions = [PSCustomObject]@{
        'recommendations' = @(
            'ms-vscode.powershell'
        )
    }

    Install-MyVSCodeSettings -Settings $settings -Extensions $extensions
    Write-MySuccess -Message 'Added .\.vscode for PowerShell.'
}
