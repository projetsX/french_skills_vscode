Param(
    [string]$Config = ".gitleaks.toml",
    [switch]$ForceDocker
)

Write-Host "Run gitleaks: recherche du binaire local..."

$gitleaksCmd = Get-Command gitleaks -ErrorAction SilentlyContinue

if ($gitleaksCmd -and -not $ForceDocker) {
    Write-Host "Utilisation du binaire local gitleaks: $($gitleaksCmd.Path)"
    & "$($gitleaksCmd.Path)" detect --source=. --config=$Config --verbose
    exit $LASTEXITCODE
}

Write-Host "Binaire local non trouvé ou Docker forcé — tentative via Docker..."

$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerCmd) {
    Write-Error "Docker introuvable et gitleaks non installé. Installez gitleaks localement ou Docker pour exécuter ce script."
    exit 2
}

$pwdPath = ${PWD}.Path
Write-Host "Lancement de l'image gitleaks (Docker), montage: $pwdPath -> /src"
$volume = "$pwdPath:/src"
& docker run --rm -v $volume ghcr.io/zricethezav/gitleaks:8.4.0 detect --source=/src --config=/src/$Config --verbose

Write-Host 'Fin du scan. Pour forcer l''utilisation de Docker: .\scripts\run-gitleaks.ps1 -ForceDocker'