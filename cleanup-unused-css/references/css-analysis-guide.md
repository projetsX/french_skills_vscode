# Guide d'analyse CSS

## Techniques pour scanner les HTML et extraire les classes CSS

### 1. Extraction des classes depuis les fichiers HTML/JSX/Vue

```powershell
# Pattern regex pour trouver les classes CSS en HTML
$classPattern = 'class=["\']([^"\']+)["\']'

# Scanner un dossier récursivement
Get-ChildItem -Path "src/pages" -Recurse -Include "*.html", "*.jsx", "*.tsx", "*.vue" |
  ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    [Regex]::Matches($content, $classPattern) |
      ForEach-Object { $_.Groups[1].Value } |
      ForEach-Object { $_ -split '\s+' }  # Split par espaces
  } |
  Sort-Object -Unique |
  Export-Csv -Path "classes-found.csv"
```

### 2. Extraction des sélecteurs CSS depuis les fichiers CSS

**Pour les fichiers minifiés :** Ignorer complètement (impossible à parser)

**Pour les fichiers non-minifiés :**

```powershell
# Pattern regex pour trouver les sélecteurs de classe CSS
$cssClassPattern = '\.[a-zA-Z_-][a-zA-Z0-9_-]*'

# Scanner les fichiers CSS
Get-ChildItem -Path "src/styles" -Recurse -Include "*.css" -Exclude "*.min.css" |
  ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    [Regex]::Matches($content, $cssClassPattern) |
      ForEach-Object { $_.Value }
  } |
  Sort-Object -Unique
```

### 3. Détection des minifiés

```powershell
# Lister les fichiers minifiés trouvés
$MinifiedFiles = Get-ChildItem -Path "src/styles" -Recurse -Include "*.min.css"

# Ces fichiers DOIVENT être ignorés
Write-Host "Fichiers minifiés trouvés (IGNORÉ) : $($MinifiedFiles.Count)"
$MinifiedFiles | ForEach-Object { Write-Host "  - $_" }
```

## Algorithme de comparaison

### Étape 1 : Normalisation

```
Classes HTML trouvées :
  .btn -> btn
  .btn-primary -> btn-primary
  .mx-2 -> mx-2

Sélecteurs CSS trouvés :
  .btn { ... } -> btn
  .btn-primary { ... } -> btn-primary
  .mx-2 { ... } -> mx-2
```

### Étape 2 : Croiser les ensembles

```
Utilisation réelle (HTML) : {btn, btn-primary, mx-2, old-navbar, ...}
Définitions CSS         : {btn, btn-primary, mx-2, old-navbar, old-banner, admin-form, ...}

Inutilisées :
  - old-banner    (défini en CSS, jamais utilisé en HTML)
  - admin-form    (défini en CSS, jamais utilisé en HTML)
```

## Cas spéciaux à gérer

### 1. Pseudo-classes

```css
.btn:hover { }     /* Sélecteur : .btn:hover */
.btn:active { }    /* Sélecteur : .btn:active */
.btn:focus { }     /* Sélecteur : .btn:focus */
```

Extraction correcte :
```powershell
# Extraire aussi les pseudo-classes
$cssPattern = '\.[a-zA-Z_-][a-zA-Z0-9_:-]*'
```

### 2. Combinateurs

```css
.navbar .logo { }       /* Classe combo : .navbar et .logo */
.button > span { }      /* Classe combo : .button et span */
.form input { }         /* Classe combo : .form et input */
.header ~ section { }   /* Classe combo : .header et section */
```

Traitement :
- Extraire uniquement les classes (ignorer `>`, `~`, ` `)
- Chaque classe `.navbar`, `.logo`, `.button`, `.form`, `.header` est valide

### 3. Media queries

```css
@media (max-width: 768px) {
  .navbar-mobile { }
  .sidebar-collapsed { }
}
```

Extraction :
```powershell
# Extraire les classes DANS les media queries
$mediaPattern = '@media[^{]*\{([^}]*\{[^}]*\})*\}'
$classPattern = '\.[a-zA-Z_-][a-zA-Z0-9_-]*'
```

### 4. Animations et keyframes

```css
@keyframes slide-in {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(0); }
}

.slide-in-element {
  animation: slide-in 0.3s;
}
```

Cas 1 : Si `.slide-in-element` n'est pas utilisé en HTML → supprimable
Cas 2 : Si le keyframe `slide-in` n'est référencé nulle part → supprimable

## Gestion des faux positifs

### Classes dynamiques (JavaScript runtime)

```javascript
// ❌ FAUX POSITIF : Cette classe n'apareça pas en HTML statique
element.classList.add('dynamically-added-class')
```

Détection :
```powershell
# Scanner les fichiers .js et .jsx pour classList.add()
Get-ChildItem -Path "src" -Include "*.js", "*.jsx" -Recurse |
  Select-String -Pattern 'classList\.add\(["\']([^"\']+)["\']'
```

### Classes conditionnelles

```jsx
// ❌ FAUX POSITIF : Class dépend d'une condition
<div className={isActive ? 'active' : 'inactive'}>
```

Solution :
- Ajouter ces classes à une liste d'exceptions manuellement
- Ou utiliser un commenter spécial : `/* @keep isActive */`

### Framework CSS

```html
<!-- ❌ FAUX POSITIF : Classes Bootstrap amplifiées -->
<button class="btn btn-primary btn-lg">
```

Solution :
- Ne pas supprimer les classes Bootstrap/Tailwind automatiquement
- Vérifier que le framework CSS est importé dans le projet

## Reporting et statistiques

### Générer des statistiques

```powershell
# Statistiques CSS
$stats = @{
  TotalClasses = $htmlClasses.Count
  CssDefinedClasses = $cssClasses.Count
  UnusedClasses = ($cssClasses | Where-Object { $_ -notin $htmlClasses }).Count
  EstimatedReduction = "$($stats.UnusedClasses * 50) bytes (estimation)"
}

$stats | ConvertTo-Json | Out-File "css-stats.json"
```
