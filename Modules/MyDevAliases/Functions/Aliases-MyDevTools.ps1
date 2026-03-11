function Clear-Directory {
    [OutputType([System.Void])]
    param ()

    Remove-DirectoryFast -Directory $PWD
}

Set-Alias -Name 'cldir' -Value 'Clear-Directory'

function Remove-GitRepository {
    [OutputType([System.Void])]
    param()

    Remove-DirectoryFast -Directory './.git'
}

Set-Alias -Name 'rmgh' -Value 'Remove-GitRepository'

function Remove-NodeModule {
    [OutputType([System.Void])]
    param()

    Remove-DirectoryFast -Directory './node_modules'
}

New-Alias -Name 'rmnode' -Value 'Remove-NodeModule'
