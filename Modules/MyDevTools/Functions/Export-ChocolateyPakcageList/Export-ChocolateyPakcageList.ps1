<#
.SYNOPSIS
Exports the list of installed Chocolatey packages to a text file.
#>
function Export-ChocolateyPackageList {
    [OutputType([System.Void])]
    param ()

    if (-not(Test-CommandExists -Command 'choco')) {
        throw 'The command "choco" does not exist.'
    }

    [string]$textFileName = (Get-Date -Format 'yyyy-MM-dd') + '_choco-list.txt'
    [string]$textFileFullName = Join-Path -Path $PWD.ProviderPath -ChildPath $textFileName

    if (Test-StrictPath -LiteralPath $textFileFullName) {
        throw "The path '$($textFileFullName)' is already in place."
    }

    [string[]]$packageNames = &'choco' 'list' '--limit-output' |
    ForEach-Object {
        [string]$packageName = ($_ -split '\|')[0]
        if ($packageName.StartsWith('choco') -or
            $packageName.EndsWith('.portable') -or
            $packageName.EndsWith('.install')) {
            return
        }

        $packageName
    }

    if ($null -eq $packageNames -or $packageNames.Count -eq 0) {
        throw 'No installed packages found to export.'
    }

    Set-Content -Value $packageNames -LiteralPath $textFileFullName -Encoding 'utf8NoBOM'
}
