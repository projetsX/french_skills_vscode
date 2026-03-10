param(
    [string]$ThemeName = 'bootstrap',
    [string]$ThemePath = '.'
)

Write-Host "Preparation de la conversion du theme React pour : $ThemeName"

# Create directory structure (forces creation of parent directories)
$paths = @(
    "src/assets/$ThemeName/css",
    "src/assets/$ThemeName/js",
    "src/assets/$ThemeName/images",
    "src/components",
    "src/hooks"
)

foreach ($p in $paths) {
    $full = Join-Path $ThemePath $p
    New-Item -Path $full -ItemType Directory -Force | Out-Null
}

Write-Host "Structure de repertoires creee :"
Write-Host "   src/assets/$ThemeName/"
Write-Host "   - css/"
Write-Host "   - js/"
Write-Host "   - images/"

Write-Host ""
Write-Host "Etapes suivantes :"
Write-Host "1. Copier les fichiers CSS du theme vers : src/assets/$ThemeName/css/"
Write-Host "2. Copier les fichiers JS du theme vers : src/assets/$ThemeName/js/ (a titre de reference)"
Write-Host "3. Copier les images du theme vers : src/assets/$ThemeName/images/"
Write-Host ""
Write-Host "4. Ajouter les imports dans src/main.tsx :"
Write-Host "   import './assets/$ThemeName/css/main.css'"
Write-Host "   import './assets/$ThemeName/css/theme.css'"
Write-Host ""
Write-Host "5. Creer les composants React dans src/components/"
Write-Host "6. Extraire les animations dans src/hooks/useAnimation*.ts"
Write-Host "7. Lancer 'npm run dev' et comparer avec le theme original"
Write-Host ""
Write-Host "Se referer a SKILL.md pour la procedure detaillee"
