<#
.SYNOPSIS
Adds nodemon to the current directory and sets up a "watch" npm script for TypeScript files.
#>
function Install-MyNodemon {
    [OutputType([System.Void])]
    param()

    Add-MyNpmScript -NameToScript @{
        'watch' = 'nodemon --watch src/**/*.ts --exec ts-node src/app.ts'
    }
    pnpm add -D nodemon
    git add './package.json' './pnpm-lock.yaml'
    git commit -m 'Add nodemon'
}
