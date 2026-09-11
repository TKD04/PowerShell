<#
.SYNOPSIS
Initializes pnpm project in the current directory.
#>
function Initialize-PnpmProject {
    [OutputType([System.Void])]
    param()

    if (-not (Test-CommandExists -Command 'git')) {
        throw 'The command "git" was not found.'
    }
    if (-not (Test-CommandExists -Command 'corepack')) {
        throw 'The command "corepack" was not found.'
    }
    if (Test-StrictPath -LiteralPath './package.json') {
        throw 'Project already initialized.'
    }

    corepack prepare pnpm@latest --activate
    pnpm init
    [hashtable]$package = Import-Json -LiteralPath './package.json'
    $package['private'] = $true
    Export-Json -LiteralPath './package.json' -Hashtable $package
    git add .
    git commit -m 'chore: init pnpm project'
}

Set-Alias -Name 'pinit' -Value 'Initialize-PnpmProject'
