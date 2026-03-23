---
name: cleanup-unused-css
description: 'Analyze and remove unused CSS blocks from a website project. Use when: cleaning up CSS files, removing dead code, optimizing bundle size, comparing CSS classes with HTML files, generating CSS usage reports.'
argument-hint: '[PROJECT_ROOT] [CSS_FOLDER_PATH] - Path to project root (scan entire site) and optional CSS folder. Exclude common third-party dirs: node_modules, vendor, phpmyadmin, bower_components, .git'
user-invocable: true
---

# Nettoyer et supprimer les blocs CSS inutilisés

Flux de travail procédural pour analyser une pile CSS, identifier les blocs inutilisés en comparant avec le code HTML, et générer des rapports d'optimisation sécurisée avec scripts de suppression de masse et sauvegarde préalable.

## Quand l'utiliser

- Nettoyer des fichiers CSS obsolètes après refonte ou suppression de pages
- Optimiser la taille du bundle CSS en identifiant le code mort
- Générer un rapport sur les règles CSS inutilisées dans un projet
- Comparer l'utilisation réelle des classes CSS dans le code HTML
- Préparer un script de suppression de masse avec sauvegarde de sécurité
- Analyser un projet avant migration ou refactorisation majeure

## Prérequis

- L'accès aux fichiers HTML/JSX/Vue du projet (fichiers pages)
- L'accès aux fichiers CSS du projet (feuilles de styles)
- Les fichiers CSS ne doivent PAS être minifiés (sinon, les ignorer)
- Connaissance de la structure du projet (où se trouvent les pages et les CSS)

## Procédure étape par étape

### Phase 1 : Analyse et découverte

**1. Identifier les cibles et la racine du scan**

- `[PROJECT_ROOT]` : Chemin vers la racine du projet — le script scannera l'arborescence entière à partir de la racine
  - Exemple : `.` ou `C:/repo/mon-projet`
  - Le script parcourra récursivement la racine DU PROJET mais IGNORERA les répertoires tiers listés dans la section "Exclusions" ci-dessous
- `[CSS_FOLDER_PATH]` : Dossier contenant tous les fichiers CSS du projet (optionnel si déduisible depuis la racine)
  - Exemple : `src/styles/`, `assets/css/`, `public/css/`

**Remarque** : Par défaut on scanne depuis la racine du dépôt/projet afin de couvrir l'ensemble du site; pour éviter d'analyser de la librairie tierce, fournir la liste `-ExcludeDirs` (node_modules, vendor, phpmyadmin, etc.).

**2. Scanner le site depuis la racine (avec exclusions)**

```bash
# Le script va :
# - Parcourir récursivement la racine du projet ([PROJECT_ROOT])
# - Ignorer les répertoires tiers (node_modules, vendor, phpmyadmin, bower_components, .git, etc.)
# - Extraire tous les noms de classes CSS trouvés dans les fichiers HTML/JSX/TSX/Vue/JS
# - Créer une liste des classes utilisées dans le code
```

