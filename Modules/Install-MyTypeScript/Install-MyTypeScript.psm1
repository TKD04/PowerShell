<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER NoEmit
Whether to enable "noEmit".

.PARAMETER UseNode
Whether to support Node.

.PARAMETER UseReact
Whether to support React.
#>
function Install-MyTypeScript {
    [OutputType([void])]
    param (
        [switch]$NoEmit,
        [switch]$UseNode,
        [switch]$UseReact
    )

    [hashtable]$tsConfig = [ordered]@{
        # https://www.typescriptlang.org/tsconfig
        'include'         = @(
            'src'
        )
        'compilerOptions' = [ordered]@{
            <# Type Checking #>
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
            'strict'                             = $true
            <# Modules #>
            'module'                             = 'esnext'
            'moduleResolution'                   = 'node16'
            'resolveJsonModule'                  = $true
            <# Emit #>
            'outDir'                             = './dist'
            'sourceMap'                          = $true
            <# Interop Constraints #>
            'esModuleInterop'                    = $true
            'forceConsistentCasingInFileNames'   = $true
            'isolatedModules'                    = $true
            # Use ESLint rules for `verbatimModuleSyntax`, as it still has some compatibility issues.
            # https://zenn.dev/teppeis/articles/2023-04-typescript-5_0-verbatim-module-syntax#verbatimmodulesyntax%E3%81%A8-cjs-%E3%81%AE%E7%9B%B8%E6%80%A7%E3%81%8C%E6%82%AA%E3%81%84
            # https://johnnyreilly.com/typescript-5-importsnotusedasvalues-error-eslint-consistent-type-imports
            # 'verbatimModuleSyntax'               = $true
            <# Language and Environment #>
            'lib'                                = @(
                'esnext'
                'dom'
                'dom.iterable'
            )
            'target'                             = 'es2016'
            <# Projects #>
            'incremental'                        = $true
            <# Completeness #>
            'skipLibCheck'                       = $true
        }
    }
    [string[]]$devDependencies = @(
        'typescript'
    )

    if ($NoEmit) {
        $tsConfig.compilerOptions.Add('noEmit', $true)
    }
    if ($UseNode) {
        # https://gist.github.com/azu/56a0411d69e2fc333d545bfe57933d07
        # https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping
        # https://github.com/tsconfig/bases/tree/main/bases
        # For Node 22
        $tsConfig.compilerOptions.module = 'node16'
        $tsConfig.compilerOptions.target = 'es2022'
        $tsConfig.compilerOptions.lib = @(
            'es2023'
        )
        $devDependencies += '@types/node'
    }
    if ($UseReact) {
        $tsConfig.compilerOptions.Add('jsx', 'react-jsx')
    }
    pnpm add -D @devDependencies
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig

    git add '.\pnpm-lock.yaml' '.\package.json' '.\tsconfig.json'
    git commit -m 'Add TypeScript'
}
