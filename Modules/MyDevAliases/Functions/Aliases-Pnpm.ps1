New-Alias -Name 'pn' -Value 'pnpm'

function New-PnpmViteProject {
    if (-not (Test-CommandExists -Command 'corepack')) {
        throw 'The command "corepack" was not found.'
    }
    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    corepack prepare pnpm@latest --activate
    pnpm create vite@latest
}

New-Alias -Name 'pnvite' -Value 'New-PnpmViteProject'

function New-PnpmNextJsProject {
    if (-not (Test-CommandExists -Command 'corepack')) {
        throw 'The command "corepack" was not found.'
    }
    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    corepack prepare pnpm@latest --activate
    pnpm dlx create-next-app@latest --use-pnpm
}

New-Alias -Name 'pnnext' -Value 'New-PnpmNextJsProject'

function Start-PnpmServe {
    if (-not (Test-CommandExists -Command 'pnpm')) {
        throw 'The command "pnpm" was not found.'
    }

    pnpm dlx serve@latest @args
}

New-Alias -Name 'pnserve' -Value 'Start-PnpmServe'
