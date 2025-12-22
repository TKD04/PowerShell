if (!(Test-Path -LiteralPath "$PSScriptRoot\Functions")) {
    throw 'Functions directory could not be found.'
}

# Loads all the functions under the modules by dot-source
if ($PSVersionTable.PSVersion -ge [Version]'7.0.0') {
    Get-ChildItem -LiteralPath "$PSScriptRoot\Functions" -File -Filter '*.ps1' -Recurse |
    Select-Object -Property FullName |
    ForEach-Object -ThrottleLimit 5 -Parallel {
        . $_
    }
}
else {
    $functionFiles = Get-ChildItem -LiteralPath "$PSScriptRoot\Functions" -File -Filter '*.ps1' -Recurse |
    Select-Object -Property FullName

    foreach ($functionFile in $functionFiles) {
        . $functionFile
    }
}
