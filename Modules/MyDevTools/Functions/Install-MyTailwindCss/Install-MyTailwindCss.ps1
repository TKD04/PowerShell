<#
.SYNOPSIS
Adds Tailwind CSS to the current directory.

.PARAMETER IsVite
Whether to support a project created by Vite.
#>
function Install-MyTailwindCss {
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
        $null = New-Item -Path '.\src' -ItemType 'Directory' -Force
        Copy-MyScriptRootItem -ChildPath 'common\postcss.config.mjs' -Destination '.\postcss.config.mjs' -Force
        Copy-MyScriptRootItem -ChildPath 'common\style.css' -Destination '.\src\style.css' -Force
        git add '.\postcss.config.mjs' '.\src\style.css'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Tailwind CSS'
}
