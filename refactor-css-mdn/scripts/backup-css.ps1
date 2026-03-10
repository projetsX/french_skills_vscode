# Backup CSS File Script
# Usage: ./backup-css.ps1 -FilePath "path/to/style.css"

param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath
)

# Validate file exists
if (-not (Test-Path $FilePath)) {
    Write-Error "CSS file not found: $FilePath"
    exit 1
}

# Create backup with timestamp
$parentPath = Split-Path -Path $FilePath
$fileName = Split-Path -Path $FilePath -Leaf
$nameWithoutExtension = [IO.Path]::GetFileNameWithoutExtension($fileName)
$extension = [IO.Path]::GetExtension($fileName)

# Format: style.backup-20260310-143022.css
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupName = "$nameWithoutExtension.backup-$timestamp$extension"
$backupPath = Join-Path -Path $parentPath -ChildPath $backupName

# Copy file
try {
    Copy-Item -Path $FilePath -Destination $backupPath -Force
    Write-Host "✓ Backup created successfully" -ForegroundColor Green
    Write-Host "  Location: $backupPath" -ForegroundColor Green
    Write-Host "  Size: $('{0:N2}' -f ((Get-Item $backupPath).Length / 1KB)) KB"
    exit 0
}
catch {
    Write-Error "Failed to create backup: $_"
    exit 1
}
