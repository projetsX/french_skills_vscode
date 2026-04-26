# Référence Composants beerCSS

## Button

| Variante | HTML |
|---|---|
| Filled (défaut) | `<button>Texte</button>` |
| Outlined | `<button class="border">Texte</button>` |
| Tonal | `<button class="secondary">Texte</button>` |
| Text button | `<a class="button">Texte</a>` |
| Icon button | `<button class="circle"><i>home</i></button>` |
| FAB | `<button class="circle extra"><i>add</i></button>` |
| FAB étendu | `<button class="extend circle"><i>add</i><span>Créer</span></button>` |
| Responsive | `<button class="responsive">Texte</button>` |

**Avec icône + texte** :
```html
<button>
  <i>home</i>
  <span>Accueil</span>
</button>
```

---

## Card (`<article>`)

```html
<!-- Card simple -->
<article>
  <h5>Titre</h5>
  <p>Description</p>
</article>

<!-- Card avec actions -->
<article>
  <img src="..." class="responsive">
  <div class="padding">
    <h5>Titre</h5>
    <p>Description</p>
  </div>
  <nav>
    <button class="border">Annuler</button>
    <button>Confirmer</button>
  </nav>
</article>

<!-- Card avec bordure/élévation -->
<article class="border">...</article>
<article class="small-elevate">...</article>
```

---

## Dialog

```html
<!-- Ouverture via data-ui (recommandé) -->
<button data-ui="#ma-dialog">Ouvrir</button>

<dialog id="ma-dialog">
  <h5>Titre</h5>
  <p>Contenu</p>
  <nav class="right-align">
    <button data-ui="#ma-dialog" class="border">Annuler</button>
    <button data-ui="#ma-dialog">Confirmer</button>
  </nav>
</dialog>

<!-- Dialog modal (bloque le fond) -->
<dialog class="modal" id="confirm">...</dialog>
```

**Positions** : `<dialog class="left">`, `<dialog class="right">`, `<dialog class="top">`, `<dialog class="bottom">`

---

## Input / Field

```html
<!-- Champ texte simple avec label flottant -->
<div class="field label">
  <input type="text">
  <label>Nom</label>
</div>

<!-- Avec bordure -->
<div class="field label border">
  <input type="text">
  <label>Email</label>
</div>

<!-- Avec icône préfixe -->
<div class="field label prefix border">
  <i>search</i>
  <input type="text">
  <label>Rechercher</label>
</div>

<!-- Avec icône suffixe cliquable -->
<div class="field label suffix border">
  <input type="text">
  <label>Mot de passe</label>
  <a><i>visibility</i></a>
</div>
```

---

## Tabs + Pages

```html
<div class="tabs">
  <a class="active" data-ui="#page1">Onglet 1</a>
  <a data-ui="#page2">Onglet 2</a>
  <a data-ui="#page3">Onglet 3</a>
</div>

<div class="page active" id="page1"><p>Contenu 1</p></div>
<div class="page" id="page2"><p>Contenu 2</p></div>
<div class="page" id="page3"><p>Contenu 3</p></div>
```

---

## Navigation

```html
<!-- Barre de navigation bottom (mobile) -->
<nav class="bottom">
  <a class="active">
    <i>home</i>
    <span>Accueil</span>
  </a>
  <a>
    <i>search</i>
    <span>Recherche</span>
  </a>
</nav>

<!-- Rail de navigation (left, tablet/desktop) -->
<nav class="left">
  <a class="active">
    <i>home</i>
    <span>Accueil</span>
  </a>
  <a>
    <i>settings</i>
    <span>Paramètres</span>
  </a>
</nav>
```

---

## Menu (dropdown)

```html
<button data-ui="#mon-menu">Options <i>arrow_drop_down</i></button>
<menu id="mon-menu">
  <a>Action 1</a>
  <a>Action 2</a>
  <hr>
  <a class="red-text">Supprimer</a>
</menu>
```

---

## Snackbar (notification)

```html
<button data-ui="#snack">Afficher</button>
<div class="snackbar" id="snack">
  <p>Message de notification</p>
</div>
```

---

## Chip

```html
<!-- Chip simple -->
<a class="chip">Étiquette</a>

<!-- Chip avec icône -->
<a class="chip">
  <i>check</i>
  <span>Validé</span>
</a>

<!-- Chip input (supprimable) -->
<a class="chip">
  <span>Tag</span>
  <i>close</i>
</a>

<!-- Chip outlined -->
<a class="chip border">Filtre</a>
```

---

## Badge

```html
<!-- Badge sur un bouton -->
<button class="circle">
  <i>notifications</i>
  <span class="badge">3</span>
</button>

<!-- Badge coloré -->
<button class="circle">
  <i>mail</i>
  <span class="badge red">12</span>
</button>
```

---

## List

```html
<ul class="list">
  <li>
    <i>home</i>
    <div>
      <p>Titre</p>
      <p>Sous-titre</p>
    </div>
  </li>
  <li>
    <i>settings</i>
    <div>
      <p>Paramètres</p>
    </div>
    <a class="button circle"><i>chevron_right</i></a>
  </li>
</ul>
```

---

## Checkbox, Radio, Switch

```html
<!-- Checkbox -->
<label class="checkbox">
  <input type="checkbox">
  <span>Option</span>
</label>

<!-- Radio -->
<label class="radio">
  <input type="radio" name="group">
  <span>Choix A</span>
</label>

<!-- Switch -->
<label class="switch">
  <input type="checkbox">
  <span>Activer</span>
</label>
```

---

## Icônes Material Symbols

beerCSS utilise **Material Symbols** via `<i>` :
```html
<i>home</i>
<i>search</i>
<i>settings</i>
<i class="fill">favorite</i>   <!-- icône remplie -->
<i class="small">add</i>       <!-- taille small -->
```

**Ne jamais** utiliser `<span class="material-symbols-...">` — utiliser `<i>` uniquement.

---

## Progress

```html
<!-- Indéterminé (chargement) -->
<progress></progress>

<!-- Déterminé -->
<progress value="60" max="100"></progress>

<!-- Circulaire -->
<progress class="circle"></progress>
```

---

## Tooltip

```html
<button>
  Survoler
  <div class="tooltip">Message d'aide</div>
</button>
```

---

## Overlay (loader d'écran)

```html
<button data-ui="#chargement">Charger</button>
<div class="overlay" id="chargement">
  <progress class="circle white-text"></progress>
</div>
```
