<#
.SYNOPSIS
Adds Prettier to the current directory.

.PARAMETER UseTailwindcss
Whether to support automatic class sorting of tailwindcss.
#>
function Install-MyPrettier {
    [OutputType([void])]
    param (
        [switch]$UseTailwindcss
    )

    [string[]]$devDependencies = @(
        'prettier'
    )

    if ($UseTailwindcss) {
        $devDependencies += @(
            'prettier-plugin-tailwindcss'
        )
        Join-Path -Path $PSScriptRoot -ChildPath 'common\prettier-tailwindcss.config.mjs' |
        Copy-Item -LiteralPath $prettierConfigPath -Destination '.\prettier.config.mjs'
        git add '.\prettier.config.mjs'
    }
    Add-MyNpmScript -NameToScript @{
        'format' = 'prettier . --write'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Prettier'
}
