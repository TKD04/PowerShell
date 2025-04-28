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

    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add nodemon'
    Write-MySuccess -Message 'Added nodemon.'
}
