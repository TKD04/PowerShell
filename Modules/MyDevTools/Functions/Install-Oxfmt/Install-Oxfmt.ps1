<#
.SYNOPSIS
Adds Oxfmt to the current directory.

.PARAMETER UseTailwindCss
Specifies whether to enable automatic class sorting for Tailwind CSS.
#>
function Install-Oxfmt {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param (
        [switch]$UseTailwindCss
    )

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" does not exist.'
    }

    [string[]]$devDependencies = @(
        'oxfmt'
    )
    [string]$templateFile = $UseTailwindCss ? '.oxfmtrc-tailwindcss.json' : '.oxfmtrc.json'

    if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, 'Install Oxfmt')) {
        Join-Path -Path $PSScriptRoot -ChildPath "templates/$templateFile" |
        Copy-Item -Destination './.oxfmtrc.json' -Force
        Add-NpmScript -NameToScript @{
            'format' = 'oxfmt'
        } -WhatIf $false
        pnpm add -D @devDependencies
    }
}
