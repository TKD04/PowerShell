function Stop-PowerShellSession {
    exit
}

New-Alias -Name 'e' -Value 'Stop-PowerShellSession'
