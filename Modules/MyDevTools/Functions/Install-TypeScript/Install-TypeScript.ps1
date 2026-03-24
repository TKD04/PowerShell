<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER Environment
Exactly one environment must be selected:
- Node
- Vite
- ViteReact
#>
function Install-TypeScript {
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Node', 'Vite', 'ViteReact')]
        [string]$Environment
    )

    [string]$tsConfigPath = './tsconfig.json'
    # Common settings. Adds additional options afterwards depending on the selected environment.
    [hashtable]$tsConfig = @{
        # https://www.typescriptlang.org/tsconfig
        'include'         = @(
            'src'
        )
        'compilerOptions' = @{
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
            # For Node.js 24.
            $tsConfig['compilerOptions'] += @{
                'module'           = 'nodenext'
                'moduleResolution' = 'node16'
                'types'            = @('node')
                'lib'              = @('es2024')
                'target'           = 'es2024'
            }
            $devDependencies += '@types/node'
        }
        'Vite*' {
            if ($Environment -eq 'ViteReact') {
                $tsConfig['compilerOptions'] += @{
                    'jsx'             = 'react-jsx'
                    'tsBuildInfoFile' = './node_modules/.tmp/tsconfig.app.tsbuildinfo'
                }
                $tsConfigPath = './tsconfig.app.json'
            }
            $tsConfig['compilerOptions'] += @{
                'module'           = 'esnext'
                'moduleResolution' = 'bundler'
                'paths'            = @{
                    '@/*' = @(
                        './src/*'
                    )
                }
                'types'            = @('vite/client')
                'lib'              = @(
                    'ES2022'
                    'DOM'
                    'DOM.Iterable'
                )
                'moduleDetection'  = 'force'
                'target'           = 'es2022'
                'noEmit'           = $true
            }
            $tsConfig['compilerOptions'].Remove('outDir')
        }
    }
    pnpm add -D @devDependencies
    Export-Json -LiteralPath $tsConfigPath -Hashtable $tsConfig
    git add './package.json' './pnpm-lock.yaml' $tsConfigPath
    git commit -m "Add TypeScript ($Environment)"
}
