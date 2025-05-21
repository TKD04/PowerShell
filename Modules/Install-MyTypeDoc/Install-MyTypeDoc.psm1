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
    git add '.\pnpm-lock.yaml' '.\package.json'
    git commit -m 'Add TypeDoc'
}
