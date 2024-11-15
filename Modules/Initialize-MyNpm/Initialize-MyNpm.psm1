<#
.SYNOPSIS
Initializes npm in the current directory.
#>
function Initialize-MyNpm {
    [Alias('ninit')]
    [OutputType([void])]
    param()

    npm init -y
    <# Remove `test` in npm scripts which is generated automatically #>
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    $package.scripts.Remove('test')
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
    Add-Content -LiteralPath '.\.gitignore' -Value @(
        'node_modules/'
        'dist/'
    )

    git add '.\.gitignore' '.\package.json'
    git commit -m 'Add npm'

    pnpm

    git add '.\package.json'
    git commit -m 'Add pnpm as packageManager'
}
