function Remove-GitHistory {
    [OutputType([System.Void])]
    param()

    Remove-DirectoryFast -Directory './.git'
}

Set-Alias -Name 'rmgh' -Value 'Remove-GitHistory'

function Remove-NodeModulesDir {
    [OutputType([System.Void])]
    param()

    Remove-DirectoryFast -Directory './node_modules'
}

New-Alias -Name 'rmnode' -Value 'Remove-NodeModulesDir'
