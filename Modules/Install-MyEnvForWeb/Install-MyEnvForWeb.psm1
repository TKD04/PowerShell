<#
.SYNOPSIS
Adds the web develop environment to the current directory.

.PARAMETER OnlyTs
Whether to support for only TypeScript files.

.PARAMETER UseReact
Whether to support TypeScript.
#>
function Install-MyEnvForWeb {
    [Alias('ienvweb')]
    [OutputType([void])]
    param (
        [switch]$OnlyTs,
        [switch]$UseReact
    )

    if ($OnlyTs -and $UseReact) {
        throw 'Only either $OnlyTs or $UseReact can be enabled.'
    }

    Initialize-MyGit
    Initialize-MyNpm
    Install-MyTypeScript -UseReact:$UseReact
    if ($UseReact) {
        Install-MyReact
    }
    Install-MyESLint -UseTypeScript -UseJest -UseBrower -UseReact:$UseReact
    Install-MyJest -UseBrowser -UseReact:$UseReact
    Install-MyPrettier -UseTailwindcss:(!$OnlyTs) -UsePug:(!$OnlyTs)
    Install-MyWebpack -OnlyTs:$OnlyTs
    Install-MyTypeDoc
    Install-MyVSCodeSettingsForWeb

    pnpm run format
    git add .
    git commit -m 'Format by prettier'
}
