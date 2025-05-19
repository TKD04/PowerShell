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
        'postcss'
        'autoprefixer'
    )
    [string]$dirName = 'common'

    if ($IsVite) {
        $dirName = 'vite'
    }
    Join-Path -Path $PSScriptRoot -ChildPath "\$dirName\tailwind.config.js" |
    Copy-Item -Destination '.\tailwind.config.js' -Force
    Join-Path -Path $PSScriptRoot -ChildPath 'common\index.css'
    Copy-Item -Destination '.\src\index.css' -Force
    Join-Path -Path $PSScriptRoot -ChildPath 'common\postcss.config.js'
    Copy-Item -Destination '.\postcss.config.js'
    # https://tailwindcss.com/docs/optimizing-for-production
    $devDependencies += 'cssnano'
    pnpm add -D @devDependencies
    git add '.\pnpm-lock.yaml' '.\package.json' '.\tailwind.config.js' '.\postcss.config.js' '.\src\index.css'
    git commit -m 'Add Tailwind CSS'
    Write-MySuccess -Message 'Added Tailwind CSS.'
}
