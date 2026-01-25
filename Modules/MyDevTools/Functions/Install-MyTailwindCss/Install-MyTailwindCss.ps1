<#
.SYNOPSIS
Adds Tailwind CSS to the current directory.

.PARAMETER IsVite
Whether to support a project created by Vite.
#>
function Install-MyTailwindCss {
    [OutputType([void])]
    param (
        [switch]$IsVite
    )

    [string[]]$devDependencies = @(
        'tailwindcss'
    )

    if ($IsVite) {
        $devDependencies += '@tailwindcss/vite'
    }
    else {
        $devDependencies += @(
            '@tailwindcss/postcss'
            'postcss'
            'postcss-load-config'
        )
        New-Item -Path '.\src' -ItemType 'Directory' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'common\postcss.config.mjs' |
        Copy-Item -Destination '.\postcss.config.mjs' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'common\style.css' |
        Copy-Item -Destination '.\src\style.css' -Force
        git add '.\postcss.config.mjs' '.\src\style.css'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Tailwind CSS'
}
