if (!(Test-Path -LiteralPath "$PSScriptRoot\Functions")) {
    throw 'Functions directory could not be found.'
}

# Loads all the functions under the modules by dot-source
Get-ChildItem -LiteralPath "$PSScriptRoot\Functions" -File -Filter '*.ps1' -Recurse |
Select-Object -Property FullName |
ForEach-Object -ThrottleLimit 5 -Parallel {
    . $_
}
