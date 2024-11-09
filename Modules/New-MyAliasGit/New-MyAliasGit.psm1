function Initialize-MyGit {
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
function Add-MyGit {
    git add $args
}
function Add-MyGitP {
    git add -p $args
}
function Add-MyGitI {
    git add -i $args
}
function Set-MyGitUnstage {
    git reset HEAD $args
}
function Move-MyGit {
    git mv $args
}
function Remove-MyGit {
    git rm $args
}
function Set-MyGitCommit {
    git commit -m $args
}
function Set-MyGitCommitAll {
    git commit -am $args
}
function Set-MyGitCommitU {
    git add .
    git commit -m $args
}
function Set-MyGitCommitAmend {
    git commit --amend $args
}
function Set-MyGitCommitAmendNoEdit {
    git commit --amend --no-edit $args
}
function Reset-MyGitMixed {
    git reset $args
}
function Reset-MyGitSoft {
    git reset --soft $args
}
function Reset-MyGitHard {
    git reset --hard $args
}
function Restore-MyGit {
    git restore $args
}
function Set-MyGitCheckout {
    git checkout $args
}
function Set-MyGitCheckoutB {
    git checkout -b $args
}
function Set-MyGitBranch {
    git branch $args
}
function Set-MyGitBranchD {
    git branch -d $args
}
function Merge-MyGit {
    git merge $args
}
function Set-MyGitRebase {
    git rebase $args
}
function Set-MyGitStash {
    git stash $args
}
function Set-MyGitStashU {
    git stash -u $args
}
function Pop-MyGit {
    git stash pop $args
}
function Set-MyGitDrop {
    git stash drop $args
}
function Set-MyGitClean {
    git clean -df
}
function Set-MyGitCleanX {
    git clean -xdf
}
function Get-MyGitStatus {
    git status -sb $args
}
function Get-MyGitDiff {
    git diff $args
}
function Get-MyGitDiffStaged {
    git diff --staged $args
}
function Get-MyGitLog {
    git log --oneline --graph $args
}
function Show-MyGit {
    git show $args
}
function Push-MyGit {
    git push $args
}

[hashtable]$aliasesToFunctions = @{
    'ginit'   = 'Initialize-MyGit'
    'a'       = 'Add-MyGit'
    'ap'      = 'Add-MyGitP'
    'ai'      = 'Add-MyGitI'
    'unst'    = 'Set-MyGitUnstage'
    'gmv'     = 'Move-MyGit'
    'grm'     = 'Remove-MyGit'
    'c'       = 'Set-MyGitCommit'
    'ca'      = 'Set-MyGitCommitAll'
    'cu'      = 'Set-MyGitCommitU'
    'cam'     = 'Set-MyGitCommitAmend'
    'camn'    = 'Set-MyGitCommitAmendNoEdit'
    'rem'     = 'Reset-MyGitMixed'
    'res'     = 'Reset-MyGitSoft'
    'reh'     = 'Reset-MyGitHard'
    'restore' = 'Restore-MyGit'
    'che'     = 'Set-MyGitCheckout'
    'cheb'    = 'Set-MyGitCheckoutB'
    'bra'     = 'Set-MyGitBranch'
    'brad'    = 'Set-MyGitBranchD'
    'merge'   = 'Merge-MyGit'
    'rebase'  = 'Set-MyGitRebase'
    'stash'   = 'Set-MyGitStash'
    'stashu'  = 'Set-MyGitStashU'
    'pop'     = 'Pop-MyGit'
    'drop'    = 'Set-MyGitDrop'
    'cl'      = 'Set-MyGitClean'
    'clx'     = 'Set-MyGitCleanX'
    'st'      = 'Get-MyGitStatus'
    'dif'     = 'Get-MyGitDiff'
    'difs'    = 'Get-MyGitDiffStaged'
    'log'     = 'Get-MyGitLog'
    'show'    = 'Show-MyGit'
    'psh'     = 'Push-MyGit'
}
[string[]]$aliasesToExport = @()
[string[]]$functionsToExport = @()
$aliasesToFunctions.GetEnumerator() | ForEach-Object {
    New-Alias -Name $_.Key -Value $_.Value
    $aliasesToExport += $_.Key
    $functionsToExport += $_.Value
}

Export-ModuleMember -Function $functionsToExport -Alias $aliasesToExport
