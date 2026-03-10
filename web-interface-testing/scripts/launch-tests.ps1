# Script PowerShell - Aide au test d'interface web
# Usage: .\launch-tests.ps1 -PagePath "/contact" -ProjectType "vite" -VitePort 5173

param(
    [string]$PagePath = "/",
    [string]$ProjectType = "vite",  # vite ou php
    [int]$VitePort = 5173,
    [string]$PhpDomain = ""
)

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Web Interface Testing - Helper Script" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Valider inputs
if ($PagePath -eq "") {
    Write-Host "[ERROR] PagePath requis" -ForegroundColor Red
    Write-Host "Usage: .\launch-tests.ps1 -PagePath '/contact' -ProjectType 'vite' -VitePort 5173"
    exit 1
}

if ($ProjectType -notin @("vite", "php")) {
    Write-Host "[ERROR] ProjectType doit être 'vite' ou 'php'" -ForegroundColor Red
    exit 1
}

# Construire URL
$FullUrl = ""

if ($ProjectType -eq "vite") {
    $FullUrl = "http://localhost:$VitePort$PagePath"
    Write-Host "[OK] Type de projet: Vite (port $VitePort)" -ForegroundColor Green
}
elseif ($ProjectType -eq "php") {
    if ($PhpDomain -eq "") {
        Write-Host "[ERROR] PhpDomain requis pour PHP projects" -ForegroundColor Red
        Write-Host "Usage: .\launch-tests.ps1 -PagePath '/signup' -ProjectType 'php' -PhpDomain 'monsite'"
        exit 1
    }
    $FullUrl = "https://$PhpDomain.loc$PagePath"
    Write-Host "[OK] Type de projet: PHP (domaine $PhpDomain.loc)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[PAGE] Page cible: $PagePath" -ForegroundColor Cyan
Write-Host "[URL] URL complète: $FullUrl" -ForegroundColor Cyan
Write-Host ""

# Afficher checklist de test
Write-Host "Phases de test à exécuter:" -ForegroundColor Yellow
Write-Host "  1. [OK] Vérifier accès (status 200)"
Write-Host "  2. [!] Console DevTools (erreurs, warnings)"
Write-Host "  3. [A11Y] Accessibilité WCAG (alt text, labels, hierarchy)"
Write-Host "  4. [FORM] Inputs interactifs (forms, buttons, search)"
Write-Host "  5. [MOBILE] Ergonomie Desktop + Mobile (1920x1080, 375x812, 768x1024)"
Write-Host "  6. [PERF] Performances (CWV, CPU, RAM)"
Write-Host "  7. [REPORT] Résumé & Corrections"
Write-Host ""

Write-Host "[INFO] Instructions:" -ForegroundColor Yellow
Write-Host "  1. Utiliser tools MCP Chrome DevTools (mcp_chromedevtool_*)"
Write-Host "  2. Référence: $PSScriptRoot\..\references\mcp-chrome-reference.md"
Write-Host "  3. Checklist: $PSScriptRoot\..\references\test-checklist.md"
Write-Host ""

Write-Host "[START] Prêt à démarrer les tests!" -ForegroundColor Green
Write-Host "   Appuyez sur [Enter] pour continuer..."

Read-Host

Write-Host ""
Write-Host "[CIBLE] Aller à: $FullUrl" -ForegroundColor Cyan
Write-Host "Utiliser les tools MCP pour tester les phases 1-7"
Write-Host ""
