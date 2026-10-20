<#
.SYNOPSIS
Adds Vitest to the current directory and creates npm scripts for running tests and coverage.
#>
function Install-Vitest {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param()

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    [string[]]$devDependencies = @(
        '@vitest/coverage-v8'
        'vitest'
    )

    if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, 'Install Vitest')) {
        Add-NpmScript -NameToScript @{
            'test'     = 'vitest'
            'coverage' = 'vitest run --coverage'
        } -WhatIf $false
        pnpm add -D @devDependencies
    }
}
