function Add-GitStage {
    git add @args
}

New-Alias -Name 'a' -Value 'Add-GitStage'

function Add-GitStagePatch {
    git add -p @args
}

New-Alias -Name 'ap' -Value 'Add-GitStagePatch'

function Reset-GitStage {
    git reset HEAD @args
}

New-Alias -Name 'unst' -Value 'Reset-GitStage'

function Move-Git {
    git mv @args
}

New-Alias -Name 'gmv' -Value 'Move-Git'

function Remove-Git {
    git rm @args
}

New-Alias -Name 'grm' -Value 'Remove-Git'

function Submit-GitCommit {
    git commit -m @args
}

New-Alias -Name 'c' -Value 'Submit-GitCommit'

function Submit-GitCommitAll {
    git add .
    git commit -m @args
}

New-Alias -Name 'ca' -Value 'Submit-GitCommitAll'

function Submit-GitCommitAmend {
    git commit --amend @args
}

New-Alias -Name 'cam' -Value 'Submit-GitCommitAmend'

function Submit-GitCommitAmendNoEdit {
    git commit --amend --no-edit @args
}

New-Alias -Name 'camn' -Value 'Submit-GitCommitAmendNoEdit'

function Reset-GitCommitMixed {
    git reset @args
}

New-Alias -Name 'rem' -Value 'Reset-GitCommitMixed'

function Reset-GitCommitSoft {
    git reset --soft @args
}

New-Alias -Name 'res' -Value 'Reset-GitCommitSoft'

function Reset-GitCommitHard {
    git reset --hard @args
}

New-Alias -Name 'reh' -Value 'Reset-GitCommitHard'

function Restore-Git {
    git restore @args
}

New-Alias -Name 'restore' -Value 'Restore-Git'

function Get-GitBranch {
    git branch @args
}

New-Alias -Name 'bra' -Value 'Get-GitBranch'

function Switch-GitBranch {
    git checkout @args
}
New-Alias -Name 'che' -Value 'Switch-GitBranch'

function New-GitBranch {
    git checkout -b @args
}

New-Alias -Name 'cheb' -Value 'New-GitBranch'

function Remove-GitBranch {
    git branch -d @args
}

New-Alias -Name 'brad' -Value 'Remove-GitBranch'

function Merge-Git {
    git merge @args
}

New-Alias -Name 'merge' -Value 'Merge-Git'

function Stop-GitMerge {
    git merge --abort @args
}

New-Alias -Name 'mergea' -Value 'Stop-GitMerge'

function Invoke-GitRebase {
    git rebase @args
}

New-Alias -Name 'rebase' -Value 'Invoke-GitRebase'

function Get-GitStash {
    git stash list @args
}

New-Alias -Name 'stashl' -Value 'Get-GitStash'

function Save-GitStash {
    git stash @args
}

New-Alias -Name 'stash' -Value 'Save-GitStash'

function Save-GitStashUntracked {
    git stash -u @args
}

New-Alias -Name 'stashu' -Value 'Save-GitStashUntracked'

function Receive-GitStash {
    git stash pop @args
}

New-Alias -Name 'pop' -Value 'Receive-GitStash'

function Remove-GitStash {
    git stash drop @args
}

New-Alias -Name 'drop' -Value 'Remove-GitStash'

function Clear-GitUntracked {
    git clean -df
}

New-Alias -Name 'cl' -Value 'Clear-GitUntracked'

function Clear-GitUntrackedX {
    # Removes all untracked files, including those in .gitignore.
    git clean -xdf
}

New-Alias -Name 'clx' -Value 'Clear-GitUntrackedX'

function Get-GitStatus {
    git status -sb @args
}

New-Alias -Name 'st' -Value 'Get-GitStatus'

function Get-GitDiff {
    git diff @args
}

New-Alias -Name 'dif' -Value 'Get-GitDiff'

function Get-GitStageDiff {
    git diff --staged @args
}

New-Alias -Name 'difs' -Value 'Get-GitStageDiff'

function Get-GitLog {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' @args
}

New-Alias -Name 'l' -Value 'Get-GitLog'

function Get-GitLog3 {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' -3 @args
}

New-Alias -Name 'll' -Value 'Get-GitLog3'

function Find-GitLog {
    [string]$format = '%C(yellow)%h%Creset %C(green)%cd%Creset %s %C(red)%d%Creset %C(cyan)[%an]%Creset'

    git log --oneline --graph --format="$format" --date=format:'%Y-%m-%d %H:%M' --grep="$args"
}

New-Alias -Name 'lgrep' -Value 'Find-GitLog'

function Show-Git {
    git show @args
}

New-Alias -Name 'show' -Value 'Show-Git'

function Invoke-GitFetch {
    git fetch @args
}

New-Alias -Name 'fetch' -Value 'Invoke-GitFetch'

function Update-GitRemote {
    git pull @args
}

New-Alias -Name 'pull' -Value 'Update-GitRemote'

function Push-Git {
    git push @args
}

New-Alias -Name 'psh' -Value 'Push-Git'
