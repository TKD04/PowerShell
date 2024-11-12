<#
.SYNOPSIS
Adds Jest and its settings to the current directory.

.PARAMETER UseBrowser
Whether to support browser (dom).

.PARAMETER UseNode
Whether to support Node.

.PARAMETER UseReact
Whether to support React.
#>
function Install-MyJest {
    [OutputType([void])]
    param(
        [switch]$UseBrowser,
        [switch]$UseNode,
        [switch]$UseReact
    )

    if (($UseBrowser -and $UseNode) -or !($UseBrowser -or $UseNode) ) {
        throw 'Only enable either $UserBrowser or $UseNode'
    }

    [string]$jestConfigPath = '.\jest.config.js'
    [string[]]$neededDevPackages = @(
        'jest'
        'ts-jest'
        '@types/jest'
    )

    if ($UseBrowser) {
        Join-Path -Path $PSScriptRoot -ChildPath 'browser\jest.ts.config.js' |
        Copy-Item -Destination $jestConfigPath
        $neededDevPackages += 'jest-environment-jsdom'
    }
    if ($UseNode) {
        Join-Path -Path $PSScriptRoot -ChildPath 'node\jest.ts.config.js' |
        Copy-Item -Destination $jestConfigPath
    }
    if ($UseReact) {
        $neededDevPackages += @(
            '@testing-library/dom'
            '@testing-library/jest-dom'
            '@testing-library/react'
            '@testing-library/user-event'
        )
    }
    Add-MyNpmScript -NameToScript @{
        'test' = 'jest'
    }
    pnpm add -D $neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json' $jestConfigPath
    git commit -m 'Add Jest'
}