**Exemple de commande PowerShell (scan racine avec filtres d'exclusion) :**
```powershell
# Scanner la racine en excluant les dossiers tiers (dry-run)
$excludes = 'node_modules','vendor','phpmyadmin','bower_components','.git'
Get-ChildItem -Path "." -Recurse -File -Include *.html,*.htm,*.js,*.jsx,*.ts,*.tsx,*.vue |
  Where-Object { $p = $_.FullName; -not ($excludes | ForEach-Object { $p -like "*$_*" } | Where-Object { $_ }) } |
  Select-String -Pattern 'class=["\\']([^"\\']+)["\\']' |
  ForEach-Object { $_.Matches.Groups[1].Value } |
  Sort-Object -Unique
```

**3. Analyser les fichiers CSS**

```bash
# Le script va :
# - Examiner les fichiers CSS dans [CSS_FOLDER_PATH]
# - Détecter les minifiés (*.min.css) et les ignorer
# - Parser les sélecteurs CSS et les classes
# - Identifier les media queries, pseudo-classes, et animations
```

### Phase 2 : Détection des CSS inutilisés

**1. Comparer les classes CSS trouvées avec les fichiers CSS**

- Extraire tous les sélecteurs CSS des fichiers non-minifiés
- Croiser avec la liste des classes utilisées dans les pages
- Identifier les blocs CSS orphelins (jamais utilisés en HTML)

**2. Gérer les cas spéciaux**

- ⚠️ **Ignorer les minifiés** : Les fichiers `*.min.css` ne seront PAS analysés
- ⚠️ **CSS dynamiques** : Les classes ajoutées via JavaScript runtime peuvent ne pas être détectées
- ⚠️ **CSS critiques** : Certaines classes peuvent être essentielles au fonctionnement (alerts, animations, themes)
- ✅ **CSS héritées** : Les classes héritées mais écrasées sont généralement sûres à supprimer

**3. Règles de sécurité**

```
NE PAS supprimer :
- Les CSS minifiés (*.min.css)
- Les classes bootstrap/framework classiques sans preuve d'utilisation
- Les keyframes d'animation si des classes l'utilisent indirectement
- Les pseudo-classes et states (:hover, :active, :focus, :disabled, etc.)
- Les media queries sans confirmation qu'aucune classe n'est utilisée
```

### Phase 3 : Rapport et validation

**1. Générer le rapport d'analyse**

Le script créera un rapport JSON structuré :

```json
{
  "projectName": "mon-site",
  "analysisDate": "2026-03-10T14:30:00Z",
  "pagesScanned": 45,
  "cssFilesAnalyzed": 12,
  "cssFilesIgnored": 3,
  "ignoredReason": ["minified"],
  "unusedCssBlocks": [
    {
      "selector": ".old-banner",
      "filename": "src/styles/legacy.css",
      "lineNumber": 142,
      "lineCount": 8,
      "severity": "low",
      "canRemove": true
    },
    {
      "selector": ".admin-only .special-form",
      "filename": "src/styles/admin.css",
      "lineNumber": 456,
      "lineCount": 12,
      "severity": "medium",
      "canRemove": true
    }
  ],
  "warningsAndExceptions": [
    {
      "type": "css-minified",
      "file": "src/styles/vendor.min.css",
      "action": "ignored"
    }
  ],
  "estimatedBytesToSave": 24500,
  "recommendedActions": [
    "Remove .old-banner selector from legacy.css",
    "Review .admin-only .special-form before removal"
  ]
}
```

**2. Fichier rapport `.md` pour révision humaine**

```markdown
# Rapport d'analyse CSS - mon-site
Date : 10 mars 2026

## Résumé
- Pages scannées : 45
- Fichiers CSS : 12 analysés (3 avez minifiés ignorés)
- Blocs CSS inutilisés trouvés : 8
- Économies estimées : 24.5 KB

## Blocs supprimables (Sécurité HAUTE)
### 1. .old-banner (legacy.css:142)
Raison : Jamais utilisé en HTML
Taille estimée : ~200 bytes
Recommandation : SUPPRIMER SANS RISQUE

## Blocs supprimables (Sécurité MOYENNE)
### 2. .admin-only .special-form (admin.css:456)
Raison : Seulement utilisé dans le dossier /admin/pages
Taille estimée : ~400 bytes
Recommandation : SUPPRIMER (après test)

## Fichiers ignorés (Minifiés)
- vendor.min.css (raison : minifié)
- bootstrap.min.css (raison : minifié)
```

### Phase 4 : Sauvegarde préalable

**1. Créer un backup des fichiers CSS**

```bash
# Le script va :
# - Créer un dossier [PROJECT_ROOT]/css-backup-TIMESTAMP/
# - Copier tous les fichiers CSS NON-minifiés dedans
# - Créer un manifest.json listant les fichiers et les lignes supprimées
```

**Exemple de structure backup :**
```
css-backup-2026-03-10T143000Z/
├── manifest.json           # Métadonnées de sauvegarde
├── src-styles-admin.css    # Copie préservée
├── src-styles-legacy.css
└── restore-backup.ps1      # Script de restauration automatique
```

**2. Fichier manifest de sauvegarde**

```json
{
  "backupDate": "2026-03-10T14:30:00Z",
  "backupLocation": "css-backup-2026-03-10T143000Z",
  "projectRoot": ".",
  "blocksRemoved": [
    {
      "filename": "src/styles/legacy.css",
      "selector": ".old-banner",
      "lineStart": 142,
      "lineEnd": 150,
      "content": "/* CSS code here */"
    }
  ],
  "restoreCommand": "PowerShell -ExecutionPolicy Bypass -File css-backup-2026-03-10T143000Z/restore-backup.ps1"
}
```

### Phase 5 : Suppression de masse (optionnel)

**1. Générer le script PowerShell de nettoyage**

```powershell
# Le script va :
# - Charger la liste des blocs à supprimer depuis le rapport
# - Créer des patterns regex pour matcher les sélecteurs
# - Supprimer LIGNE PAR LIGNE les blocs CSS identifiés
# - Vérifier la syntaxe CSS après suppression (accolades fermées, etc.)
# - Générer un log des modifications
```

**Exemple d'exécution :**
```powershell
.\scripts\cleanup-unused-css.ps1 `
  -ProjectRoot "." `
  -CssFolder "src/styles" `
  -ExcludeDirs @('node_modules','vendor','phpmyadmin','bower_components','.git') `
  -GenerateReport `
  -CreateBackup `
  -ExecuteCleanup $false  # Dry-run par défaut
```

**2. Exécuter en mode "dry-run" d'abord**

```powershell
# Affiche ce qui SERAIT supprimé SANS effectuer les modifications
.\scripts\cleanup-unused-css.ps1 `
  -ProjectRoot "." `
  -CssFolder "src/styles" `
  -ExcludeDirs @('node_modules','vendor','phpmyadmin','bower_components','.git') `
  -ExecuteCleanup $false
```

**3. Exécuter le nettoyage réel**

```powershell
# Après vérification du rapport dry-run:
.\scripts\cleanup-unused-css.ps1 `
  -ProjectRoot "." `
  -CssFolder "src/styles" `
  -ExcludeDirs @('node_modules','vendor','phpmyadmin','bower_components','.git') `
  -ExecuteCleanup $true `
  -CreateBackup $true
```

## Scripts fournis

| Script | Objectif | Usage |
|--------|----------|-------|
| `cleanup-unused-css.ps1` | Orchestration complète du flux | Principal |
| `generate-css-report.ps1` | Générer le rapport d'analyse | Analyse uniquement |
| `backup-css.ps1` | Créer une sauvegarde des CSS | Avant suppression |
| `restore-css.ps1` | Restaurer depuis une sauvegarde | En cas de problème |

## Considérations de sécurité

✅ **À FAIRE :**
- Toujours générer un rapport avant de supprimer
- Créer une sauvegarde avant la suppression
- Tester en mode "dry-run" d'abord
- Commiter le code dans Git avant suppression
- Vérifier que les animations/themes ne sont pas cassées
- Vérifier que les classes JavaScript dynamiques ne sont pas supprimées

❌ **À NE PAS FAIRE :**
- Toucher à des fichiers `*.min.css`
- Supprimer sans sauvegarde préalable
- Supprimer sans rapport d'analyse
- Modifier les fichiers CSS en production sans test
- Ignorer les warnings dans le rapport

## Références

- Voir [css-analysis-guide.md](references/css-analysis-guide.md) pour des techniques d'analyse avancée
- Voir [cleanup-checklist.md](references/cleanup-checklist.md) pour la checklist complète
- Voir [safety-considerations.md](references/safety-considerations.md) pour les cas d'exception
