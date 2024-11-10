<#
.SYNOPSIS
Adds some needed packages to a Next.js project.

.PARAMETER UseDaisyUi
Whether to support daisyUI
#>
function Add-MyPackagesToNextJs {
    [OutputType([void])]
    param (
        [switch]$UseDaisyUi
    )

    [hashtable]$missingCompilerOptions = @{
        'allowUnreachableCode'               = $false
        'allowUnusedLabels'                  = $false
        'exactOptionalPropertyTypes'         = $true
        'noFallthroughCasesInSwitch'         = $true
        'noImplicitOverride'                 = $true
        'noImplicitReturns'                  = $true
        'noPropertyAccessFromIndexSignature' = $true
        'noUncheckedIndexedAccess'           = $true
        'noUnusedLocals'                     = $true
        'noUnusedParameters'                 = $true
        'forceConsistentCasingInFileNames'   = $true
    }

    <# TypeScript #>
    # Make tsconfig more strict
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable
    $missingCompilerOptions.GetEnumerator() | ForEach-Object {
        $tsConfig.compilerOptions.Add($_.Key, $_.Value)
    }
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    git add '.\tsconfig.json'
    git commit -m 'Make tsconfig more strict'
    <# ESLint #>
    # Replace `next lint` with `eslint .` on `lint` npm script
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    $package.scripts.Remove('lint')
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
    # Make eslintrc more strict
    git rm '.\.eslintrc.json'
    Install-MyESLint -UseTypeScript -UseReact -UseJest -IsNextJs
    [hashtable]$eslintrc = Import-MyJSON -LiteralPath '.\.eslintrc.json' -AsHashTable
    # https://nextjs.org/docs/app/building-your-application/configuring/eslint#migrating-existing-config
    npm i -D @next/eslint-plugin-next
    $eslintrc.extends += 'plugin:@next/next/recommended'
    Export-MyJSON -LiteralPath '.\.eslintrc.json' -CustomObject $eslintrc
    git add '.\.eslintrc.json' '.\package.json' '.\package-lock.json'
    git commit -m 'Make eslintrc more strict'
    <# Jest #>
    Install-MyJest -UseBrowser -UseReact
    # Replace `<rootDir>/src` with `<rootDir>` in roots to work properly in Next.js
    Copy-Item -LiteralPath "$PSScriptRoot\jest-nextjs.config.js" -Destination '.\jest.config.js' -Force
    git add '.\jest.config.js'
    git commit -m 'Change `roots` from "<rootDir>/src" to "<rootDir>"'
    <# Prettier #>
    Install-MyPrettier -UseTailwindcss
    <# Tailwind CSS #>
    Install-MyTailwindCss -IsNextJs -UseDaisyUi:$UseDaisyUi
    Install-MyVSCodeSettingsForWeb
}
