<#
.SYNOPSIS
Initializes git in the current directory.
#>
function Initialize-MyGit {
    [Alias('ginit')]
    [OutputType([void])]
    param()

    if (Test-MyStrictPath -LiteralPath '.\.git') {
        throw 'Git repository is already in place.'
    }
    git init $args
    if (!(Test-MyStrictPath -LiteralPath '.\.gitignore')) {
        New-Item -Path '.\' -Name '.gitignore' -ItemType 'file'
    }
    git add '.\.gitignore'
    git commit -m 'First commit'
}
