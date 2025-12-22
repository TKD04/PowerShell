<#
.SYNOPSIS
Adds nodemon to the current directory.
#>
function Install-MyNodemon {
    [OutputType([void])]
    param()

    Add-MyNpmScript -NameToScript @{
        'watch' = 'nodemon --watch src/**/*.ts --exec ts-node src/app.ts'
    }
    pnpm add -D nodemon
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add nodemon'
}
