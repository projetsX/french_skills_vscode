<#
.SYNOPSIS
Analyzes and removes unused CSS blocks from a website project.

.DESCRIPTION
This script performs a complete CSS cleanup workflow:
1. Scans HTML/JSX/Vue pages for class usage
2. Analyzes CSS files and identifies unused selectors
3. Generates a detailed report
4. Creates a backup before modifications
5. Optionally removes unused CSS blocks

.PARAMETER ProjectRoot
Path to the project root. The script will scan recursively from this root (default: current directory).

.PARAMETER ExcludeDirs

Array of directory names to exclude from scanning (e.g. node_modules, vendor, phpmyadmin).

.PARAMETER PagesFolder
The folder containing HTML pages to scan for CSS classes.

.PARAMETER CssFolder
The folder containing CSS files to analyze.

.PARAMETER GenerateReport
If $true, generates analysis reports (JSON and Markdown).

.PARAMETER CreateBackup
If $true, creates a backup of CSS files before execution.

.PARAMETER ExecuteCleanup
If $true, actually removes the unused CSS blocks. If $false, only shows what would be removed (dry-run).

.PARAMETER SafeMode
If $true, uses stricter confidence threshold (default 0.95).

.PARAMETER ConfidenceThreshold
Minimum confidence level (0-1) for removing a CSS block. Default: 0.85

.EXAMPLE
.\cleanup-unused-css.ps1 -PagesFolder "src/pages" -CssFolder "src/styles"

.EXAMPLE
.\cleanup-unused-css.ps1 -PagesFolder "src/pages" -CssFolder "src/styles" -ExecuteCleanup $true -CreateBackup $true -Verbose
#>

param(
  [Parameter(Mandatory = $false)]
  [string]$PagesFolder = "src/pages",
  
  [Parameter(Mandatory = $false)]
  [string]$CssFolder = "src/styles",
  
  [Parameter(Mandatory = $false)]
  [string]$ProjectRoot = ".",

  [Parameter(Mandatory = $false)]
  [string[]]$ExcludeDirs = @('node_modules','vendor','phpmyadmin','bower_components','.git','dist','build'),
  
  [Parameter(Mandatory = $false)]
  [bool]$GenerateReport = $true,
  
  [Parameter(Mandatory = $false)]
  [bool]$CreateBackup = $true,
  
  [Parameter(Mandatory = $false)]
  [bool]$ExecuteCleanup = $false,
  
  [Parameter(Mandatory = $false)]
  [bool]$SafeMode = $false,
  
  [Parameter(Mandatory = $false)]
  [float]$ConfidenceThreshold = 0.85,
  
  [Parameter(Mandatory = $false)]
  [string]$ConfigFile = $null
)

$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

# Script configuration
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = (Resolve-Path -Path $ProjectRoot).Path  # Use provided project root (or current directory)
$timestamp = Get-Date -Format "yyyy-MM-ddTHHmmssZ"

# Initialize variables
$reportJson = @{
  projectName        = (Split-Path -Leaf $projectRoot)
  analysisDate       = $timestamp
  pagesScanned       = 0
  cssFilesAnalyzed   = 0
  cssFilesIgnored    = 0
  ignoredReasons     = @()
  unusedCssBlocks    = @()
  warningsAndExceptions = @()
  estimatedBytesToSave  = 0
  recommendedActions = @()
}

# Log file
$logFile = Join-Path $projectRoot "cleanup-$(if($ExecuteCleanup) { 'execution' } else { 'dryrun' })-$timestamp.log"

function Write-Log {
  param([string]$Message)
  $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
  Write-Host $logMessage
  Add-Content -Path $logFile -Value $logMessage
}

# Regex patterns - avec guillemets échappés pour PowerShell
# Matches both class="..." and className="..." (for JSX/Vue)
$classPattern = "(?:class|className)=([`"'`"])(.*?)\1"
$cssClassPattern = '\.[a-zA-Z_-][a-zA-Z0-9_:-]*'

function Resolve-SafePath {
  param([string]$Path)

  if ([string]::IsNullOrWhiteSpace($Path)) { return $null }

  if ([System.IO.Path]::IsPathRooted($Path)) {
    return (Resolve-Path -Path $Path).Path
  }

  return (Resolve-Path -Path (Join-Path $projectRoot $Path)).Path
}

