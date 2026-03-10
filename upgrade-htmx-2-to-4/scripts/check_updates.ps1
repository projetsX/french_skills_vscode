param(
    [switch]$UpdateLocalIfChanged = $false
)

$baseDir = Split-Path -Parent $PSScriptRoot
$refDir = Join-Path $baseDir 'references'

$urls = @{
    'htmx-guidance.md' = 'https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/htmx-guidance.md'
    'upgrade-from-htmx2.md' = 'https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/upgrade-from-htmx2.md'
}

if (-not (Test-Path $refDir)) { New-Item -ItemType Directory -Path $refDir | Out-Null }

$changed = $false

foreach ($name in $urls.Keys) {
    $url = $urls[$name]
    $localPath = Join-Path $refDir $name
    Write-Host "Récupération de $url"
    try {
        $remote = Invoke-RestMethod -Uri $url -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Error "Impossible de récupérer $url : $_"
        exit 2
    }

    $tmp = New-TemporaryFile
    $remote | Out-File -FilePath $tmp -Encoding utf8

    if (-not (Test-Path $localPath)) {
        Write-Host "Fichier local absent: $name"
        $changed = $true
        if ($UpdateLocalIfChanged) {
            Copy-Item -Path $tmp -Destination $localPath -Force
            Write-Host "Fichier local $name créé à partir de la source distante."
        }
    } else {
        $localContent = Get-Content $localPath -Raw -ErrorAction SilentlyContinue
        $remoteContent = Get-Content $tmp -Raw -ErrorAction SilentlyContinue
        if ($localContent -ne $remoteContent) {
            Write-Host "Changements détectés dans $name"
            $changed = $true
            if ($UpdateLocalIfChanged) {
                Copy-Item -Path $tmp -Destination $localPath -Force
                Write-Host "Fichier local $name mis à jour."
            }
        } else {
            Write-Host "Aucun changement dans $name"
        }
    }

    Remove-Item $tmp -Force
}

if (-not $changed) { Write-Host "Aucune modification détectée." }

exit 0
