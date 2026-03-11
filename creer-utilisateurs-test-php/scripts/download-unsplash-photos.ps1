# PowerShell script pour telecharger des photos de profil depuis Unsplash
# Usage: .\download-unsplash-photos.ps1
# Requiert une cle API Unsplash (gratuite)

param(
    [string]$OutputDir = "photos_source",
    [string]$AccessKey = "",
    [string]$EnvFile = ".env",
    [int]$CountMale = 6,
    [int]$CountFemale = 6,
    [int]$PhotosPerProfile = 9
)

# ============================================================================
# CONFIGURATION
# ============================================================================

# Resoudre le chemin du repertoire du script
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Fonction pour charger le fichier .env
function Load-EnvFile {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        Write-Host "[*] Chargement des cles API depuis $FilePath..." -ForegroundColor Cyan
        $envContent = Get-Content $FilePath -Raw
        
        # Parser les lignes KEY=VALUE
        $envContent -split "`n" | ForEach-Object {
            $line = $_.Trim()
            if ($line -and -not $line.StartsWith('#')) {
                $parts = $line -split '=', 2
                if ($parts.Count -eq 2) {
                    $key = $parts[0].Trim()
                    $value = $parts[1].Trim()
                    [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
                }
            }
        }
        return $true
    }
    return $false
}

# Chercher le fichier .env (d'abord dans le repertoire du script, puis courant)
$EnvFilePath = $EnvFile
if (-not (Test-Path $EnvFilePath)) {
    $ScriptEnvFile = Join-Path -Path $ScriptDir -ChildPath ".env"
    if (Test-Path $ScriptEnvFile) {
        $EnvFilePath = $ScriptEnvFile
    }
}

# Charger les variables depuis .env
$envLoaded = Load-EnvFile -FilePath $EnvFilePath

# Si pas de cle en parametre, utiliser celle du .env
if (-not $AccessKey) {
    $AccessKey = [System.Environment]::GetEnvironmentVariable("UNSPLASH_ACCESS_KEY", "Process")
}

if (-not $AccessKey) {
    Write-Host "[!] Cle API Unsplash requise!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Solution 1 : Creer un fichier .env avec votre cle :" -ForegroundColor Yellow
    Write-Host "  UNSPLASH_ACCESS_KEY=votre_cle_ici" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Solution 2 : Passer la cle en parametre :" -ForegroundColor Yellow
    Write-Host "  .\download-unsplash-photos.ps1 -AccessKey 'votre_cle'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Pour obtenir une cle gratuite :" -ForegroundColor Cyan
    Write-Host "  -> https://unsplash.com/oauth/applications" -ForegroundColor Gray
    exit 1
}

$ApiBase = "https://api.unsplash.com"

# ============================================================================
# FONCTIONS
# ============================================================================

