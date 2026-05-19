<#
.SYNOPSIS
Initializes pnpm project in the current directory.
#>
function Initialize-PnpmProject {
    [OutputType([System.Void])]
    param()

    if (-not (Test-CommandExists -Command 'corepack')) {
        throw 'The command "corepack" was not found.'
    }
    if (Test-StrictPath -LiteralPath './package.json') {
        throw 'Project already initialized.'
    }

    [hashtable]$package = @{
        private = $true
    }

    Export-Json -LiteralPath './package.json' -Hashtable $package
    corepack use pnpm@latest
    git add './package.json'
    if (Test-StrictPath -LiteralPath './pnpm-lock.yaml') {
        git add './pnpm-lock.yaml'
    }
    git commit -m 'chore: init pnpm project'
}

Set-Alias -Name 'pinit' -Value 'Initialize-PnpmProject'
