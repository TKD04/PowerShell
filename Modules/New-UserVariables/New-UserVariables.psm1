[string]$Global:gitignoreDirPath = 'G:\dev\gitignore'

[string[]]$variablesToExport = @(
    '$gitignoreDirPath'
)

Export-ModuleMember -Variable $variablesToExport
