# Generate CSS Refactoring Report
# Usage: ./generate-report.ps1 -OriginalFile "style.css" -RefactoredFile "style-new.css"

param(
    [Parameter(Mandatory = $true)]
    [string]$OriginalFile,
    
    [Parameter(Mandatory = $true)]
    [string]$RefactoredFile,
    
    [string]$OutputPath,
    
    [string[]]$Changes = @()
)

# Validate files exist
if (-not (Test-Path $OriginalFile)) {
    Write-Error "Original file not found: $OriginalFile"
    exit 1
}

if (-not (Test-Path $RefactoredFile)) {
    Write-Error "Refactored file not found: $RefactoredFile"
    exit 1
}

# If no output path specified, create in same location as refactored file
if (-not $OutputPath) {
    $parentPath = Split-Path -Path $RefactoredFile
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path -Path $parentPath -ChildPath "refactoring-report-$timestamp.md"
}

# Get file statistics
$originalContent = Get-Content -Path $OriginalFile -Raw
$refactoredContent = Get-Content -Path $RefactoredFile -Raw

$originalLines = @($originalContent -split "`n").Count
$refactoredLines = @($refactoredContent -split "`n").Count
$originalSize = (Get-Item $OriginalFile).Length
$refactoredSize = (Get-Item $RefactoredFile).Length

$lineReduction = $originalLines - $refactoredLines
$sizeReduction = $originalSize - $refactoredSize
$sizeReductionPercent = if ($originalSize -gt 0) { 
    [math]::Round(($sizeReduction / $originalSize) * 100, 2) 
} else { 0 }

$timestamp = Get-Date -Format "dd MMMM yyyy HH:mm:ss"

# Generate report
$reportContent = @"
# CSS Refactoring Report

**Generated:** $timestamp

## Summary

| Metric | Original | Refactored | Change |
|--------|----------|-----------|--------|
| Lines | $originalLines | $refactoredLines | -$lineReduction lines |
| File Size | $([math]::Round($originalSize / 1KB, 2)) KB | $([math]::Round($refactoredSize / 1KB, 2)) KB | -$sizeReductionPercent% |

## Changes Applied

$( if ($Changes.Count -gt 0) {
    $Changes | ForEach-Object { "- $_" }
} else {
    "Please review the differences between original and refactored files."
})

## MDN Best Practices Applied

- [ ] Modern layout methods (Flexbox, Grid instead of floats)
- [ ] CSS custom properties for repeated values
- [ ] Simplified selectors and reduced specificity
- [ ] Removed deprecated properties and vendor prefixes
- [ ] Improved class naming conventions
- [ ] Eliminated redundant and repetitive rules
- [ ] Added comments for complex selectors
- [ ] Optimized selector performance

## Files

- **Original:** $OriginalFile
- **Refactored:** $RefactoredFile
- **Backup location:** Check for `.backup-*` files in the same directory

## Next Steps

1. Review the diff between original and refactored versions
2. Test in browser to verify styling is unchanged
3. Run CSS validation/linting tools
4. Commit changes with reference to MDN documentation
5. Deploy to production

## Reference

- [MDN CSS Best Practices](https://developer.mozilla.org/en-US/docs/Web/CSS)
- [CSS Selectors Performance](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Selectors)
- [CSS Variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
"@

try {
    $reportContent | Out-File -FilePath $OutputPath -Encoding UTF8 -Force
    Write-Host "✓ Report generated successfully" -ForegroundColor Green
    Write-Host "  Location: $OutputPath" -ForegroundColor Green
    exit 0
}
catch {
    Write-Error "Failed to generate report: $_"
    exit 1
}
