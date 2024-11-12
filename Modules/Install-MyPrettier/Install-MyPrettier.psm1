<#
.SYNOPSIS
Adds Prettier to the current directory.

.PARAMETER UsePug
Whether to support Pug.

.PARAMETER UseTailwindcss
Whether to support automatic class sorting of tailwindcss.
#>
function Install-MyPrettier {
    [OutputType([void])]
    param (
        [switch]$UsePug,
        [switch]$UseTailwindcss
    )

    [string[]]$neededDevPackages = @(
        'prettier'
    )

    if ($UsePug -or $UseTailwindcss) {
        [string]$prettierConfigPath = ''

        if ($UsePug -and $UseTailwindcss) {
            $neededDevPackages += @(
                '@prettier/plugin-pug'
                'prettier-plugin-tailwindcss'
            )
            $prettierConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'pug\prettier.tailwind.config.js'
        }
        elseif ($UsePug -and !$UseTailwindcss) {
            $neededDevPackages += @(
                '@prettier/plugin-pug'
            )
            $prettierConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'pug\prettier.config.js'
        }
        elseif (!$UsePug -and $UseTailwindcss) {
            $neededDevPackages += @(
                'prettier-plugin-tailwindcss'
            )
            $prettierConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'tailwind\prettier.config.js'
        }
        Copy-Item -LiteralPath $prettierConfigPath -Destination '.\prettier.config.js'

        git add '.\prettier.config.js'
    }
    Add-MyNpmScript -NameToScript @{
        'format' = 'prettier . --write'
    }
    pnpm add -D @neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add Prettier'
}
