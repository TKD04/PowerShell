[hashtable]$aliases = @{
    'g'  = 'git'
    'pn' = 'pnpm'
}

$aliases.GetEnumerator() | ForEach-Object {
    New-Alias -Name $_.Key -Value $_.Value
}
