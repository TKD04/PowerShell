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
    [string[]]$devDependencies = @(
        '@types/react'
        '@types/react-dom'
    )

    pnpm add @neededPackages
    pnpm add -D @devDependencies

    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add React'
    Write-MySuccess -Message 'Added React and its @types.'
}
