<#
.SYNOPSIS
Adds the VSCode settings for Python to the current directory.
#>
function Install-MyVSCodeSettingsForPython {
    [OutputType([void])]
    param ()

    [PSCustomObject]$settings = [PSCustomObject]@{
        <# General #>
        'editor.formatOnSave'                   = $true
        'files.autoGuessEncoding'               = $true
        'files.insertFinalNewline'              = $true
        'files.trimFinalNewlines'               = $true
        'files.trimTrailingWhitespace'          = $true
        <# Python #>
        'python.analysis.typeCheckingMode'      = 'strict'
        'python.analysis.autoImportCompletions' = $true
        <# flake8 #>
        'python.linting.flake8Enabled'          = $true
        'python.linting.flake8Args'             = @(
            '--max-line-length=88',
            '--ignore=E203,W503,W504'
        )
        <# black #>
        'python.formatting.provider'            = 'none'
        '[python]'                              = @{
            'editor.defaultFormatter' = 'ms-python.black-formatter'
        }
        <# isort #>
        'isort.check'                           = $true
        'isort.args'                            = @(
            # https://github.com/microsoft/vscode-isort/issues/263#issuecomment-1502317376
            '--profile'
            'black'
        )
        'editor.codeActionsOnSave'              = @{
            'source.organizeImports' = $true
        }
        <# mypy #>
        'python.linting.mypyEnabled'            = $true
        'python.linting.mypyArgs'               = @(
            '--follow-imports=silent'
            '--ignore-missing-imports'
            '--show-column-numbers'
            '--no-pretty'
            '--warn-return-any'
            '--no-implicit-optional'
            '--disallow-untyped-calls'
            '--disallow-untyped-defs'
        )
    }
    [PSCustomObject]$extensions = [PSCustomObject]@{
        'recommendations' = @(
            'ms-python.python'
            'ms-python.flake8'
            'ms-python.black-formatter'
            'ms-python.isort'
            'ms-python.mypy-type-checker'
        )
    }

    Install-MyVSCodeSettings -Settings $settings -Extensions $extensions
    Write-MySuccess -Message 'Added .\.vscode for Python.'
}
