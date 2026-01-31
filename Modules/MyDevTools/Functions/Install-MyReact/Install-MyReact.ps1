<#
.SYNOPSIS
Adds React to the current directory.
#>
function Install-MyReact {
    [OutputType([System.Void])]
    param ()

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
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add React'
}
