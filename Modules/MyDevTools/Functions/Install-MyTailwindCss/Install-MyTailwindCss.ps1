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
    [bool]$isViteReact = $IsVite -and (Test-MyStrictPath -LiteralPath '.\tsconfig.app.json' -PathType Leaf)

    <# Vite with React #>
    if ($isViteReact) {
        $devDependencies += '@tailwindcss/vite'
        Join-Path -Path $PSScriptRoot -ChildPath 'common\vite-react.config.ts' |
        Copy-Item -Destination '.\vite.config.ts' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'common\vite-react-index.css' |
        Copy-Item -Destination '.\src\index.css' -Force
        git add '.\vite.config.ts' '.\src\index.css'
    }
    <# Vite #>
    elseif ($IsVite) {
        $devDependencies += '@tailwindcss/vite'
        Join-Path -Path $PSScriptRoot -ChildPath 'common\vite.config.mjs' |
        Copy-Item -Destination '.\vite.config.mjs' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'common\vite-style.css' |
        Copy-Item -Destination '.\src\style.css' -Force
        git add '.\vite.config.mjs' '.\src\style.css'
    }
    <# No framework #>
    else {
        $devDependencies += @(
            '@tailwindcss/postcss'
            'postcss'
        )
        New-Item -Path '.\' -Name 'src' -ItemType 'Directory' -Force
        Join-Path -Path $PSScriptRoot -ChildPath 'common\postcss.config.mjs' |
        Copy-Item -Destination '.\postcss.config.mjs'
        Join-Path -Path $PSScriptRoot -ChildPath 'common\no-framework-style.css' |
        Copy-Item -Destination '.\src\style.css' -Force
        git add '.\postcss.config.mjs' '.\src\style.css'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Tailwind CSS'
}
