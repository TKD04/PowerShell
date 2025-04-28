<#
.SYNOPSIS
Adds gulp to the current directory.

.PARAMETER UseTypeScript
Whether to add the rules for TypeScript.
#>
function Install-MyGulp {
    [OutputType([void])]
    param (
        [switch]$UseTypeScript
    )

    pnpm add -D gulp gulp-cli
    New-Item -Path '.\' -Name 'gulpfile.mjs' -ItemType 'File'
    if ($UseTypeScript) {
        pnpm add -D @types/gulp
    }

    git add '.\pnpm-lock.yaml' '.\package.json' '.\gulpfile.mjs'
    git commit -m 'Add gulp'
}
