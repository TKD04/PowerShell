<#
.SYNOPSIS
Adds Jest and its settings to the current directory.
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
    [string[]]$neededDevPackages = @(
        'jest'
        'ts-jest'
        '@jest/globals'
    )

    if ($UseBrowser) {
    }
    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath 'node\jest.config.cjs' |
        Copy-Item -Destination $jestConfigPath
    }
    else {
        Join-Path -Path $PSScriptRoot -ChildPath 'browser\jest.config.cjs' |
        Copy-Item -Destination $jestConfigPath
        $neededDevPackages += @(
            '@testing-library/dom'
            '@testing-library/jest-dom'
            'jest-environment-jsdom'
        )
        if ($UseReact) {
            $neededDevPackages += @(
                '@testing-library/react'
                '@testing-library/user-event'
            )
        }
    }
    Add-MyNpmScript -NameToScript @{
        'test' = 'jest'
    }
    pnpm add -D @neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json' $jestConfigPath
    git commit -m 'Add Jest'
}
