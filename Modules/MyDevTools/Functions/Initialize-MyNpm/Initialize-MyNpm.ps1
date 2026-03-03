<#
.SYNOPSIS
Initializes npm in the current directory.
#>
function Initialize-MyNpm {
    [OutputType([System.Void])]
    param()

    npm init -y
    # Remove `test` in npm scripts which is generated automatically
    [hashtable]$package = Import-MyJSON -LiteralPath './package.json'
    $package['scripts'].Remove('test')
    Export-MyJSON -LiteralPath './package.json' -Hashtable $package

    git add './package.json'
    git commit -m 'Initialize npm'
    if ((Test-MyCommandExists -Command 'pnpm')) {
        corepack use pnpm@latest
        git add './.npmrc' './package.json'
        git commit -m 'Add pnpm as packageManager'
    }
    else {
        throw 'The command "pnpm" was not found.'
    }
}

Set-Alias -Name 'ninit' -Value 'Initialize-MyNpm'
