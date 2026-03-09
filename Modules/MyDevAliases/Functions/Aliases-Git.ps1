function Add-Git {
    git add @args
}

New-Alias -Name 'a' -Value 'Add-Git'

function Add-GitP {
    git add -p @args
}

New-Alias -Name 'ap' -Value 'Add-GitP'

function Set-GitUnstage {
    git reset HEAD @args
}

New-Alias -Name 'unst' -Value 'Set-GitUnstage'

function Move-Git {
    git mv @args
}

New-Alias -Name 'gmv' -Value 'Move-Git'

function Remove-Git {
    git rm @args
}

New-Alias -Name 'grm' -Value 'Remove-Git'

function Set-GitCommit {
    git commit -m @args
}

New-Alias -Name 'c' -Value 'Set-GitCommit'

function Set-GitCommitAll {
    git add .
    git commit -m @args
}

New-Alias -Name 'ca' -Value 'Set-GitCommitAll'

function Set-GitCommitAmend {
    git commit --amend @args
}

New-Alias -Name 'cam' -Value 'Set-GitCommitAmend'

function Set-GitCommitAmendNoEdit {
    git commit --amend --no-edit @args
}

New-Alias -Name 'camn' -Value 'Set-GitCommitAmendNoEdit'

function Reset-GitMixed {
    git reset @args
}

New-Alias -Name 'rem' -Value 'Reset-GitMixed'

function Reset-GitSoft {
    git reset --soft @args
}

New-Alias -Name 'res' -Value 'Reset-GitSoft'

function Reset-GitHard {
    git reset --hard @args
}

New-Alias -Name 'reh' -Value 'Reset-GitHard'

function Restore-Git {
    git restore @args
}

New-Alias -Name 'restore' -Value 'Restore-Git'

function Set-GitCheckout {
    git checkout @args
}
New-Alias -Name 'che' -Value 'Set-GitCheckout'

function Set-GitCheckoutB {
    git checkout -b @args
}

New-Alias -Name 'cheb' -Value 'Set-GitCheckoutB'

function Set-GitBranch {
    git branch @args
}

New-Alias -Name 'bra' -Value 'Set-GitBranch'

function Set-GitBranchD {
    git branch -d @args
}

New-Alias -Name 'brad' -Value 'Set-GitBranchD'

function Merge-Git {
    git merge @args
}

New-Alias -Name 'merge' -Value 'Merge-Git'

function Merge-GitAbort {
    git merge --abort @args
}

New-Alias -Name 'mergea' -Value 'Merge-GitAbort'

function Set-GitRebase {
    git rebase @args
}

New-Alias -Name 'rebase' -Value 'Set-GitRebase'

function Set-GitStash {
    git stash @args
}

New-Alias -Name 'stash' -Value 'Set-GitStash'

function Set-GitStashU {
    git stash -u @args
}

New-Alias -Name 'stashu' -Value 'Set-GitStashU'

function Set-GitStashList {
    git stash list @args
}

New-Alias -Name 'stashl' -Value 'Set-GitStashList'

function Pop-Git {
    git stash pop @args
}

New-Alias -Name 'pop' -Value 'Pop-Git'

function Set-GitDrop {
    git stash drop @args
}

New-Alias -Name 'drop' -Value 'Set-GitDrop'

function Set-GitClean {
    git clean -df
}

New-Alias -Name 'cl' -Value 'Set-GitClean'

function Set-GitCleanX {
    # Removes all untracked files, including those in .gitignore.
    git clean -xdf
}

New-Alias -Name 'clx' -Value 'Set-GitCleanX'

function Get-GitStatus {
    git status -sb @args
}

New-Alias -Name 'st' -Value 'Get-GitStatus'

function Get-GitDiff {
    git diff @args
}

New-Alias -Name 'dif' -Value 'Get-GitDiff'

function Get-GitDiffStaged {
    git diff --staged @args
}

New-Alias -Name 'difs' -Value 'Get-GitDiffStaged'

function Get-GitLog {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' @args
}

New-Alias -Name 'l' -Value 'Get-GitLog'

function Get-GitLogGrep {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' --grep="$args"
}

New-Alias -Name 'lgrep' -Value 'Get-GitLogGrep'

function Get-GitLog3 {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' -3 @args
}

New-Alias -Name 'll' -Value 'Get-GitLog3'

function Show-Git {
    git show @args
}

New-Alias -Name 'show' -Value 'Show-Git'

function Set-GitFetch {
    git fetch @args
}

New-Alias -Name 'fetch' -Value 'Set-GitFetch'

function Set-GitPull {
    git pull @args
}

New-Alias -Name 'pull' -Value 'Set-GitPull'

function Push-Git {
    git push @args
}

New-Alias -Name 'psh' -Value 'Push-Git'
