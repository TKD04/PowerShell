<#
.SYNOPSIS
Adds Tailwind CSS to the current dirNameectory.

.PARAMETER IsVite
Whether to support a project created by Vite.

.PARAMETER IsNextJs
Whether to support a project created by NextJS.

.PARAMETER UseDaisyUi
Whether to support daisyUI
#>
function Install-MyTailwindCss {
    [OutputType([void])]
    param (
        [switch]$IsVite,
        [switch]$IsNextJs,
        [switch]$UseDaisyUi
    )

    [string[]]$devDependencies = @(
        'tailwindcss'
        'postcss'
        'autoprefixer'
        '@tailwindcss/typography'
        '@tailwindcss/forms'
    )
    [string]$dirName = 'common'

    if ($IsVite -and $IsNextJs) {
        throw 'Only enable either $IsVite or $IsNextJs'
    }

    if ($IsVite) {
        $dirName = 'vite'
    }
    if ($IsNextJs) {
        # Tailwind CSS is already installed on Next.js project.
        pnpm add -D @tailwindcss/typography
        if ($UseDaisyUi) {
            Join-Path -Path $PSScriptRoot -ChildPath 'nextjs\tailwind.daisyui.config.ts' |
            Copy-Item -Destination '.\tailwind.config.ts' -Force
        }
        else {
            Join-Path -Path $PSScriptRoot -ChildPath 'nextjs\tailwind.config.ts' |
            Copy-Item -Destination '.\tailwind.config.ts' -Force
        }

        git add '.\pnpm-lock.yaml' '.\package.json' '.\tailwind.config.ts'
        git commit -m 'Add `@tailwindcss/typography`'

        return
    }
    if ($UseDaisyUi) {
        Join-Path -Path $PSScriptRoot -ChildPath "\$dirName\tailwind.daisyui.config.js" |
        Copy-Item -Destination '.\tailwind.config.js' -Force
    }
    else {
        Join-Path -Path $PSScriptRoot -ChildPath "\$dirName\tailwind.config.js" |
        Copy-Item -Destination '.\tailwind.config.js' -Force
    }
    Join-Path -Path $PSScriptRoot -ChildPath 'common\index.css'
    Copy-Item -Destination '.\src\index.css' -Force
    Join-Path -Path $PSScriptRoot -ChildPath 'common\postcss.config.js'
    Copy-Item -Destination '.\postcss.config.js'
    # https://tailwindcss.com/docs/optimizing-for-production
    $devDependencies += 'cssnano'
    if ($UseDaisyUi) {
        $devDependencies += 'daisyui'
    }
    pnpm add -D @devDependencies

    git add '.\pnpm-lock.yaml' '.\package.json' '.\tailwind.config.js' '.\postcss.config.js' '.\src\index.css'
    git commit -m 'Add Tailwind CSS'
}
