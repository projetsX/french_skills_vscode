<#
.SYNOPSIS
Generates an analysis report of unused CSS blocks without modifying files.

.DESCRIPTION
This script:
1. Scans HTML pages for CSS class usage
2. Analyzes CSS files
3. Generates JSON and Markdown reports showing unused CSS blocks
4. Does NOT modify any files

.PARAMETER PagesFolder
The folder containing HTML pages to scan.

.PARAMETER CssFolder
The folder containing CSS files to analyze.

.EXAMPLE
.\generate-css-report.ps1 -PagesFolder "src/pages" -CssFolder "src/styles"
#>

param(
  [Parameter(Mandatory = $false)]
  [string]$PagesFolder = "src/pages",
  
  [Parameter(Mandatory = $false)]
  [string]$CssFolder = "src/styles"
)

$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$cleanupScript = Join-Path $scriptRoot "cleanup-unused-css.ps1"

# Call the main cleanup script in report-only mode
& $cleanupScript `
  -PagesFolder $PagesFolder `
  -CssFolder $CssFolder `
  -GenerateReport $true `
  -CreateBackup $false `
  -ExecuteCleanup $false
