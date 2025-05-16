<#
.SYNOPSIS
Adds the VSCode settings for Web to the current directory.
#>
function Install-MyVSCodeSettingsForWeb {
    [OutputType([void])]
    param ()

    [PSCustomObject]$settings = [PSCustomObject]@{
        <# General #>
        'editor.formatOnSave'                        = $true
        'files.autoGuessEncoding'                    = $true
        'files.insertFinalNewline'                   = $true
        'files.trimFinalNewlines'                    = $true
        'files.trimTrailingWhitespace'               = $true
        <# Web #>
        'editor.defaultFormatter'                    = 'esbenp.prettier-vscode'
        'editor.tabSize'                             = 2
        <# HTML #>
        'editor.linkedEditing'                       = $true
        <# TypeScript/JavaScript #>
        'javascript.updateImportsOnFileMove.enabled' = 'always'
        'typescript.updateImportsOnFileMove.enabled' = 'always'
        <# Markdown #>
        '[markdown]'                                 = @{
            'files.trimTrailingWhitespace' = $false
        }
    }
    [PSCustomObject]$extensions = [PSCustomObject]@{
        'recommendations' = @(
            'dbaeumer.vscode-eslint'
            'esbenp.prettier-vscode'
        )
    }

    Install-MyVSCodeSettings -Settings $settings -Extensions $extensions
    Write-MySuccess -Message 'Added .\.vscode for web.'
}
