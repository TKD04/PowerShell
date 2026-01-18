<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER UseNode
Whether to support Node.

.PARAMETER UseReact
Whether to support React.

.PARAMETER IsVite
Whether to add Vite default configs.
#>
function Install-MyTypeScript {
    [OutputType([void])]
    param (
        [switch]$UseNode,
        [switch]$UseReact,
        [switch]$IsVite
    )

    [string]$commitMessage = 'Add TypeScript'
    [string]$tsConfigPath = '.\tsconfig.json'
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
            'noUncheckedSideEffectImports'       = $true
            'paths'                              = @{
                '@/*' = @(
                    './src/*'
                )
            }
            'resolveJsonModule'                  = $true
            <# Emit #>
            'outDir'                             = './dist'
            'sourceMap'                          = $true
            <# Interop Constraints #>
            'esModuleInterop'                    = $true
            'forceConsistentCasingInFileNames'   = $true
            'isolatedModules'                    = $true
            'verbatimModuleSyntax'               = $true
            <# Language and Environment #>
            'lib'                                = @(
                'esnext'
                'dom'
                'dom.iterable'
            )
            'target'                             = 'es2016'
            'useDefineForClassFields'            = $true
            <# Projects #>
            'incremental'                        = $true
            <# Completeness #>
            'skipLibCheck'                       = $true
        }
    }
    [string[]]$devDependencies = @(
        'typescript'
    )

    if ($UseNode) {
        # https://github.com/microsoft/TypeScript/wiki/Node-Target-Mapping
        # https://github.com/tsconfig/bases/tree/main/bases
        # For Node 22
        $tsConfig['compilerOptions']['module'] = 'node16'
        $tsConfig['compilerOptions']['lib'] = @(
            'es2023'
        )
        $tsConfig['compilerOptions']['target'] = 'es2022'
        $devDependencies += '@types/node'
    }
    if ($UseReact) {
        $tsConfig['compilerOptions'].Add('jsx', 'react-jsx')
    }
    if ($IsVite) {
        [hashtable]$viteDefaultCompilerOptions = [ordered]@{
            'moduleDetection' = 'force'
        }

        if ($UseReact) {
            $tsConfigPath = '.\tsconfig.app.json'
            $viteDefaultCompilerOptions.Add(
                'tsBuildInfoFile', './node_modules/.tmp/tsconfig.app.tsbuildinfo'
            )
        }
        foreach ($kv in $viteDefaultCompilerOptions.GetEnumerator()) {
            $tsConfig['compilerOptions'].Add($kv.Key, $kv.Value)
        }
        $tsConfig['compilerOptions']['moduleResolution'] = 'bundler'
        $tsConfig['compilerOptions']['lib'] = @(
            'es2020'
            'dom'
            'dom.iterable'
        )
        $tsConfig['compilerOptions']['target'] = 'es2020'
        $tsConfig['compilerOptions'].Add('noEmit', $true)
        $tsConfig['compilerOptions'].Remove('outDir')
        $commitMessage = 'Make tsconfig more strict'

        git rm $tsConfigPath
    }
    pnpm add -D @devDependencies
    Export-MyJSON -LiteralPath $tsConfigPath -CustomObject $tsConfig
    git add '.\package.json' '.\pnpm-lock.yaml' $tsConfigPath
    git commit -m $commitMessage
}
