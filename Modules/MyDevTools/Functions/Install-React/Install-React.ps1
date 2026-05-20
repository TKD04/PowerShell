<#
.SYNOPSIS
Adds React and React DOM to the current directory.
#>
function Install-React {
    [OutputType([System.Void])]
    param ()

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    [string[]]$dependencies = @(
        'react'
        'react-dom'
    )
    [string[]]$devDependencies = @(
        '@types/react'
        '@types/react-dom'
    )

    pnpm add @dependencies
    pnpm add -D @devDependencies
}
