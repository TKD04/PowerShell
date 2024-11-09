[hashtable]$aliases = @{
    'g' = 'git'
}

$aliases.GetEnumerator() | ForEach-Object {
    New-Alias -Name $_.Key -Value $_.Value
}
