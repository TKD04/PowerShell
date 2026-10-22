<#
.SYNOPSIS
Initializes pnpm project in the current directory.
#>
function Initialize-PnpmProject {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param()

    if (-not (Test-CommandExists -Command 'git')) {
        throw 'The command "git" does not exist.'
    }
    if (-not (Test-CommandExists -Command 'corepack')) {
        throw 'The command "corepack" does not exist.'
    }
    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" does not exist.'
    }
    if (-not (Test-StrictPath -LiteralPath './.git' -PathType 'Container')) {
        throw 'Git repository must be initialized.'
    }
    if (Test-StrictPath -LiteralPath './package.json') {
        throw 'Project already initialized.'
    }

    if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, 'Initialize pnpm project')) {
        corepack prepare pnpm@latest --activate
        pnpm init
        [hashtable]$package = Import-Json -LiteralPath './package.json'
        $package['private'] = $true
        Export-Json -LiteralPath './package.json' -Hashtable $package
        git add .
        git commit -m 'chore: init pnpm project'
    }
}

Set-Alias -Name 'pinit' -Value 'Initialize-PnpmProject'
