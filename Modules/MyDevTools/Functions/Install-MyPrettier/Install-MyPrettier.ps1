<#
.SYNOPSIS
Adds Prettier to the current directory.

.PARAMETER UseTailwindcss
Whether to support automatic class sorting of tailwindcss.
#>
function Install-MyPrettier {
    [OutputType([System.Void])]
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
        Copy-MyScriptRootItem -ChildPath 'common\prettier-tailwindcss.config.mjs' -Destination '.\prettier.config.mjs' -Force
        git add '.\prettier.config.mjs'
    }
    Add-MyNpmScript -NameToScript @{
        'format' = 'prettier . --write'
    }
    pnpm add -D @devDependencies
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add Prettier'
}
