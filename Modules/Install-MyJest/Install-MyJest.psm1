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
        [string]$SrcJestConfigPath = Join-Path -Path $PSScriptRoot -ChildPath '.\ts.browser.jest.config.js'
        Copy-Item -LiteralPath $SrcJestConfigPath -Destination $jestConfigPath
        $neededDevPackages += 'jest-environment-jsdom'
    }
    if ($UseNode) {
        [string]$SrcJestConfigPath = Join-Path -Path $PSScriptRoot -ChildPath '.\ts.node.jest.config.js'
        Copy-Item -LiteralPath $SrcJestConfigPath -Destination $jestConfigPath
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
    npm i -D $neededDevPackages

    git add '.\package-lock.json' '.\package.json' $jestConfigPath
    git commit -m 'Add Jest'
}
