<#
.SYNOPSIS
Adds Prettier to the current directory.

.PARAMETER UseTailwindCSS
Specifies whether to enable automatic class sorting for Tailwind CSS.
#>
function Install-Prettier {
    [OutputType([System.Void])]
    param (
        [switch]$UseTailwindCss
    )

    [string[]]$devDependencies = @(
        'prettier'
    )

    if ($UseTailwindCss) {
        $devDependencies += @(
            'prettier-plugin-tailwindcss'
        )
        Join-Path -Path $PSScriptRoot -ChildPath 'common/prettier-tailwindcss.config.mjs' |
        Copy-Item -Destination './prettier.config.mjs' -Force
        git add './prettier.config.mjs'
    }
    Add-NpmScript -NameToScript @{
        'format' = 'prettier . --write'
    }
    pnpm add -D @devDependencies
    git add './package.json' './pnpm-lock.yaml'
    git commit -m 'Add Prettier'
}
