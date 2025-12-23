New-Alias -Name 'pn' -Value 'pnpm'

function Install-MyPnpmVite {
    pnpm create vite@latest
}

New-Alias -Name 'pnvite' -Value 'Install-MyPnpmVite'

function Install-MyPnpmNext {
    pnpm dlx create-next-app@latest --use-pnpm
}

New-Alias -Name 'pnnext' -Value 'Install-MyPnpmNext'
