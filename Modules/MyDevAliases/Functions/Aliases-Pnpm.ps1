New-Alias -Name 'pn' -Value 'pnpm'

function New-PnpmViteProject {
    corepack prepare pnpm@latest --activate
    pnpm create vite@latest
}

New-Alias -Name 'pnvite' -Value 'New-PnpmViteProject'

function New-PnpmNextJsProject {
    corepack prepare pnpm@latest --activate
    pnpm dlx create-next-app@latest --use-pnpm
}

New-Alias -Name 'pnnext' -Value 'New-PnpmNextJsProject'

function Start-PnpmServe {
    pnpm dlx serve@latest @args
}

New-Alias -Name 'pnserve' -Value 'Start-PnpmServe'
