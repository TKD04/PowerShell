<#
.SYNOPSIS
Adds TypeDoc to the current directory and creates a "docs" npm script.
#>
function Install-TypeDoc {
    [OutputType([System.Void])]
    param ()

    Add-NpmScript -NameToScript @{
        'docs' = 'typedoc --out docs --entryPointStrategy expand src'
    }
    pnpm add -D typedoc
    git add './package.json' './pnpm-lock.yaml'
    git commit -m 'Add TypeDoc'
}
