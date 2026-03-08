<#
.SYNOPSIS
Adds the VS Code settings for PowerShell development to the .vscode directory.
#>
function Install-MyVSCodeSettingsForPwsh {
    [OutputType([System.Void])]
    param ()

    [hashtable]$settings = @{
        <# General #>
        'editor.codeActionsOnSave'                     = @{
            'source.sort.json' = 'always'
        }
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
    [hashtable]$extensions = [hashtable]@{
        'recommendations' = @(
            'ms-vscode.powershell'
        )
    }

    Install-MyVSCodeSettings -Settings $settings -Extensions $extensions
}
