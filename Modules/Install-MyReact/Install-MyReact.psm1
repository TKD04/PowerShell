<#
.SYNOPSIS
Adds React to the current directory.
#>
function Install-MyReact {
    [OutputType([void])]
    param ()

    [string[]]$neededPackages = @(
        'react'
        'react-dom'
    )
    [string[]]$neededDevPackages = @(
        '@types/react'
        '@types/react-dom'
    )

    pnpm i $neededPackages
    pnpm i -D $neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add React'
}
