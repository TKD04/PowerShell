<#
.SYNOPSIS
Adds Vitest to the current directory.
It installs the browser settings by default.

.PARAMETER UseNode
Whether to support Node.

.PARAMETER UseReact
Whether to support React.
#>
function Install-MyJest {
    [OutputType([void])]
    param(
        [switch]$UseNode,
        [switch]$UseReact
    )

    if (($UseNode -and $UseReact)) {
        throw 'Only enable either $UseNode or $UseReact'
    }

    [string]$jestConfigPath = '.\jest.config.cjs'
    [string[]]$devDependencies = @(
        'vitest'
    )

    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath 'node\jest-ts.config.cjs' |
        Copy-Item -Destination $jestConfigPath
    }
    else {
        Join-Path -Path $PSScriptRoot -ChildPath 'browser\jest-ts.config.cjs' |
        Copy-Item -Destination $jestConfigPath
        $devDependencies += @(
            '@testing-library/dom'
            '@testing-library/jest-dom'
            'jest-environment-jsdom'
        )
        if ($UseReact) {
            $devDependencies += @(
                '@testing-library/react'
                '@testing-library/user-event'
            )
        }
    }
    Add-MyNpmScript -NameToScript @{
        'test' = 'vitest'
    }
    pnpm add -D @devDependencies

    git add '.\pnpm-lock.yaml' '.\package.json' $jestConfigPath
    git commit -m 'Add Vitest'
    Write-MySuccess -Message 'Added Vitest and its npm script "test" and "coverage".'
}
