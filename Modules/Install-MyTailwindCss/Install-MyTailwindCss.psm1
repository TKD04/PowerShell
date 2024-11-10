<#
.SYNOPSIS
Adds Tailwind CSS to the current directory.

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

    if ($IsVite -and $IsNextJs) {
        throw 'Only enable either $IsVite or $IsNextJs'
    }

    [string[]]$neededDevPackages = @(
        'tailwindcss'
        'postcss'
        'autoprefixer'
        '@tailwindcss/typography'
        '@tailwindcss/forms'
    )

    if ($IsNextJs) {
        pnpm i -D @tailwindcss/typography
        if ($UseDaisyUi) {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind-nextjs-daisyui.config.ts" -Destination '.\tailwind.config.ts' -Force
        }
        else {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind-nextjs.config.ts" -Destination '.\tailwind.config.ts' -Force
        }

        git add '.\pnpm-lock.yaml' '.\package.json' '.\tailwind.config.ts'
        git commit -m 'Add `@tailwindcss/typography`'

        return
    }
    if ($IsVite) {
        if ($UseDaisyUi) {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind-vite-daisyui.config.js" -Destination '.\tailwind.config.js' -Force
        }
        else {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind-vite.config.js" -Destination '.\tailwind.config.js' -Force

        }
        Copy-Item -LiteralPath "$PSScriptRoot\index-vite.css" -Destination '.\src\index.css' -Force

        git add '.\src\index.css'
    }
    else {
        if ($UseDaisyUi) {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind-daisyui.config.js" -Destination '.\tailwind.config.js' -Force
        }
        else {
            Copy-Item -LiteralPath "$PSScriptRoot\tailwind.config.js" -Destination '.\tailwind.config.js' -Force
        }
        Copy-Item -LiteralPath "$PSScriptRoot\index.css" -Destination '.\index.css' -Force

        git add '.\index.css'
    }
    # https://tailwindcss.com/docs/optimizing-for-production
    $neededDevPackages += 'cssnano'
    if ($UseDaisyUi) {
        $neededDevPackages += 'daisyui'
    }
    Copy-Item -LiteralPath "$PSScriptRoot\postcss.config.js" -Destination '.\postcss.config.js'
    pnpm i -D $neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json' '.\tailwind.config.js' '.\postcss.config.js'
    git commit -m 'Add Tailwind CSS'
}
