<#
.SYNOPSIS
Adds VS Code settings and extensions for the specified environment to the .vscode directory.

.PARAMETER Environment
Specifies the target environment:
- Frontend
- PowerShell
#>
function Initialize-VsCodeSetting {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Frontend', 'PowerShell')]
        [string]$Environment
    )

    [string]$vscodeDirectoryFullName = Join-Path -Path $PWD.ProviderPath -ChildPath '.vscode'
    [string]$settingsJsonFullName = Join-Path -Path $vscodeDirectoryFullName -ChildPath 'settings.json'
    [string]$extensionsJsonFullName = Join-Path -Path $vscodeDirectoryFullName -ChildPath 'extensions.json'
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

    if (Test-StrictPath -LiteralPath $settingsJsonFullName -PathType 'Leaf') {
        throw 'VS Code settings is already in place.'
    }
    if (Test-StrictPath -LiteralPath $extensionsJsonFullName -PathType 'Leaf') {
        throw 'VS Code recommended extensions is already in place.'
    }

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
                'editor.defaultFormatter'                     = 'oxc.oxc-vscode'
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
                    'oxc.oxc-vscode'
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
    if ($PSCmdlet.ShouldProcess($vscodeDirectoryFullName, 'Initialize VS Code settings')) {
        $null = New-Item -Path $vscodeDirectoryFullName -ItemType 'Directory' -Force
        if ($null -ne $settings) {
            Export-Json -LiteralPath $settingsJsonFullName -Hashtable $settings -WhatIf $false
        }
        if ($null -ne $extensions) {
            Export-Json -LiteralPath $extensionsJsonFullName -Hashtable $extensions -WhatIf $false
        }
    }
}