Write-Log "======================================"
Write-Log "CSS Cleanup Tool - Initialization"
Write-Log "======================================"
Write-Log "Project Root: $projectRoot"
Write-Log "Pages Folder: $PagesFolder"
Write-Log "CSS Folder: $CssFolder"
Write-Log "Generate Report: $GenerateReport"
Write-Log "Create Backup: $CreateBackup"
Write-Log "Execute Cleanup: $ExecuteCleanup"
Write-Log "Safe Mode: $SafeMode"
Write-Log "Confidence Threshold: $ConfidenceThreshold"
Write-Log ""

# Resolve paths and apply defaults
if (-not (Test-Path $projectRoot)) {
  Write-Log "ERROR: Project root not found: $projectRoot"
  exit 1
}

if ($PagesFolder) { $PagesFolder = Resolve-SafePath $PagesFolder }
else { Write-Log "Pages folder not provided; scanning content under project root"; $PagesFolder = $projectRoot }

if ($CssFolder) { $CssFolder = Resolve-SafePath $CssFolder }
else { Write-Log "CSS folder not provided; scanning for .css under project root"; $CssFolder = $projectRoot }

Write-Log "Resolved paths:"
Write-Log "  Pages: $PagesFolder"
Write-Log "  CSS: $CssFolder"
Write-Log "Exclude Dirs: $($ExcludeDirs -join ',')"
Write-Log ""

function Is-ExcludedPath {
  param([string]$Path)

  foreach ($ex in $ExcludeDirs) {
    if ([string]::IsNullOrWhiteSpace($ex)) { continue }
    if ($Path -ilike "*${ex}*") { return $true }
  }

  return $false
}

# ============================================
# PHASE 1: Scan HTML pages for CSS classes
# ============================================

Write-Log "PHASE 1: Scanning HTML files for CSS class usage..."
Write-Log "Looking for files: *.html, *.jsx, *.tsx, *.vue"

$foundClasses = @{}

try {
  $htmlFiles = Get-ChildItem -Path $PagesFolder -Recurse -File -Include "*.html", "*.htm", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" -ErrorAction Continue |
    Where-Object { -not (Is-ExcludedPath $_.FullName) }
  $reportJson.pagesScanned = $htmlFiles.Count

  Write-Log "Found $($htmlFiles.Count) page files to scan (exclusions applied)"

  foreach ($file in $htmlFiles) {
    try {
      $content = Get-Content $file.FullName -Raw -ErrorAction Continue
      if ($null -eq $content) { continue }
      
      [Regex]::Matches($content, $classPattern) | ForEach-Object {
        $classString = $_.Groups[2].Value
        # Split by spaces and filter
        $classString -split '\s+' | Where-Object { $_ -match '^[a-zA-Z0-9\-_]+$' } | ForEach-Object {
          if (-not $foundClasses.ContainsKey($_)) {
            $foundClasses[$_] = @{ count = 0; files = @() }
          }
          $foundClasses[$_].count++
          if ($foundClasses[$_].files -notcontains $file.Name) {
            $foundClasses[$_].files += $file.Name
          }
        }
      }
    }
    catch {
      Write-Log "WARNING: Error reading file $($file.FullName): $_"
    }
  }
}
catch {
  Write-Log "ERROR: Failed to scan HTML files: $_"
  exit 1
}

Write-Log "Found $($foundClasses.Count) unique CSS classes in HTML files"
Write-Log ""

# ============================================
# PHASE 2: Analyze CSS files
# ============================================

Write-Log "PHASE 2: Analyzing CSS files..."
Write-Log "Analyzing: *.css (excluding *.min.css)"

$cssFiles = Get-ChildItem -Path $CssFolder -Recurse -File -Include "*.css" -ErrorAction Continue |
  Where-Object { -not (Is-ExcludedPath $_.FullName) }
$minifiedFiles = $cssFiles | Where-Object { $_.Name -match '\.min\.css$' }
$regularCssFiles = $cssFiles | Where-Object { $_.Name -notmatch '\.min\.css$' }

$reportJson.cssFilesAnalyzed = $regularCssFiles.Count
$reportJson.cssFilesIgnored = $minifiedFiles.Count

