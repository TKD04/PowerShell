<#
.SYNOPSIS
Adds ts-node to the current directory.
#>
function Install-MyTSNode {
    [OutputType([void])]
    param ()

    [hashtable]$tsConfigTsnode = [ordered]@{
        transpileOnly = $true
        files         = $true
        swc           = $true
    }

    [hashtable]$tsConfig = Import-MyJSON -LiteralPath '.\tsconfig.json' -AsHashTable
    $tsConfig.Add('ts-node', $tsConfigTsnode)
    Export-MyJSON -LiteralPath '.\tsconfig.json' -CustomObject $tsConfig
    npm i -D ts-node @swc/core @swc/helpers

    git add '.\package-lock.json' '.\package.json' '.\tsconfig.json'
    git commit -m 'Add ts-node'
}
