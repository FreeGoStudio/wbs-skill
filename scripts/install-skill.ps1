param(
  [string]$CodexHome = $env:CODEX_HOME
)

$ErrorActionPreference = 'Stop'
$source = [IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $PSScriptRoot) 'skills/wbs'))
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
  throw "Skill source not found: $source"
}
if ([string]::IsNullOrWhiteSpace($CodexHome)) {
  $CodexHome = Join-Path $env:USERPROFILE '.codex'
}
$installHome = [IO.Path]::GetFullPath($CodexHome)
$skillsRoot = Join-Path $installHome 'skills'
$target = [IO.Path]::GetFullPath((Join-Path $skillsRoot 'wbs'))
if ($target.Equals($source, [StringComparison]::OrdinalIgnoreCase) -or
    $target.StartsWith($source + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -or
    $source.StartsWith($target + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
  throw 'Source and installation directories must not overlap.'
}
if (Test-Path -LiteralPath $target) {
  $existing = Get-Item -LiteralPath $target -Force
  if (-not $existing.PSIsContainer -or ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    throw "Target must be a regular directory: $target"
  }
}

# Stage outside the discoverable skills directory before replacing an installation.
$stageRoot = Join-Path $installHome ('skill-install-staging/' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
$stage = Join-Path $stageRoot 'wbs'
Copy-Item -LiteralPath $source -Destination $stage -Recurse
foreach ($file in Get-ChildItem -LiteralPath $source -File -Recurse) {
  $relative = $file.FullName.Substring($source.Length).TrimStart('\', '/')
  $copied = Join-Path $stage $relative
  if ((Get-FileHash -LiteralPath $file.FullName).Hash -ne (Get-FileHash -LiteralPath $copied).Hash) {
    throw "Copy verification failed: $relative"
  }
}
New-Item -ItemType Directory -Path $skillsRoot -Force | Out-Null
$backup = $null
if (Test-Path -LiteralPath $target) {
  # The exact target is the resolved skills/wbs directory, never a caller-supplied child path.
  $backupRoot = Join-Path $installHome 'skill-backups'
  New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
  $backup = Join-Path $backupRoot ('wbs-' + [Guid]::NewGuid().ToString('N'))
  Move-Item -LiteralPath $target -Destination $backup
  Write-Host "Previous installation saved to: $backup"
}
try {
  Move-Item -LiteralPath $stage -Destination $target
} catch {
  if ($backup -and -not (Test-Path -LiteralPath $target)) {
    Move-Item -LiteralPath $backup -Destination $target
  }
  throw
}
Write-Host "Installed WBS skill: $target"
Write-Host 'Open a new Codex chat and use $wbs.'
