<#
.SYNOPSIS
Adds webpack to the current directory.

.PARAMETER OnlyTs
Whether to support for only TypeScript files.
#>
function Install-MyWebpack {
    [OutputType([void])]
    param (
        [switch]$OnlyTs
    )

    [string[]]$neededDevPackages = @(
        'webpack'
        'webpack-cli'
        'ts-loader'
    )
    [hashtable]$npmScripts = @{
        'build' = 'webpack --mode production'
    }

    if ($OnlyTs) {
        Copy-Item -LiteralPath "$PSScriptRoot\onlyts-webpack.config.js" -Destination '.\webpack.config.js'
        <# Add "sideEffects: false" to package.json #>
        [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
        $package.Add('sideEffects', $false)
        Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
        <# Add npm scripts for webpack to package.json #>
        Add-MyNpmScript -NameToScript $npmScripts
        pnpm i -D $neededDevPackages

        git add '.\pnpm-lock.yaml' '.\package.json' '.\webpack.config.js'
        git commit -m 'Add webpack'
        return
    }
    <# Add needed packages and npm scirpt #>
    $neededDevPackages += @(
        'webpack-dev-server'
        'pug-plugin'
        'css-loader'
        'postcss-loader'
        'postcss'
        'autoprefixer'
        'sass-loader'
        'sass'
        'styled-components'
        'tailwindcss'
        '@tailwindcss/typography'
        'daisyui'
        'css-minimizer-webpack-plugin'
        'terser-webpack-plugin'
        'image-minimizer-webpack-plugin'
        'imagemin'
        'imagemin-gifsicle'
        'imagemin-mozjpeg'
        'imagemin-pngquant'
        'imagemin-svgo'
    )
    $npmScripts.Add(
        'dev',
        'webpack serve --open --mode development --devtool eval-cheap-module-source-map'
    )
    <# Makes needed directories and files #>
    [string[]]$neededDirectories = @(
        '.\src'
        '.\src\pug'
        '.\src\scss'
        '.\src\ts'
    )
    [hashtable]$sourcesToDestinations = @{
        "$PSScriptRoot\webpack.config.js"  = '.\webpack.config.js'
        "$PSScriptRoot\tailwind.config.js" = '.\tailwind.config.js'
        "$PSScriptRoot\_layout.pug"        = '.\src\pug\_layout.pug'
        "$PSScriptRoot\index.pug"          = '.\src\pug\index.pug'
        "$PSScriptRoot\style.scss"         = '.\src\scss\style.scss'
    }
    New-MyDirectories -DirectoryPaths $neededDirectories
    Copy-MyFiles -SourcesToDestinations $sourcesToDestinations
    New-Item -Path '.\src\ts' -Name 'index.ts' -ItemType 'File'
    <# Add "sideEffects: false" to package.json #>
    [hashtable]$package = Import-MyJSON -LiteralPath '.\package.json' -AsHashTable
    $package.Add('sideEffects', $false)
    Export-MyJSON -LiteralPath '.\package.json' -CustomObject $package
    <# Add npm scripts for webpack to package.json #>
    Add-MyNpmScript -NameToScript $npmScripts
    pnpm i -D $neededDevPackages

    git add '.\pnpm-lock.yaml' '.\package.json' '.\webpack.config.js' '.\tailwind.config.js' '.\src'
    git commit -m 'Add webpack'
}
