<#
.SYNOPSIS
Adds Vitest to the current directory and creates npm scripts for running tests and coverage.
#>
function Install-Vitest {
    [OutputType([System.Void])]
    param()

    [string[]]$devDependencies = @(
        '@vitest/coverage-v8'
        'vitest'
    )

    Add-NpmScript -NameToScript @{
        'test'     = 'vitest'
        'coverage' = 'vitest run --coverage'
    }
    pnpm add -D @devDependencies
    git add './package.json' './pnpm-lock.yaml'
    git commit -m 'Add Vitest'
}
