<#
.SYNOPSIS
Automates Bing searches in Microsoft Edge to earn Microsoft Rewards points.

.PARAMETER IsMax120Points
Specifies whether to run extended searches to aim for up to 120 points.

.NOTES
Prerequisites:
- Must be run on a Windows OS environment.
- Must open Microsoft Edge and log-in to your Microsoft account beforehand to earn rewards.

Important Note:
- Passing the target URL directly via "Start-Process 'microsoft-edge:https://...'" failed to earn reward points;
  therefore, the script uses "about:blank" first and performs a search via the address bar (Ctrl + L) and clipboard paste.
- Do not operate the PC (keyboard/mouse) while the function is running, as it uses SendKeys to simulate input.
#>
function Start-MicrosoftRewardsSearch {
    [OutputType([System.Void])]
    param (
        [switch]$IsMax120Points
    )

    if (-not $IsWindows) {
        throw 'This function is supported only on Windows.'
    }
    if (-not (Get-Process -Name 'msedge' -ErrorAction 'SilentlyContinue')) {
        throw 'Microsoft Edge is not running.'
    }

    Add-Type -AssemblyName 'System.Windows.Forms'

    [string[]]$keywords = @(
        '近くのレストラン'
        '近くのコンサート'
        '天気'
        'レンタカー'
        'フライト'
        '空港駐車場'
        'クルーズ'
        'オールインクルーシブリゾート'
        'ジュエリー'
        'クレジットカード スコア'
        '当座預金口座 普通預金口座 違い'
        '個人ローン 学生ローン 違い'
        '保険'
        '携帯電話'
        '花 配達'
        '家庭 アップグレード'
        'インターネット オプション'
        'Netflix'
        'Amazon'
        'Minecraft'
    )
    [int]$progressCount = 0
    $wshell = New-Object -ComObject WScript.Shell

    if ($IsMax120Points) {
        $keywords += [string[]]@(
            'プログラミング 勉強法'
            'TypeScript 入門'
            'PowerShell スクリプト'
            'React Hooks 使い方'
            'Tailwind CSS チートシート'
            'GitHub Actions とは'
            'VSCode 拡張機能 おすすめ'
            'Next.js App Router'
            'Linux コマンド 一覧'
            'Docker 基礎知識'
            'Git コマンド 基本'
            'Node.js インストール'
            'Python 入門'
            'SQL 基礎'
            'REST API とは'
            'JSON 形式'
            'Vite ビルド'
            'ESLint 設定'
            'ソフトウェア設計'
            'API 設計 ベストプラクティス'
        )
    }
    $keywords = Get-Random -InputObject $keywords -Shuffle

    Start-Process -FilePath 'microsoft-edge:about:blank'
    try {
        foreach ($keyword in $keywords) {
            $progressCount += 1
            [int]$progressPercent = [System.Math]::Round(($progressCount / $keywords.Count) * 100, [System.MidpointRounding]::AwayFromZero)
            Write-Progress -Activity 'Microsoft Rewards Automation' `
                -Status "Progress: $($progressCount)/$($keywords.Count)" `
                -PercentComplete $progressPercent

            # 1. Activate Microsoft Edge.
            $null = $wshell.AppActivate('Microsoft Edge')
            Start-Sleep -Milliseconds 600
            # 2. Focus on the search bar(Ctrl+L).
            $wshell.SendKeys('^{l}')
            Start-Sleep -Milliseconds 500
            # 3. Paste keyword and execute the search.
            Set-Clipboard -Value $keyword
            Start-Sleep -Milliseconds 300
            $wshell.SendKeys('^v')
            Start-Sleep -Milliseconds 500
            $wshell.SendKeys('{ENTER}')
            # 4. Wait for a radom interval.
            Start-Sleep -Seconds (Get-Random -Minimum 3 -Maximum 5)
            # Humane fake: Randomly simulate Page Down scrolling (0 to 2 times).
            [int]$pageDownCount = Get-Random -Minimum 0 -Maximum 3
            for ([int]$j = 0; $j -lt $pageDownCount; $j += 1) {
                $wshell.SendKeys('{PGDN}')
                Start-Sleep -Milliseconds (Get-Random -Minimum 400 -Maximum 900)
            }
            # 5. Wait for a radom interval.
            Start-Sleep -Seconds (Get-Random -Minimum 3 -Maximum 6)
        }
    }
    finally {
        Write-Progress -Activity 'Microsoft Rewards Automation' -Completed
    }
}
