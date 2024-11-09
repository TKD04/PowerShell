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
    npm i -D typedoc

    git add '.\package-lock.json' '.\package.json'
    git commit -m 'Add TypeDoc'
}
