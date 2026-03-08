<#
.SYNOPSIS
Adds ts-node to the current directory and updates the ts-node settings in tsconfig.json.
#>
function Install-MyTSNode {
    [OutputType([System.Void])]
    param ()

    [hashtable]$tsConfigTsnode = @{
        transpileOnly = $true
        files         = $true
        swc           = $true
    }
    [hashtable]$tsConfig = Import-MyJSON -LiteralPath './tsconfig.json'

    $tsConfig.Add('ts-node', $tsConfigTsnode)
    Export-MyJSON -LiteralPath './tsconfig.json' -Hashtable $tsConfig
    pnpm add -D ts-node @swc/core @swc/helpers
    git add './package.json' './pnpm-lock.yaml' './tsconfig.json'
    git commit -m 'Add ts-node'
}
