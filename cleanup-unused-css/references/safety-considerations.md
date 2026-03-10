# Considérations de sécurité et cas d'exception

## ⚠️ À NE PAS FAIRE

### 1. Ne pas toucher aux fichiers minifiés

```
❌ BAD:
- vendor.min.css         # Framework CSS minifié
- bootstrap.min.css      # Bootstrap minifié
- app.production.min.css # Production minifiée
```

**Pourquoi ?** Les fichiers minifiés sont impossible à parser correctement. Une ligne minifiée 
peut contenir 100+ sélecteurs, et les reformater risquerait de casser la syntaxe.

**Action :** Le script ignore automatiquement `*.min.css` et les liste dans le rapport.

```powershell
# Vérifier les minifiés trouvés
$minified = Get-ChildItem -Path "src/styles" -Include "*.min.css" -Recurse
Write-Host "Fichiers minifiés ignorés : $minified.Count"
```

### 2. Ne pas supprimer sans sauvegarde

```
❌ WRONG:
.\cleanup-unused-css.ps1 -ExecuteCleanup $true   # Pas de backup !

✅ CORRECT:
.\cleanup-unused-css.ps1 -ExecuteCleanup $true -CreateBackup $true
```

**Bénéfice :** En cas de problème, restaurer en 1 ligne :
```powershell
.\css-backup-*/restore-backup.ps1
```

### 3. Ne pas supprimer sans reporter

```
❌ WRONG:
Supprimer directement les blocs CSS manuellement dans l'éditeur

✅ CORRECT:
1. Générer un rapport
2. Valider le rapport
3. Créer un backup
4. Puis supprimer via le script
```

### 4. Ne pas ignorer les warnings

```json
{
  "warningsAndExceptions": [
    {
      "type": "dynamic-class",
      "class": ".alert-" ,
      "reason": "Found in JavaScript: classList.add('alert-success')",
      "recommendation": "Manual review required"
    }
  ]
}
```

**Action :** Vérifier chaque warning avant suppression.

## ⚡ Classes et patterns à risque

### 1. Classes Bootstrap / Tailwind

```html
<!-- Classes courantes que framework utilise -->
<div class="col-md-4 mx-auto p-3 d-flex justify-content-center">
```

**Risque :** Très facile de supprimer une classe Bootstrap pensant que c'est du CSS personnalisé.

**Solution :**
```powershell
# Vérifier si Bootstrap/Tailwind est importé
Get-Content "src/main.tsx" -Raw | Select-String "bootstrap|tailwind"
```

**Action :** Si framework trouvé, créer une liste blanche.

### 2. Pseudo-classes et états

```css
.button { }              /* Base */
.button:hover { }        /* État au survol */
.button:active { }       /* État au clic */
.button:focus { }        /* État au focus */
.button:disabled { }     /* État désactivé */
```

**Risque :** Si `.button` n'est jamais utilisé *sans* pseudo-classe en HTML exact.

```html
<!-- HTML peut ne pas avoir la classe de base -->
<style>
  /* Le :hover peut être orphelin en HTML mais utilisé dynamiquement */
</style>
```

**Solution :** Garder pseudo-classes avec la classe de base.

### 3. Animations et transitions

```css
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

.fade-animate {
  animation: fade-in 0.3s;
}

/* Mais aussi utilisation JavaScript : */
```

```javascript
element.addEventListener('load', () => {
  element.classList.add('fade-animate')
})
```

**Risque :** Le keyframe peut sembler inutilisé si la classe n'est jamais en HTML.

**Solution :** Scanner les fichiers JS pour `animation`, `transition`, `classList.add()`.

### 4. Media query specifics

```css
.navbar { }           /* Desktop */

@media (max-width: 768px) {
  .navbar { display: none; }        /* Mobile */
  .navbar-mobile { display: block; } /* Mobile only */
}
```

**Risque :** `.navbar-mobile` n'est jamais en HTML pour `max-width: 768px`, 
donc ça semble inutilisé.

**Solution :** Porter attention aux classes media-specific dans le report.

### 5. Thèmes conditionnels

```css
.dark-theme .button { }     /* Dark mode */
.light-theme .button { }    /* Light mode */
```

