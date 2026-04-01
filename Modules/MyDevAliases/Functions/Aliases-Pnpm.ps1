New-Alias -Name 'pn' -Value 'pnpm'

function New-PnpmViteProject {
    pnpm create vite@latest
}

New-Alias -Name 'pnvite' -Value 'New-PnpmViteProject'

function New-PnpmNextJsProject {
    pnpm dlx create-next-app@latest --use-pnpm
}

New-Alias -Name 'pnnext' -Value 'New-PnpmNextJsProject'

function Start-PnpmServe {
    pnpm dlx serve@latest @args
}

New-Alias -Name 'pnserve' -Value 'Start-PnpmServe'
