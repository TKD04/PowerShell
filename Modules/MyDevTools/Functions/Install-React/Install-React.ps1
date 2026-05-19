<#
.SYNOPSIS
Adds React and React DOM to the current directory.
#>
function Install-React {
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
}
