<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER Environment
Exactly one environment must be selected:
- Node
- Vite
- ViteReact
#>
function Install-MyTypeScript {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Node', 'Vite', 'ViteReact')]
        [string]$Environment
    )

    [string]$tsConfigPath = '.\tsconfig.json'
    # Common settings. Adds additional options afterwards depending on the selected environment.
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
            # 'module'                             = ''
            # 'moduleResolution'                   = ''
            'noUncheckedSideEffectImports'       = $true
            'resolveJsonModule'                  = $true
            <# Emit #>
            'outDir'                             = './dist'
            'sourceMap'                          = $true
            <# Interop Constraints #>
            'erasableSyntaxOnly'                 = $true
            'esModuleInterop'                    = $true
            'forceConsistentCasingInFileNames'   = $true
            'isolatedModules'                    = $true
            'verbatimModuleSyntax'               = $true
            <# Language and Environment #>
            # 'lib'                                = @()
            # 'target'                             = ''
            'useDefineForClassFields'            = $true
            <# Projects #>
            'incremental'                        = $true
            'tsBuildInfoFile'                    = './node_modules/.tmp/tsconfig.tsbuildinfo'
            <# Completeness #>
            'skipLibCheck'                       = $true
        }
    }
    [string[]]$devDependencies = @(
        'typescript'
    )

    switch -Wildcard ($Environment) {
        'Node' {
            # https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping
            # https://github.com/tsconfig/bases/tree/main/bases
            # For Node.js 24
            $tsConfig['compilerOptions']['module'] = 'nodenext'
            $tsConfig['compilerOptions']['moduleResolution'] = 'node16'
            $tsConfig['compilerOptions']['types'] = @('node')
            $tsConfig['compilerOptions']['lib'] = @('es2024')
            $tsConfig['compilerOptions']['target'] = 'es2024'
            $devDependencies += '@types/node'
        }
        'Vite*' {
            if ($Environment -eq 'ViteReact') {
                $tsConfigPath = '.\tsconfig.app.json'
                $tsConfig['compilerOptions']['jsx'] = 'react-jsx'
                $tsConfig['compilerOptions']['tsBuildInfoFile'] = './node_modules/.tmp/tsconfig.app.tsbuildinfo'
            }
            $tsConfig['compilerOptions']['module'] = 'esnext'
            $tsConfig['compilerOptions']['moduleResolution'] = 'bundler'
            $tsConfig['compilerOptions']['paths'] = @{
                '@/*' = @(
                    './src/*'
                )
            }
            $tsConfig['compilerOptions']['types'] = @('vite/client')
            $tsConfig['compilerOptions']['lib'] = @(
                'ES2022'
                'DOM'
                'DOM.Iterable'
            )
            $tsConfig['compilerOptions']['moduleDetection'] = 'force'
            $tsConfig['compilerOptions']['target'] = 'es2022'
            $tsConfig['compilerOptions']['noEmit'] = $true
            $tsConfig['compilerOptions'].Remove('outDir')
            if (Test-MyStrictPath -LiteralPath $tsConfigPath) {
                git rm $tsConfigPath
            }
        }
    }
    pnpm add -D @devDependencies
    Export-MyJSON -LiteralPath $tsConfigPath -Hashtable $tsConfig
    git add '.\package.json' '.\pnpm-lock.yaml' $tsConfigPath
    git commit -m "Add TypeScript ($Environment)"
}
