<#
.SYNOPSIS
Adds TypeScript and its settings to the current directory.

.PARAMETER NoEmit
Whether to enable "noEmit".

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
        [switch]$NoEmit,
        [switch]$UseNode,
        [switch]$UseReact,
        [switch]$IsVite
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
            'noUncheckedSideEffectImports'       = $true
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
            <# Projects #>
            'incremental'                        = $true
            <# Completeness #>
            'skipLibCheck'                       = $true
        }
    }
    [string[]]$devDependencies = @(
        'typescript'
    )
    [string]$tsConfigPath = '.\tsconfig.json'
    [string]$commitMessage = 'Add TypeScript'

    if ($NoEmit -or $IsVite) {
        $tsConfig.compilerOptions.Add('noEmit', $true)
    }
    if ($UseNode) {
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
    if ($IsVite) {
        [hashtable]$viteDefaultCompilerOptions = [ordered]@{
            'allowImportingTsExtensions' = $true
            'moduleDetection'            = 'force'
            'useDefineForClassFields'    = $true
        }

        if ($UseReact) {
            $tsConfigPath = '.\tsconfig.app.json'
            $viteDefaultCompilerOptions.Add(
                'tsBuildInfoFile', './node_modules/.tmp/tsconfig.app.tsbuildinfo'
            )
        }
        $viteDefaultCompilerOptions.GetEnumerator() | ForEach-Object {
            $tsConfig.compilerOptions.Add($_.Key, $_.Value)
        }
        $tsConfig.compilerOptions.moduleResolution = 'bundler'
        $tsConfig.compilerOptions.lib = @(
            'es2020'
            'dom'
            'dom.iterable'
        )
        $tsConfig.compilerOptions.target = 'es2020'
        $tsConfig.compilerOptions.Remove('outDir')
        $commitMessage = 'Make tsconfig more strict'

        git rm $tsConfigPath
    }
    pnpm add -D @devDependencies
    Export-MyJSON -LiteralPath $tsConfigPath -CustomObject $tsConfig

    git add '.\pnpm-lock.yaml' '.\package.json' $tsConfigPath
    git commit -m $commitMessage
}
