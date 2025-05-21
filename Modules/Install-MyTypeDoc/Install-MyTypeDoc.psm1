<#
.SYNOPSIS
Adds TypeDoc to the current directory.
#>
function Install-MyTypeDoc {
    [OutputType([void])]
    param ()

    Add-MyNpmScript -NameToScript @{
        'docs' = 'typedoc --out docs --entryPointStrategy expand src'
    }
    pnpm add -D typedoc
    git add '.\package.json' '.\pnpm-lock.yaml'
    git commit -m 'Add TypeDoc'
}