function Get-RandomPhoto {
    param(
        [string]$Query,
        [int]$Limit = 1
    )
    
    $uri = $ApiBase + '/photos/random?query=' + [Uri]::EscapeDataString($Query) + '&count=' + $Limit + '&client_id=' + $AccessKey
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 10
        return $response
    } catch {
        Write-Host "[x] Erreur API : $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Download-Image {
    param(
        [string]$Url,
        [string]$OutputPath
    )
    
    try {
        $parent = Split-Path $OutputPath
        if (-not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        
        Invoke-WebRequest -Uri $url -OutFile $OutputPath -TimeoutSec 15
        return $true
    } catch {
        Write-Host "[x] Erreur telechargement : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# TELECHARGEMENT
# ============================================================================

Write-Host "[>] Telechargement des photos...`n" -ForegroundColor Cyan

$downloaded = 0
$failed = 0

# HOMMES
for ($profile = 1; $profile -le $CountMale; $profile++) {
    $profileDir = Join-Path -Path (Join-Path -Path $OutputDir -ChildPath "HOMMES") -ChildPath "profil$profile"
    Write-Host "[+] Profil homme $profile..." -ForegroundColor Yellow
    
    # Selectionner une requete
    $searches = @(
        "man portrait",
        "handsome man",
        "male professional",
        "young man headshot"
    )
    $query = $searches[(Get-Random -Minimum 0 -Maximum $searches.Count)]
    
    # Recuperer un batch de photos (optimisation API)
    $photoBatch = Get-RandomPhoto -Query $query -Limit $PhotosPerProfile
    
    if ($photoBatch) {
        # Gerer les cas array et objet unique
        $photoCount = if ($photoBatch -is [array]) { $photoBatch.Count } else { 1 }
        $photoCount = [Math]::Min($photoCount, $PhotosPerProfile)
        
        for ($i = 0; $i -lt $photoCount; $i++) {
            $photo = if ($photoBatch -is [array]) { $photoBatch[$i] } else { $photoBatch }
            $downloadUrl = $photo.urls.regular
            $filename = "photo_$($i+1).jpg"
            $filepath = Join-Path -Path $profileDir -ChildPath $filename
            
            if (Download-Image -Url $downloadUrl -OutputPath $filepath) {
                Write-Host "  [OK] $filename" -ForegroundColor Green
                $downloaded++
            } else {
                $failed++
            }
        }
        
        # Rate limiting
        Start-Sleep -Milliseconds 800
    }
}

# FEMMES
for ($profile = 1; $profile -le $CountFemale; $profile++) {
    $profileDir = Join-Path -Path (Join-Path -Path $OutputDir -ChildPath "FEMMES") -ChildPath "profil$profile"
    Write-Host "[+] Profil femme $profile..." -ForegroundColor Yellow
    
    # Selectionner une requete
    $searches = @(
        "woman portrait",
        "beautiful young woman",
        "female professional",
        "young woman headshot"
    )
    $query = $searches[(Get-Random -Minimum 0 -Maximum $searches.Count)]
    
    # Recuperer un batch de photos (optimisation API)
    $photoBatch = Get-RandomPhoto -Query $query -Limit $PhotosPerProfile
    
    if ($photoBatch) {
        # Gerer les cas array et objet unique
        $photoCount = if ($photoBatch -is [array]) { $photoBatch.Count } else { 1 }
        $photoCount = [Math]::Min($photoCount, $PhotosPerProfile)
        
        for ($i = 0; $i -lt $photoCount; $i++) {
            $photo = if ($photoBatch -is [array]) { $photoBatch[$i] } else { $photoBatch }
            $downloadUrl = $photo.urls.regular
            $filename = "photo_$($i+1).jpg"
            $filepath = Join-Path -Path $profileDir -ChildPath $filename
            
            if (Download-Image -Url $downloadUrl -OutputPath $filepath) {
                Write-Host "  [OK] $filename" -ForegroundColor Green
                $downloaded++
            } else {
                $failed++
            }
        }
        
        # Rate limiting
        Start-Sleep -Milliseconds 800
    }
}

# ============================================================================
# RAPPORT
# ============================================================================

Write-Host "`n====================================" -ForegroundColor Cyan
Write-Host "[+] Photos telechargees : $downloaded" -ForegroundColor Green
Write-Host "[x] Erreurs : $failed"
if (Test-Path $OutputDir) {
    Write-Host "[*] Dossier : $(Get-Item $OutputDir | Select-Object -ExpandProperty FullName)"
}
Write-Host "====================================" -ForegroundColor Cyan

# Verifier la structure
if (Test-Path $OutputDir) {
    $totalFolders = @(Get-ChildItem -Path $OutputDir -Recurse -Directory 2>$null).Count
    $totalImages = @(Get-ChildItem -Path $OutputDir -Recurse -File -Filter "*.jpg" 2>$null).Count
    
    Write-Host ""
    Write-Host "Recapitulatif :"
    Write-Host "  - Dossiers crees : $totalFolders"
    Write-Host "  - Images totales : $totalImages"
}

Write-Host ""
Write-Host "Pret pour generer le script PHP !"
Write-Host ""
