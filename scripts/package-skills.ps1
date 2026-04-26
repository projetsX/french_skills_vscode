# =============================================================================
# package-skills.ps1
# Crée un ZIP par dossier de skill dans le sous-dossier "zips/"
#
# Structure garantie dans chaque ZIP :
#   my-skill.zip
#   └── my-skill/
#       ├── SKILL.md
#       └── ...
# =============================================================================

$skillsRoot = Split-Path $PSScriptRoot -Parent
$zipsFolder = Join-Path $skillsRoot "zips"

# Dossiers à exclure (ne sont pas des skills)
$excludeFolders = @("zips", "scripts", ".git", ".github")

# Créer le dossier zips s'il n'existe pas
if (-not (Test-Path $zipsFolder)) {
    New-Item -ItemType Directory -Path $zipsFolder | Out-Null
    Write-Host "Dossier créé : $zipsFolder" -ForegroundColor DarkGray
}

# Récupérer tous les dossiers de skills
$skillFolders = Get-ChildItem -Path $skillsRoot -Directory |
    Where-Object { $_.Name -notin $excludeFolders }

if ($skillFolders.Count -eq 0) {
    Write-Host "Aucun dossier de skill trouvé." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Empaquetage des skills..." -ForegroundColor Cyan
Write-Host ("-" * 50)

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

$success = 0
$errors  = 0

foreach ($folder in $skillFolders) {
    $zipPath = Join-Path $zipsFolder "$($folder.Name).zip"

    # Supprimer le ZIP existant pour repartir propre
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    try {
        # Utiliser ZipArchive .NET pour forcer les slashes "/" dans les chemins
        # (Compress-Archive utilise des backslashes Windows, rejetés par Claude Desktop)
        $stream  = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::Create)
        $archive = New-Object System.IO.Compression.ZipArchive($stream, [System.IO.Compression.ZipArchiveMode]::Create)

        $files = Get-ChildItem -Path $folder.FullName -Recurse -File
        foreach ($file in $files) {
            # Chemin relatif depuis la racine des skills, avec slashes avant
            $relativePath = $file.FullName.Substring($skillsRoot.Length + 1).Replace('\', '/')
            $entry       = $archive.CreateEntry($relativePath, [System.IO.Compression.CompressionLevel]::Optimal)
            $entryStream = $entry.Open()
            $fileStream  = [System.IO.File]::OpenRead($file.FullName)
            $fileStream.CopyTo($entryStream)
            $fileStream.Dispose()
            $entryStream.Dispose()
        }

        $archive.Dispose()
        $stream.Dispose()

        Write-Host "  [OK] $($folder.Name).zip" -ForegroundColor Green
        $success++
    }
    catch {
        Write-Host "  [ERREUR] $($folder.Name) : $_" -ForegroundColor Red
        if ($stream) { $stream.Dispose() }
        $errors++
    }
}

Write-Host ("-" * 50)
Write-Host ""
Write-Host "$success skill(s) empaqueté(s) avec succès." -ForegroundColor Green
if ($errors -gt 0) {
    Write-Host "$errors erreur(s) rencontrée(s)." -ForegroundColor Red
}
Write-Host "Dossier de sortie : $zipsFolder" -ForegroundColor DarkGray
Write-Host ""
