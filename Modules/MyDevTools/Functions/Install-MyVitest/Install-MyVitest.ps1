<#
.SYNOPSIS
Adds Vitest to the current directory.
#>
function Install-MyVitest {
    [OutputType([void])]
    param()

    [string[]]$devDependencies = @(
        '@vitest/coverage-v8'
        'vitest'
    )

    Add-MyNpmScript -NameToScript @{
        'test'     = 'vitest'
        'coverage' = 'vitest run --coverage'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Vitest'
}
