<#
.SYNOPSIS
Adds ESLint and its configuration to the current directory.

.PARAMETER Environment
Specifies the target environment:
- Node
- Vite (uses the browser configuration)
- ViteReact
- Next
#>
function Install-EsLint {
    [OutputType([System.Void])]
    param (
        [ValidateSet('Node', 'Vite', 'ViteReact', 'Next')]
        [string]$Environment
    )

    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    [string]$eslintConfigSource = ''
    [string[]]$devDependencies = @(
        '@e18e/eslint-plugin'
        '@eslint/json'
        '@vitest/eslint-plugin'
        'eslint-config-prettier'
        'eslint-plugin-jsdoc'
        'eslint-plugin-perfectionist'
        'eslint-plugin-regexp'
        'eslint-plugin-security'
        'eslint-plugin-tsdoc'
        # eslint-plugin-unicorn@>=66.0.0 requires eslint@>=10.4.0.
        # Since eslint-config-airbnb-extended@^3 depends on eslint@^9,
        # we stick to eslint-plugin-unicorn@^65 for compatibility.
        'eslint-plugin-unicorn@^65'
        'globals'

        # Peer dependencies managed by eslint-config-airbnb-extended
        # (Review and update these locks when bumping major versions)
        '@eslint/js@^9'
        'eslint@^9'
        'eslint-config-airbnb-extended@^3'
    )

    if ($Environment -cmatch 'React$|^Next$') {
        $devDependencies += @(
            'eslint-plugin-react-hooks'
            'eslint-plugin-react-refresh'
        )
    }
    switch ($Environment) {
        'Node' {
            $eslintConfigSource = 'templates/eslint-node.config.mjs'
        }
        'Vite' {
            $eslintConfigSource = 'templates/eslint-browser-vite.config.mjs'
        }
        'ViteReact' {
            $eslintConfigSource = 'templates/eslint-browser-vite-react.config.mjs'
            if (Test-StrictPath -LiteralPath './eslint.config.js' -PathType 'Leaf') {
                Remove-Item -LiteralPath './eslint.config.js'
            }
        }
        'Next' {
            [hashtable]$package = Import-Json -LiteralPath './package.json'
            [bool]$hasNpmScriptLint = $package.ContainsKey('scripts') -and $package['scripts'].ContainsKey('lint')

            if ($hasNpmScriptLint) {
                pnpm rm 'eslint-config-next'
            }
            $eslintConfigSource = 'templates/eslint-browser-next.config.mjs'
        }
    }
    <# pnpm-workspace.yaml #>
    # Skip for Next.js because Initialize-NextJsProject provides
    # its own pnpm-workspace.yaml with allowBuilds entries
    # for esbuild, sharp, and unrs-resolver.
    if (-not $Environment -eq 'Next') {
        Join-Path -Path $PSScriptRoot -ChildPath 'templates/pnpm-workspace.yaml' |
        Copy-Item -Destination './pnpm-workspace.yaml' -Force
    }

    pnpm add -D @devDependencies
    Add-NpmScript -NameToScript @{
        'lint' = 'eslint . --cache'
    }
    Join-Path -Path $PSScriptRoot -ChildPath $eslintConfigSource |
    Copy-Item -Destination './eslint.config.mjs' -Force
}
