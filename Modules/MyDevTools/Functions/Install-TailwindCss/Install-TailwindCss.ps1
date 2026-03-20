<#
.SYNOPSIS
Adds Tailwind CSS to the current directory.

.PARAMETER IsVite
Specifies whether the project uses Vite.
#>
function Install-TailwindCss {
    [OutputType([System.Void])]
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
        $null = New-Item -Path './src' -ItemType 'Directory' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/postcss.config.mjs' |
        Copy-Item -Destination './postcss.config.mjs' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/style.css' |
        Copy-Item -Destination './src/style.css' -Force
        git add './postcss.config.mjs' './src/style.css'
    }
    pnpm add -D @devDependencies
    git add './package.json' './pnpm-lock.yaml'
    git commit -m 'Add Tailwind CSS'
}
