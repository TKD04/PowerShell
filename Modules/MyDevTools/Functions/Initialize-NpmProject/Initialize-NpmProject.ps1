<#
.SYNOPSIS
Initializes npm in the current directory.
#>
function Initialize-NpmProject {
    [OutputType([System.Void])]
    param()

    if ((Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    npm init -y
    # Remove automatically generated "test" npm script.
    [hashtable]$package = Import-Json -LiteralPath './package.json'
    $package['scripts'].Remove('test')
    Export-Json -LiteralPath './package.json' -Hashtable $package

    git add './package.json'
    git commit -m 'Initialize npm'

    corepack use pnpm@latest
    git add './.npmrc' './package.json'
    git commit -m 'Add pnpm as packageManager'
}

Set-Alias -Name 'ninit' -Value 'Initialize-NpmProject'
