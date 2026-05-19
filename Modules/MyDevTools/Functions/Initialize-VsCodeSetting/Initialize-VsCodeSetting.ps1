<#
.SYNOPSIS
Adds VS Code settings and extensions for the specified environment to the .vscode directory.

.PARAMETER Environment
Specifies the target environment:
- Frontend
- PowerShell
#>
function Initialize-VsCodeSetting {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Frontend', 'PowerShell')]
        [string]$Environment
    )

    if (Test-StrictPath -LiteralPath './.vscode/settings.json' -PathType 'Leaf') {
        throw 'VS Code settings is already in place.'
    }
    if (Test-StrictPath -LiteralPath './.vscode/extensions.json' -PathType 'Leaf') {
        throw 'VS Code recommended extensions is already in place.'
    }

    [hashtable]$settings = @{
        <# General #>
        'editor.codeActionsOnSave'     = @{
            'source.sort.json' = 'always'
        }
        'editor.formatOnSave'          = $true
        'files.autoGuessEncoding'      = $true
        'files.insertFinalNewline'     = $true
        'files.trimFinalNewlines'      = $true
        'files.trimTrailingWhitespace' = $true
        <# Markdown #>
        '[markdown]'                   = @{
            'files.trimTrailingWhitespace' = $false
        }
    }
    [hashtable]$extensions = $null

    switch ($Environment) {
        'Frontend' {
            <# General #>
            $settings['editor.codeActionsOnSave'] = @{
                'source.addMissingImports.ts' = 'always'
                'source.removeUnused.ts'      = 'always'
                'source.removeUnusedImports'  = 'always'
                'source.sort.json'            = 'always'
            }
            $settings += @{
                <# Web #>
                'editor.defaultFormatter'                     = 'esbenp.prettier-vscode'
                'editor.tabSize'                              = 2
                <# HTML #>
                'editor.linkedEditing'                        = $true
                <# TypeScript/JavaScript #>
                'js/ts.preferences.preferTypeOnlyAutoImports' = $true
                'js/ts.updateImportsOnFileMove.enabled'       = 'always'
            }
            $extensions = @{
                'recommendations' = @(
                    'dbaeumer.vscode-eslint'
                    'esbenp.prettier-vscode'
                )
            }
        }
        'PowerShell' {
            $settings += @{
                <# PowerShell #>
                'powershell.codeFormatting.autoCorrectAliases' = $true
                'powershell.codeFormatting.useCorrectCasing'   = $true
                'powershell.codeFormatting.useConstantStrings' = $true
                '[powershell]'                                 = @{
                    'files.encoding' = 'utf8bom'
                }
            }
            $extensions = @{
                'recommendations' = @(
                    'ms-vscode.powershell'
                )
            }
        }
    }
    $null = New-Item -Path './.vscode' -ItemType 'Directory' -Force
    if ($null -ne $settings) {
        Export-Json -LiteralPath './.vscode/settings.json' -Hashtable $settings
    }
    if ($null -ne $extensions) {
        Export-Json -LiteralPath './.vscode/extensions.json' -Hashtable $extensions
    }
}
