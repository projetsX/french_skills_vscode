<#
.SYNOPSIS
Restores CSS files from a backup.

.DESCRIPTION
This script restores CSS files from a previously created backup.
It verifies the backup integrity and restores all files to their original locations.

.PARAMETER BackupFolder
The backup folder to restore from (required).

.EXAMPLE
.\restore-css.ps1 -BackupFolder "css-backup-2026-03-10T143000Z"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$BackupFolder
)

$ErrorActionPreference = "Stop"

# Resolve backup folder
if (-not [System.IO.Path]::IsPathRooted($BackupFolder)) {
  $BackupFolder = Join-Path (Get-Location) $BackupFolder
}

if (!(Test-Path $BackupFolder)) {
  Write-Host "ERROR: Backup folder not found: $BackupFolder" -ForegroundColor Red
  exit 1
}

# Read manifest
$manifestPath = Join-Path $BackupFolder "manifest.json"
if (!(Test-Path $manifestPath)) {
  Write-Host "ERROR: manifest.json not found in backup folder" -ForegroundColor Red
  exit 1
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$projectRoot = (Get-Item "$BackupFolder/..").FullName

Write-Host "Restoring CSS backup..."
Write-Host "Backup date: $($manifest.backupDate)"
Write-Host "Files to restore: $($manifest.filesCount)"
Write-Host ""

# Restore files
$backupFiles = Get-ChildItem -Path $BackupFolder -Filter "*.css" -ErrorAction Continue
$restoredCount = 0

# Find where CSS files currently are in the project (exclude backup folders)
$existingCssFile = Get-ChildItem -Path $projectRoot -Filter "*.css" -Recurse -Exclude "*.min.css" -ErrorAction Continue |
  Where-Object { $_.FullName -notmatch 'css-backup' } | Select-Object -First 1

if ($existingCssFile) {
  $cssFolder = Split-Path -Parent $existingCssFile.FullName
  Write-Host "Detected CSS folder: $cssFolder"
  
  foreach ($backupFile in $backupFiles) {
    if ($backupFile.Name -eq "manifest.json") { continue }
    
    $destPath = Join-Path $cssFolder $backupFile.Name
    Copy-Item -Path $backupFile.FullName -Destination $destPath -Force
    Write-Host "Restored: $($backupFile.Name)"
    $restoredCount++
  }
}
else {
  Write-Host "ERROR: Could not find existing CSS files in project" -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "✓ Restore completed" -ForegroundColor Green
Write-Host "✓ Files restored: $restoredCount"
Write-Host ""
Write-Host "Please verify that your application still works correctly."
Write-Host ""
