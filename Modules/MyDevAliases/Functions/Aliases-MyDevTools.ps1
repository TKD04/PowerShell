function Remove-MyGitHistory {
    [OutputType([System.Void])]
    param()

    Remove-MyDirectoryFast -Directory './.git'
}

Set-Alias -Name 'rmgh' -Value 'Remove-MyGitHistory'

function Remove-MyNodeModulesDir {
    [OutputType([System.Void])]
    param()

    Remove-MyDirectoryFast -Directory './node_modules'
}

New-Alias -Name 'rmnode' -Value 'Remove-MyNodeModulesDir'
