# Debug & Bugs Courants beerCSS

## Bug #1 — Classes beerCSS directement sur les enfants d'une `grid`

**Symptôme** : La grille ne s'affiche pas correctement, les colonnes ne respectent pas les tailles `s/m/l`.

**Cause** : beerCSS exige que les enfants directs d'une `.grid` soient des `<div>` neutres. Mettre des classes beerCSS (comme `article`, `field`, `label`) directement sur les enfants directs casse le rendu.

**Mauvais** :
```html
<div class="grid">
  <article class="s12 m6">...</article>      <!-- ❌ -->
  <label class="s12 m6 checkbox">...</label> <!-- ❌ -->
</div>
```

**Correct** :
```html
<div class="grid">
  <div class="s12 m6"><article>...</article></div>      <!-- ✅ -->
  <div class="s12 m6"><label class="checkbox">...</label></div> <!-- ✅ -->
</div>
```

---

## Bug #2 — Dialog/Menu/Snackbar ne s'ouvre pas

**Symptôme** : Le clic sur un bouton ne déclenche rien.

**Causes possibles** :

1. **`data-ui` pointe vers un `id` inexistant** ou mal orthographié
   ```html
   <button data-ui="#modal-confirm">Ouvrir</button>
   <dialog id="modal-confirm">...</dialog>  <!-- id doit correspondre exactement -->
   ```

2. **Le JS beerCSS n'est pas chargé** → vérifier que `beer.min.js` est bien inclus avec `type="module"`
   ```html
   <script type="module" src=".../beer.min.js"></script>
   ```

3. **Utilisation de `ui("dialog")` sans sélecteur** — la fonction `ui()` prend un **sélecteur CSS** ou un **id**
   ```js
   ui("#ma-dialog");   // ✅ correct
   ui("dialog");       // ⚠️ cible TOUS les dialogs
   ```

4. **Classe `active` manquante pour l'état initial** — pour que le dialog soit ouvert au chargement, ajouter `active` directement dans le HTML
   ```html
   <dialog class="active">...</dialog>
   ```

---

## Bug #3 — Label de champ Input ne monte pas (reste en bas)

**Symptôme** : Le label reste superposé à la valeur quand l'input a une valeur pré-remplie.

**Solution** : Ajouter la classe `active` sur l'input ET sur le label quand la valeur est déjà présente.

```html
<!-- Champ pré-rempli -->
<div class="field label border">
  <input type="text" class="active" value="Valeur existante">
  <label class="active">Nom</label>
</div>
```

> Le JS beerCSS gère `active` automatiquement lors de la frappe utilisateur, mais pas pour les valeurs initiales HTML.

---

## Bug #4 — Icônes Material Symbols ne s'affichent pas

**Symptôme** : Des carrés vides ou le nom textuel de l'icône apparaît au lieu de l'icône.

**Causes** :
1. La police Material Symbols n'est pas chargée → beerCSS ne la charge pas automatiquement dans certaines configs
2. Mauvais tag HTML utilisé

**Solution** : Vérifier que la police est incluse (beerCSS CDN l'inclut via le CSS), sinon ajouter manuellement :
```html
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
```

**Syntaxe correcte** : utiliser uniquement `<i>` (pas `<span>`) :
```html
<i>home</i>           <!-- ✅ -->
<i class="fill">favorite</i>   <!-- ✅ icône remplie -->
<span class="material-symbols-outlined">home</span>  <!-- ❌ éviter avec beerCSS -->
```

---

## Bug #5 — Navigation `nav.left` visible sur mobile

**Symptôme** : La navigation latérale s'affiche en même temps que la navigation bottom sur mobile.

**Explication** : beerCSS gère la visibilité automatiquement selon le breakpoint — `nav.left` est masquée sur petits écrans, `nav.bottom` est masquée sur grands écrans.

**Problème courant** : override CSS personnalisé qui casse ce comportement → vérifier qu'aucun style custom ne force `display: block` ou `visibility: visible` sur `nav.left`.

Si le drawer doit être ouvert/fermé manuellement (même sur desktop) :
```html
<button data-ui="#drawer">Menu</button>
<nav class="left" id="drawer">...</nav>
```

---

## Bug #6 — `class="active"` ne fonctionne pas pour les Tabs

**Symptôme** : Toutes les pages de tabs s'affichent en même temps, ou aucune.

**Solution** : `active` doit être sur **l'onglet ET sur la page correspondante** (et seulement sur le premier au chargement).

```html
<div class="tabs">
  <a class="active" data-ui="#page1">Tab 1</a>  <!-- active ici -->
  <a data-ui="#page2">Tab 2</a>
</div>

<div class="page active" id="page1">Contenu 1</div>  <!-- et ici -->
<div class="page" id="page2">Contenu 2</div>
```

---

## Bug #7 — Textarea ne se redimensionne pas automatiquement

**Symptôme** : Le textarea garde une hauteur fixe même avec beaucoup de texte.

**Cause** : L'auto-resize est géré par le JS beerCSS — il est **obligatoire** pour les `<textarea>`.

**Vérification** : `beer.min.js` doit être présent avec `type="module"`.

```html
<div class="field label">
  <textarea></textarea>
  <label>Message</label>
</div>
<script type="module" src=".../beer.min.js"></script>
```

---

## Bug #8 — Slider ne met pas à jour sa valeur visuellement

**Cause** : Idem textarea — le JS beerCSS est requis pour les sliders.

```html
<label class="slider">
  <input type="range" min="0" max="100" value="50">
  <span>50</span>
</label>
```

---

## Bug #9 — Conflits de classes Custom + beerCSS

**Symptôme** : Styles personnalisés écrasés ou comportement incohérent.

**Bonnes pratiques** :
- Utiliser les variables CSS de beerCSS pour personnaliser : `--primary`, `--surface`, etc.
- Éviter de surcharger directement les sélecteurs natifs (`button`, `dialog`, `nav`)
- Préférer des variables CSS sur `:root` ou `body` :
  ```css
  body {
    --primary: #your-color;
    --font: 'Votre Police', sans-serif;
  }
  ```

---

## Bug #10 — Overlay ne disparaît pas après action

**Solution** : Utiliser `data-ui` ou la fonction JS pour le toggle :
```html
<div class="overlay active" id="chargement">
  <progress class="circle"></progress>
</div>
```
```js
// Pour fermer
ui("#chargement");
// ou
document.getElementById("chargement").classList.remove("active");
```

---

## Checklist de débogage rapide

Quand un composant beerCSS ne fonctionne pas, vérifier dans l'ordre :

1. [ ] `beer.min.css` chargé correctement ?
2. [ ] `beer.min.js` avec `type="module"` présent ?
3. [ ] `data-ui="#id"` correspond exactement à `id="id"` ?
4. [ ] Les enfants directs de `.grid` sont des `<div>` neutres ?
5. [ ] La classe `active` est sur les bons éléments (tabs, dialog, input) ?
6. [ ] Pas de CSS custom qui écrase les styles beerCSS sans `!important` ?
7. [ ] Les icônes utilisent `<i>nom</i>` (pas `<span>`) ?
8. [ ] Pour les inputs pré-remplis, `active` est présent sur l'input et le label ?
