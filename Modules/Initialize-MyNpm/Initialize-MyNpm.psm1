<#
.SYNOPSIS
Initializes npm in the current directory.
#>
function Initialize-MyNpm {
    [Alias('ninit')]
    [OutputType([void])]
    param()

    npm init -y
    # Remove `test` in npm scripts which is generated automatically
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    $package.scripts.Remove('test')
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package

    git add '.\package.json'
    git commit -m 'Initialize npm'
    if ((Test-MyCommandExists -Command 'pnpm')) {
        # https://eslint.org/docs/latest/use/getting-started#manual-set-up
        Join-Path -Path $PSScriptRoot -ChildPath 'common\.npmrc' |
        Copy-Item -Destination '.\.npmrc'
        pnpm
        git add '.\.npmrc' '.\package.json'
        git commit -m 'Add pnpm as packageManager'
    }
    else {
        throw 'A command "pnpm" could not be found. You can install pnpm by using the command "corepack enable pnpm".'
    }
}
