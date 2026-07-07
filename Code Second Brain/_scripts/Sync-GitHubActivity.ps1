# Sync-GitHubActivity.ps1
# Pulls your GitHub repo list + recent commits into the Obsidian vault.
# Runs daily via Windows Task Scheduler ("Obsidian GitHub Sync").
# Requires: gh CLI logged in (gh auth status).

$ErrorActionPreference = 'Stop'
$outDir = "C:\Users\logan\Documents\Obsidian Vault\Code Second Brain\GitHub Activity"
New-Item -ItemType Directory -Force $outDir | Out-Null

$now = Get-Date -Format 'yyyy-MM-dd HH:mm'
$repos = gh repo list --json name,owner,description,visibility,updatedAt,url --limit 100 | ConvertFrom-Json

$index = @("# GitHub Activity", "", "_Auto-generated. Last synced: ${now}_", "")
foreach ($r in $repos) {
    $updated = ([string]$r.updatedAt).Substring(0, 10)
    $index += "- [[$($r.name)]] - $($r.visibility) - last updated $updated"

    $lines = @("# $($r.name)", "")
    if ($r.description) { $lines += @($r.description, "") }
    $lines += @("Repo: $($r.url)", "", "_Auto-generated. Last synced: ${now}_", "", "## Recent commits", "")
    $ErrorActionPreference = 'Continue'
    $raw = gh api "repos/$($r.owner.login)/$($r.name)/commits?per_page=15" 2>$null
    $ErrorActionPreference = 'Stop'
    if ($LASTEXITCODE -eq 0 -and $raw) {
        foreach ($c in ($raw | ConvertFrom-Json)) {
            $d = ([string]$c.commit.author.date).Substring(0, 10)
            $msg = ($c.commit.message -split "`n")[0]
            $lines += "- $d - $msg"
        }
    } else {
        $lines += "- (no commits yet or repo unreachable)"
    }
    Set-Content -Path (Join-Path $outDir "$($r.name).md") -Value ($lines -join "`n") -Encoding utf8
}
Set-Content -Path (Join-Path $outDir "_GitHub Index.md") -Value ($index -join "`n") -Encoding utf8
exit 0