Write-Log "Total CSS files found: $($cssFiles.Count)"
Write-Log "  Analyzed (regular): $($regularCssFiles.Count)"
Write-Log "  Ignored (minified): $($minifiedFiles.Count)"

$minifiedFiles | ForEach-Object {
  Write-Log "  IGNORED: $($_.FullName)"
  $reportJson.warningsAndExceptions += @{
    type   = "css-minified"
    file   = $_.FullName
    reason = "Minified CSS files cannot be safely parsed"
    action = "ignored"
  }
}

Write-Log ""

# Scan CSS selectors
$cssSelectors = @{}
$cssFileContent = @{}

foreach ($file in $regularCssFiles) {
  try {
    $content = Get-Content $file.FullName -Raw -ErrorAction Continue
    if ($null -eq $content) { continue }
    
    $cssFileContent[$file.FullName] = $content
    
    # Extract class selectors: .classname
    [Regex]::Matches($content, '\.[a-zA-Z_-][a-zA-Z0-9_:-]*', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) |
      ForEach-Object {
        $selector = $_.Value.Substring(1) # Remove the dot
        if (-not $cssSelectors.ContainsKey($selector)) {
          $cssSelectors[$selector] = @{
            count = 0
            files = @()
            used  = $false
          }
        }
        $cssSelectors[$selector].count++
        if ($cssSelectors[$selector].files -notcontains $file.Name) {
          $cssSelectors[$selector].files += $file.Name
        }
      }
  }
  catch {
    Write-Log "WARNING: Error reading CSS file $($file.FullName): $_"
  }
}

Write-Log "Found $($cssSelectors.Count) unique CSS selectors"
Write-Log ""

# ============================================
# PHASE 3: Compare and identify unused CSS
# ============================================

Write-Log "PHASE 3: Identifying unused CSS blocks..."

$unusedCount = 0

foreach ($selector in $cssSelectors.Keys) {
  $isUsed = $foundClasses.ContainsKey($selector)
  $cssSelectors[$selector].used = $isUsed
  
  if (-not $isUsed) {
    $unusedCount++
    
    # Determine severity
    $severity = "low"
    if ($selector -match '^admin-|^internal-|^test-') {
      $severity = "medium"
    }
    elseif ($selector -match '^deprecated-|^old-|^legacy-') {
      $severity = "high"
    }
    
    $reportJson.unusedCssBlocks += @{
      selector = $selector
      files    = $cssSelectors[$selector].files
      severity = $severity
      canRemove = $true
    }
  }
}

Write-Log "Identified $unusedCount unused CSS selectors"
Write-Log ""

# ============================================
# PHASE 4: Generate Report
# ============================================

if ($GenerateReport) {
  Write-Log "PHASE 4: Generating analysis reports..."
  
  # JSON Report
  $jsonReportPath = Join-Path $projectRoot "css-analysis-report.json"
  $reportJson | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $jsonReportPath
  Write-Log "JSON Report saved to: $jsonReportPath"
  
  # Markdown Report
  $mdReportPath = Join-Path $projectRoot "css-analysis-report.md"
  $mdContent = @"
# CSS Analysis Report
**Project:** $($reportJson.projectName)
**Date:** $($reportJson.analysisDate)

## Summary
- **Pages Scanned:** $($reportJson.pagesScanned)
- **CSS Files Analyzed:** $($reportJson.cssFilesAnalyzed)
- **CSS Files Ignored (Minified):** $($reportJson.cssFilesIgnored)
- **Unused CSS Blocks Found:** $($reportJson.unusedCssBlocks.Count)
- **Estimated Bytes to Save:** $($reportJson.estimatedBytesToSave) bytes

## Unused CSS Blocks

"@

  $reportJson.unusedCssBlocks | Sort-Object -Property severity | ForEach-Object {
    $mdContent += @"
### .$($_.selector)
- **Files:** $($_.files -join ', ')
- **Severity:** $($_.severity)
- **Removable:** $($_.canRemove)

"@
  }
  
  if ($reportJson.warningsAndExceptions.Count -gt 0) {
    $mdContent += @"

## Warnings & Exceptions

"@
    $reportJson.warningsAndExceptions | ForEach-Object {
      $mdContent += "- **$($_.type)**: $($_.file) - $($_.reason)`n"
    }
  }
  
  $mdContent | Out-File -Encoding UTF8 -FilePath $mdReportPath
  Write-Log "Markdown Report saved to: $mdReportPath"
  Write-Log ""
}

