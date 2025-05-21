<#
.SYNOPSIS
Adds React to the current directory.
#>
function Install-MyReact {
    [OutputType([void])]
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
    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add React'
}
