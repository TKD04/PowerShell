New-Alias -Name 'n' -Value 'npm'
New-Alias -Name 'nr' -Value 'npm run'
New-Alias -Name 'pn' -Value 'pnpm'

function Add-MyGit {
    git add $args
}
New-Alias -Name 'a' -Value 'Add-MyGit'

function Add-MyGitP {
    git add -p $args
}
New-Alias -Name 'ap' -Value 'Add-MyGitiP'

function Set-MyGitUnstage {
    git reset HEAD $args
}
New-Alias -Name 'unst' -Value 'Set-MyGitUnstage'

function Move-MyGit {
    git mv $args
}
New-Alias -Name 'gmv' -Value 'Move-MyGit'

function Remove-MyGit {
    git rm $args
}
New-Alias -Name 'grm' -Value 'Remove-MyGit'

function Set-MyGitCommit {
    git commit -m $args
}
New-Alias -Name 'c' -Value 'Set-MyGitCommit'

function Set-MyGitCommitAll {
    git add .
    git commit -m $args
}
New-Alias -Name 'ca' -Value 'Set-MyGitCommitAll'

function Set-MyGitCommitAmend {
    git commit --amend $args
}
New-Alias -Name 'cam' -Value 'Set-MyGitCommitAmend'

function Set-MyGitCommitAmendNoEdit {
    git commit --amend --no-edit $args
}
New-Alias -Name 'camn' -Value 'Set-MyGitCommitAmendNoEdit'

function Reset-MyGitMixed {
    git reset $args
}
New-Alias -Name 'rem' -Value 'Reset-MyGitMixed'

function Reset-MyGitSoft {
    git reset --soft $args
}
New-Alias -Name 'res' -Value 'Reset-MyGitSoft'

function Reset-MyGitHard {
    git reset --hard $args
}
New-Alias -Name 'reh' -Value 'Reset-MyGitHard'

function Restore-MyGit {
    git restore $args
}
New-Alias -Name 'restore' -Value 'Restore-MyGit'

function Set-MyGitCheckout {
    git checkout $args
}
New-Alias -Name 'che' -Value 'Set-MyGitCheckout'

function Set-MyGitCheckoutB {
    git checkout -b $args
}
New-Alias -Name 'cheb' -Value 'Set-MyGitCheckoutB'

function Set-MyGitBranch {
    git branch $args
}
New-Alias -Name 'bra' -Value 'Set-MyGitBranch'

function Set-MyGitBranchD {
    git branch -d $args
}
New-Alias -Name 'brad' -Value 'Set-MyGitBranchD'

function Merge-MyGit {
    git merge $args
}
New-Alias -Name 'merge' -Value 'Merge-MyGit'

function Merge-MyGitAbort {
    git merge --abort $args
}
New-Alias -Name 'mergea' -Value 'Merge-MyGitAbort'

function Set-MyGitRebase {
    git rebase $args
}
New-Alias -Name 'rebase' -Value 'Set-MyGitRebase'

function Set-MyGitStash {
    git stash $args
}
New-Alias -Name 'stash' -Value 'Set-MyGitStash'

function Set-MyGitStashU {
    git stash -u $args
}
New-Alias -Name 'stashu' -Value 'Set-MyGitStashU'

function Set-MyGitStashList {
    git stash list $args
}
New-Alias -Name 'stashl' -Value 'Set-MyGitStashList'

function Pop-MyGit {
    git stash pop $args
}
New-Alias -Name 'pop' -Value 'Pop-MyGit'

function Set-MyGitDrop {
    git stash drop $args
}
New-Alias -Name 'drop' -Value 'Set-MyGitDrop'

function Set-MyGitClean {
    git clean -df
}
New-Alias -Name 'cl' -Value 'Set-MyGitClean'

function Set-MyGitCleanX {
    # It even removes the files and directories on .gitignore.
    git clean -xdf
}
New-Alias -Name 'clx' -Value 'Set-MyGitCleanX'

function Get-MyGitStatus {
    git status -sb $args
}
New-Alias -Name 'st' -Value 'Get-MyGitStatus'

function Get-MyGitDiff {
    git diff $args
}
New-Alias -Name 'dif' -Value 'Get-MyGitDiff'

function Get-MyGitDiffStaged {
    git diff --staged $args
}
New-Alias -Name 'difs' -Value 'Get-MyGitDiffStaged'

function Get-MyGitLog {
    git log --oneline --graph $args
}
New-Alias -Name 'l' -Value 'Get-MyGitLog'

function Get-MyGitLog3 {
    git log --oneline --graph -3 $args
}
New-Alias -Name 'l3' -Value 'Get-MyGitLog3'

function Show-MyGit {
    git show $args
}
New-Alias -Name 'show' -Value 'Show-MyGit'

function Set-MyGitFetch {
    git fetch $args
}
New-Alias -Name 'fetch' -Value 'Set-MyGitFetch'

function Set-MyGitPull {
    git pull $args
}
New-Alias -Name 'pull' -Value 'Set-MyGitPull'

function Push-MyGit {
    git push $args
}
New-Alias -Name 'psh' -Value 'Push-MyGit'
