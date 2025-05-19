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
        Join-Path -Path $PSScriptRoot -ChildPath 'common\prettier-tailwindcss.config.js' |
        Copy-Item -LiteralPath $prettierConfigPath -Destination '.\prettier.config.js'

        git add '.\prettier.config.js'
    }
    Add-MyNpmScript -NameToScript @{
        'format' = 'prettier . --write'
    }
    pnpm add -D @devDependencies
    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add Prettier'
    Write-MySuccess -Message 'Added Prettier and its npm script "format".'
}
