<#
.SYNOPSIS
Adds the VS Code settings for web development to the .vscode directory.
#>
function Install-MyVSCodeSettingsForWeb {
    [OutputType([System.Void])]
    param ()

    [hashtable]$settings = @{
        <# General #>
        'editor.codeActionsOnSave'                   = @{
            'source.addMissingImports.ts' = 'always'
            'source.removeUnused.ts'      = 'always'
            'source.removeUnusedImports'  = 'always'
            'source.sort.json'            = 'always'
        }
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

    Install-MyVSCodeSettings -Settings $settings
}