**Risque :** Selon le thème actif, une version peut sembler inutilisée.

**Solution :** Documenter les thèmes et les exclure de l'analyse.

## 🔍 Exceptions et faux positifs

### 1. Classes dynamiques en JavaScript

```javascript
// ❌ Cette classe n'apparaît JAMAIS en HTML
function showAlert(type) {
  const className = `alert-${type}`  // "alert-success", "alert-error", etc.
  element.classList.add(className)
}
```

**Détection :**
```powershell
# Scanner les .js/.jsx pour patterns dynamiques
Get-ChildItem -Path "src" -Include "*.js", "*.jsx" -Recurse |
  Select-String -Pattern 'classList\.add|className.*\$|class.*\+' |
  Export-Csv "dynamic-classes.csv"
```

**Solution :** Créer une liste d'exceptions pour ces classes.

**Exemple d'exception :**
```json
{
  "excludeClasses": [
    "alert-*",        // Wildcards supportées
    "btn-*",
    { "class": ".dynamic-class", "reason": "Added via JS" }
  ]
}
```

### 2. Classes legacy mais encore utilisées

```css
/* Anciennes versions du site
   Pas encore supprimées mais en cours de migration */
.old-navbar { }
.old-form { }
```

```javascript
// Migration en cours
if (useNewLayout) {
  // Use new-navbar
} else {
  // Use old-navbar (still needed!)
}
```

**Solution :** Vérifier le code source pour les conditions.

**Action :** Manual review et ajout à la liste de garde.

### 3. CSS pour plugins/extensions

```css
/* Pour jQuery plugin "slider" */
.slider-container { }
.slider-track { }

/* Charger plugin via CDN, structure HTML générée dynamiquement */
```

**Risque :** Ces classes ne sont jamais en HTML *source* mais générées par JavaScript.

**Solution :** Documenter les plugins utilisés.

### 4. Critical CSS et above-the-fold

```css
/* Critical CSS pour optimiser la performance */
.hero { }
.featured-section { }

/* Ces styles sont inline dans le HTML <head> pour faster paint */
```

**Risque :** Ces fichiers peuvent sembler redondants avec les CSS externes.

**Solution :** Ignorer les fichiers `critical.css` ou `inline.css`.

## 📋 Checklist des exceptions

Avant de supprimer, cocher :

- [ ] Fichier minifié ? → **IGNORE**
- [ ] Classe Bootstrap/Tailwind ? → **Manual review**
- [ ] Utilisée within media query ? → **Check carefully**
- [ ] Classe dynamique en JS ? → **EXCLUDE**
- [ ] Pseudo-classe (`::before`, `:hover`, etc.) ? → **Check parent**
- [ ] Keyframe d'animation ? → **Check usage in JS**
- [ ] Theme-specific (dark-mode, etc.) ? → **EXCLUDE**
- [ ] Legacy code en migration ? → **Manual review**
- [ ] Plugin ou library CSS ? → **EXCLUDE**
- [ ] Critical CSS ? → **EXCLUDE**

## 🛡️ Mode sécurisé

Si vous avez des doutes, utilisez **mode sécurisé** :

```powershell
# Mode sécurisé : plus conservateur, moins de suppressions
.\cleanup-unused-css.ps1 `
  -PagesFolder "src/pages" `
  -CssFolder "src/styles" `
  -SafeMode $true        # Plus strict
  -ConfidenceThreshold 0.95  # >95% de confiance avant suppression
```

**Bénéfices :**
- Moins de faux positifs
- Supprime seulement les blocs "obviousement" inutilisés
- Plus sûr pour premier lancement

## 🚨 Rollback procédure

En cas de problème :

```powershell
### Option 1 : Utiliser le backup
.\css-backup-2026-03-10T143000Z\restore-backup.ps1

### Option 2 : Utiliser Git
git checkout HEAD~1 -- "src/styles/"
git checkout - # Restore all files from previous commit

### Option 3 : Manuel
# Copier les fichiers depuis le dossier backup
robocopy "css-backup-*" "src/styles" /e
```

Après restauration :
1. Relancer l'application
2. Vérifier que tout fonctionne
3. Documenter ce qui s'est mal passé
4. Améliorer les configurations / exceptions
5. Relancer avec corrections
