<#
.SYNOPSIS
Adds React and React DOM to the current directory.
#>
function Install-React {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    param ()

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" does not exist.'
    }

    [string[]]$dependencies = @(
        'react'
        'react-dom'
    )
    [string[]]$devDependencies = @(
        '@types/react'
        '@types/react-dom'
    )

    if ($PSCmdlet.ShouldProcess($PWD.ProviderPath, 'Install React')) {
        pnpm add @dependencies
        pnpm add -D @devDependencies

    }
}