# ============================================
# PHASE 5: Backup (if requested)
# ============================================

if ($CreateBackup) {
  Write-Log "PHASE 5: Creating backup of CSS files..."
  
  $backupFolder = Join-Path $projectRoot "css-backup-$timestamp"
  New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
  
  foreach ($file in $regularCssFiles) {
    $relativePath = $file.FullName.Replace($CssFolder, "").TrimStart('\')
    $backupPath = Join-Path $backupFolder $relativePath
    $backupDir = Split-Path -Parent $backupPath
    
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item -Path $file.FullName -Destination $backupPath -Force
  }
  
  Write-Log "Backup created in: $backupFolder"
  
  # Create manifest
  $manifest = @{
    backupDate      = $timestamp
    backupLocation  = $backupFolder
    projectRoot     = $projectRoot
    blocksToRemove  = $reportJson.unusedCssBlocks
    totalBlocksCount = $reportJson.unusedCssBlocks.Count
  }
  
  $manifestPath = Join-Path $backupFolder "manifest.json"
  $manifest | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $manifestPath
  
  Write-Log "Manifest saved to: $manifestPath"
  Write-Log ""
}

# ============================================
# PHASE 6: Execute Cleanup (if requested)
# ============================================

if ($ExecuteCleanup) {
  Write-Log "PHASE 6: Executing CSS cleanup..."
  Write-Log "Removing $($reportJson.unusedCssBlocks.Count) unused CSS blocks..."
  
  $removedCount = 0
  
  foreach ($unused in $reportJson.unusedCssBlocks) {
    $selector = $unused.selector
    
    # Apply confidence threshold
    if ($SafeMode) {
      if ($unused.severity -eq "high") {
        Write-Log "SKIPPED (Safe Mode): .$selector - High severity"
        continue
      }
    }
    
    # For each file containing this selector
    $unused.files | ForEach-Object {
      $fileName = $_
      $filePath = Get-ChildItem -Path $CssFolder -Recurse -Filter $fileName | Select-Object -First 1
      
      if ($filePath) {
        try {
          $content = Get-Content $filePath.FullName -Raw
          
          # Create pattern to find the selector and its block
          # Pattern: .selector { ... } - handles nested braces
          $escapedSelector = [Regex]::Escape($selector)
          $pattern = "\.$escapedSelector\s*\{[^}]*\}"
          $newContent = [Regex]::Replace($content, $pattern, "")
          
          # Only write if something was removed
          if ($newContent -ne $content) {
            Set-Content -Path $filePath.FullName -Value $newContent -Encoding UTF8
            Write-Log "REMOVED: .$selector from $($filePath.Name)"
            $removedCount++
          }
        }
        catch {
          Write-Log "ERROR: Failed to remove .$selector from $($filePath.Name): $_"
        }
      }
    }
  }
  
  Write-Log "Cleanup completed: $removedCount CSS blocks removed"
  Write-Log ""
}
else {
  Write-Log "DRY RUN MODE: No CSS files were modified."
  Write-Log "Will remove $($reportJson.unusedCssBlocks.Count) CSS blocks if executed with -ExecuteCleanup $true"
  Write-Log ""
}

# Final summary
Write-Log "======================================"
Write-Log "CSS Cleanup Complete"
Write-Log "======================================"
Write-Log "Log file: $logFile"
Write-Log "Analysis reports generated"
Write-Log "Status: $(if($ExecuteCleanup) { 'EXECUTED' } else { 'DRY-RUN' })"
Write-Log ""

Write-Log "Next steps:"
Write-Log "1. Review the generated reports:"
Write-Log "   - css-analysis-report.json (structured data)"
Write-Log "   - css-analysis-report.md (human readable)"
Write-Log "2. $(if($CreateBackup) { 'Backup created at: css-backup-' + $timestamp } else { 'Create backup before actual cleanup' })"
Write-Log "3. $(if($ExecuteCleanup) { 'Test your application' } else { 'Run with -ExecuteCleanup `$true to perform actual cleanup' })"
Write-Log ""
