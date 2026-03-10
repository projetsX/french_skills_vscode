<#
.SYNOPSIS
Creates a backup of CSS files before cleanup.

.DESCRIPTION
This script:
1. Creates a timestamped backup folder
2. Copies all regular (non-minified) CSS files
3. Generates a manifest.json for tracking

.PARAMETER CssFolder
The folder containing CSS files to backup.

.PARAMETER BackupName
Optional name for the backup (default: timestamp-based).

.EXAMPLE
.\backup-css.ps1 -CssFolder "src/styles"

.EXAMPLE
.\backup-css.ps1 -CssFolder "src/styles" -BackupName "before-cleanup"
#>

param(
  [Parameter(Mandatory = $false)]
  [string]$CssFolder = "src/styles",
  
  [Parameter(Mandatory = $false)]
  [string]$BackupName = $null
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyy-MM-ddTHHmmssZ"

if ([System.IO.Path]::IsPathRooted($CssFolder)) {
  $CssFolder = (Get-Item $CssFolder).FullName
}
else {
  $CssFolder = (Get-Item (Join-Path (Get-Location) $CssFolder)).FullName
}

$projectRoot = (Get-Item "$CssFolder/..").FullName

if ($BackupName) {
  $backupFolder = Join-Path $projectRoot "css-backup-$BackupName"
}
else {
  $backupFolder = Join-Path $projectRoot "css-backup-$timestamp"
}

Write-Host "Creating CSS backup..."
Write-Host "Source: $CssFolder"
Write-Host "Backup destination: $backupFolder"

# Create backup folder
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null

# Copy all CSS files except minified
$cssFiles = Get-ChildItem -Path $CssFolder -Recurse -Filter "*.css" -ErrorAction Continue
$regularFiles = $cssFiles | Where-Object { $_.Name -notmatch '\.min\.css$' }

foreach ($file in $regularFiles) {
  $relativePath = $file.FullName.Replace($CssFolder, "").TrimStart('\')
  $backupPath = Join-Path $backupFolder $relativePath
  $backupDir = Split-Path -Parent $backupPath
  
  New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
  Copy-Item -Path $file.FullName -Destination $backupPath -Force
  Write-Host "Backed up: $relativePath"
}

# Create manifest
$manifest = @{
  backupDate     = $timestamp
  backupLocation = $backupFolder
  filesCount     = $regularFiles.Count
  minifiedIgnored = ($cssFiles.Count - $regularFiles.Count)
}

$manifestPath = Join-Path $backupFolder "manifest.json"
$manifest | ConvertTo-Json | Out-File -Encoding UTF8 -FilePath $manifestPath

Write-Host ""
Write-Host "✓ Backup completed successfully"
Write-Host "✓ Location: $backupFolder"
Write-Host "✓ Files backed up: $($regularFiles.Count)"
Write-Host ""
