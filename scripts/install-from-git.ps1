param(
  [string]$RepoUrl = 'https://github.com/FreeGoStudio/wbs-skill.git',
  [string]$Branch = 'main',
  [string]$CodexHome = $env:CODEX_HOME,
  [string]$InstallRoot = (Join-Path $env:TEMP 'wbs-skill-installer')
)

$ErrorActionPreference = 'Stop'
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw 'Git is required. Install Git and try again.'
}
# A fresh checkout avoids resetting or deleting existing user work.
$checkout = Join-Path ([IO.Path]::GetFullPath($InstallRoot)) ([Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Split-Path -Parent $checkout) -Force | Out-Null
& git clone --depth 1 --branch $Branch -- $RepoUrl $checkout
if ($LASTEXITCODE -ne 0) { throw "Git clone failed with exit code $LASTEXITCODE" }
$installer = Join-Path $checkout 'scripts/install-skill.ps1'
if (-not (Test-Path -LiteralPath $installer -PathType Leaf)) {
  throw "Installer is missing from the selected repository/branch: $installer"
}
& $installer -CodexHome $CodexHome
Write-Host "Downloaded checkout retained at: $checkout"
