<#
.SYNOPSIS
Adds gulp.js to the current directory.

.PARAMETER UseTypeScript
Specifies whether to include TypeScript type definitions for gulp.js.
#>
function Install-MyGulp {
    [OutputType([System.Void])]
    param (
        [switch]$UseTypeScript
    )

    pnpm add -D gulp gulp-cli
    $null = New-Item -Path './gulpfile.mjs' -ItemType 'File'
    if ($UseTypeScript) {
        pnpm add -D @types/gulp
    }
    git add './package.json' './pnpm-lock.yaml' './gulpfile.mjs'
    git commit -m 'Add gulp'
}
