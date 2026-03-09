New-Alias -Name 'pn' -Value 'pnpm'

function Install-PnpmVite {
    pnpm create vite@latest
}

New-Alias -Name 'pnvite' -Value 'Install-PnpmVite'

function Install-PnpmNext {
    pnpm dlx create-next-app@latest --use-pnpm
}

New-Alias -Name 'pnnext' -Value 'Install-PnpmNext'
