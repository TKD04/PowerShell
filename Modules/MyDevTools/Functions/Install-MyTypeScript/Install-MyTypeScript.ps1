<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER Environment
Exactly one environment must be selected:
- Node.js
- Vite

.PARAMETER UseReact
Whether to use React.
#>
function Install-MyTypeScript {
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Node', 'Vite')]
        [string]$Environment,
        [switch]$UseReact
    )
    if ($Environment -eq 'Node' -and $UseReact) {
        throw '$UseReact cannot be used with Node environment.'
    }

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

    if ($Environment -eq 'Node') {
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
    elseif ($Environment -eq 'Vite') {
        if ($UseReact) {
            $tsConfigPath = '.\tsconfig.app.json'
            $tsConfig['compilerOptions'].Add('jsx', 'react-jsx')
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
        $tsConfig['compilerOptions'].Add('noEmit', $true)
        $tsConfig['compilerOptions'].Remove('outDir')
        if (Test-MyStrictPath -LiteralPath $tsConfigPath) {
            git rm $tsConfigPath
        }
    }
    pnpm add -D @devDependencies
    Export-MyJSON -LiteralPath $tsConfigPath -CustomObject $tsConfig
    git add '.\package.json' '.\pnpm-lock.yaml' $tsConfigPath
    git commit -m "Add TypeScript ($Environment)"
}
