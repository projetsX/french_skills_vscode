# Versions beerCSS — Default, Scoped & Custom Element

## Comparatif des 3 versions

| Version | Portée | Quand utiliser |
|---|---|---|
| **Default** | Tout le document | Nouveau projet, site entier en beerCSS |
| **Scoped** | Enfants d'un élément avec `class="beer"` | Intégration partielle dans un site existant |
| **Custom Element** | Enfants de `<beer-css>` | Web Components, micro-frontends, Shadow DOM |

---

## Version Default (standard)

S'applique à tous les éléments du document.

```html
<!-- CDN -->
<link href="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.css" rel="stylesheet" />
<script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.js"></script>
<script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
```

```js
// NPM
import "beercss";
import "material-dynamic-colors";
```

```html
<!-- Usage normal -->
<body class="light">
  <button>Mon bouton beerCSS</button>
</body>
```

---

## Version Scoped

S'applique **uniquement aux enfants** d'un élément ayant `class="beer"`.  
Idéal pour intégrer beerCSS dans une page qui a déjà son propre CSS, sans conflits.

```html
<!-- CDN Scoped -->
<link href="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.scoped.min.css" rel="stylesheet" />
<script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.js"></script>
<script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
```

```js
// NPM Scoped
import "beercss/scoped";
import "material-dynamic-colors";
```

```html
<!-- Usage : wrapper avec class="beer" requis -->
<body>

  <!-- Zone NON stylisée par beerCSS -->
  <div class="ma-classe-perso">
    <button>Bouton normal (pas beerCSS)</button>
  </div>

  <!-- Zone stylisée par beerCSS -->
  <div class="beer light">
    <button>Bouton beerCSS</button>
    <dialog id="mon-dialog">
      <h5>Dialog beerCSS</h5>
    </dialog>
  </div>

</body>
```

**Points importants** :
- Le `class="beer"` peut être mis sur n'importe quel élément (`div`, `section`, `main`, etc.)
- Le thème (`light`/`dark`) se met sur l'élément avec `class="beer"` (pas sur `body`)
- `ui()` et `data-ui` fonctionnent normalement dans la zone scoped

---

## Version Custom Element

S'applique aux enfants de `<beer-css>`.  
Conçu pour les **Web Components** et les **micro-frontends** avec isolation de style.

```html
<!-- CDN Custom Element (pas de CSS séparé — tout est dans le JS) -->
<script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.custom-element.min.js"></script>
<script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
```

```js
// NPM Custom Element
import "beercss/custom-element";
import "material-dynamic-colors";
```

```html
<!-- Usage : balise <beer-css> comme wrapper -->
<body>

  <!-- Zone NON stylisée par beerCSS -->
  <div>Contenu sans beerCSS</div>

  <!-- Zone beerCSS isolée -->
  <beer-css class="light">
    <button>Bouton beerCSS</button>
    <nav class="bottom">
      <a><i>home</i><span>Accueil</span></a>
    </nav>
  </beer-css>

</body>
```

**Points importants** :
- Pas de fichier CSS séparé — les styles sont injectés par le JS
- Isolation complète du Shadow DOM possible
- Compatible avec les frameworks Web Components (Lit, Stencil, etc.)

---

## Choisir la bonne version — Arbre de décision

```
Nouveau projet entier en beerCSS ?
  └── OUI → Version Default (standard)
  └── NON → Site existant avec CSS propre ?
        └── OUI → Besoin d'isolation maximale (Web Components / micro-frontend) ?
              └── OUI → Version Custom Element (<beer-css>)
              └── NON → Version Scoped (class="beer")
```

---

## Fichiers à télécharger pour utilisation locale

Depuis le CDN : `https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/`

| Version | Fichiers nécessaires |
|---|---|
| Default | `beer.min.css` + `beer.min.js` |
| Scoped | `beer.scoped.min.css` + `beer.min.js` |
| Custom Element | `beer.custom-element.min.js` (tout-en-un) |

+ `material-dynamic-colors.min.js` pour le thème dynamique dans tous les cas.

---

## Intégration dans un framework JS (Vue, React, Angular)

### React / Next.js

```js
// Default
import "beercss";
import "material-dynamic-colors";

// Scoped
import "beercss/scoped";

// Custom Element
import "beercss/custom-element";
```

```jsx
// React — version scoped
export default function BeerSection() {
  return (
    <div className="beer light">
      <button>Bouton beerCSS</button>
    </div>
  );
}
```

### Vue 3

```js
// main.js
import "beercss";
import "material-dynamic-colors";
```

```vue
<!-- Composant Vue — version scoped -->
<template>
  <div class="beer light">
    <button>Bouton beerCSS</button>
  </div>
</template>
```

### Vite — attention build

Pour Vite, ajouter dans `vite.config.js` pour éviter l'inlining du CSS :
```js
export default {
  build: {
    assetsInlineLimit: 0
  }
}
```

---

## Coexistence beerCSS + autre framework CSS

**Scénario** : Page Bootstrap ou Tailwind existante + ajout partiel beerCSS.

```html
<!-- Bootstrap chargé globalement -->
<link rel="stylesheet" href="bootstrap.min.css">

<!-- beerCSS scoped uniquement sur la section widget -->
<link href="beer.scoped.min.css" rel="stylesheet" />

<body>
  <!-- Contenu Bootstrap existant — non affecté -->
  <div class="container">
    <div class="row">
      <div class="col">Contenu Bootstrap</div>
    </div>
  </div>

  <!-- Widget beerCSS isolé -->
  <div class="beer dark">
    <article class="medium-padding">
      <h5>Widget beerCSS</h5>
      <button>Action</button>
    </article>
  </div>
</body>
```
