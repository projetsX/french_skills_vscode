# Layout, Grid & Responsive beerCSS

## Structure principale d'une page

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.css" rel="stylesheet" />
  <script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.js"></script>
  <script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
</head>
<body class="light">

  <!-- Navigation top (app bar) -->
  <header class="responsive fixed">
    <nav>
      <button class="circle" data-ui="#nav-left"><i>menu</i></button>
      <h5 class="max">Mon App</h5>
      <button class="circle"><i>account_circle</i></button>
    </nav>
  </header>

  <!-- Navigation latérale (drawer) -->
  <nav class="left" id="nav-left">
    <a class="active"><i>home</i><span>Accueil</span></a>
    <a><i>settings</i><span>Paramètres</span></a>
  </nav>

  <!-- Contenu principal -->
  <main class="responsive">
    <h3>Titre de page</h3>
    <!-- contenu -->
  </main>

  <!-- Navigation bottom (mobile) -->
  <nav class="bottom">
    <a class="active"><i>home</i><span>Accueil</span></a>
    <a><i>search</i><span>Recherche</span></a>
    <a><i>person</i><span>Profil</span></a>
  </nav>

</body>
</html>
```

**Rendu logique** :
```
nav.left | header (fixed)  | 
nav.left | main.responsive | 
nav.left | nav.bottom      | 
```

---

## Grid responsive

beerCSS utilise un système de **12 colonnes** avec préfixes de breakpoint :

| Préfixe | Breakpoint | Usage |
|---|---|---|
| `s1`...`s12` | Small (mobile, < 600px) | Toujours défini |
| `m1`...`m12` | Medium (tablette, 600–1024px) | Optionnel |
| `l1`...`l12` | Large (desktop, > 1024px) | Optionnel |

### ✅ Correct — wrapper `<div>` neutre pour chaque cellule
```html
<div class="grid">
  <div class="s12 m6 l4">
    <article>Contenu</article>
  </div>
  <div class="s12 m6 l4">
    <article>Contenu</article>
  </div>
  <div class="s12 m12 l4">
    <article>Contenu</article>
  </div>
</div>
```

### 🚫 Incorrect — classes beerCSS directement sur l'enfant de grid
```html
<div class="grid">
  <article class="s12 m6 l4">Contenu</article>  <!-- FAUX -->
</div>
```

### Espacement entre cellules
```html
<div class="grid small-space">...</div>
<div class="grid medium-space">...</div>
<div class="grid no-space">...</div>
```

---

## Row (rangée horizontale)

Pour des éléments en ligne sans besoin de colonnes :
```html
<div class="row">
  <div>Colonne fixe</div>
  <div class="max">Colonne extensible (prend tout l'espace restant)</div>
  <button>Action</button>
</div>
```

`max` fait grossir l'élément pour remplir l'espace disponible dans un `row`.

---

## Helpers de taille et position

### Tailles absolues
```html
<div class="small">...</div>    <!-- petite largeur fixe -->
<div class="medium">...</div>
<div class="large">...</div>
```

### Responsive (centré + max-width)
```html
<main class="responsive">...</main>
<header class="responsive">...</header>
```

### Positions dans un container
```html
<div class="absolute left top">...</div>      <!-- coin haut-gauche -->
<div class="absolute right bottom">...</div>  <!-- coin bas-droit -->
<div class="absolute center middle">...</div> <!-- centré -->
```

### Sticky header/footer dans un scroll
```html
<article class="scroll">
  <header class="fixed">En-tête collant</header>
  <p>Contenu long...</p>
  <footer class="fixed">Pied collant</footer>
</article>
```

---

## Alignements (helpers)

| Classe | Effet |
|---|---|
| `left-align` | Aligne le texte/contenu à gauche |
| `right-align` | Aligne à droite |
| `center-align` | Centre horizontalement |
| `top-align` | Aligne en haut |
| `bottom-align` | Aligne en bas |
| `middle-align` | Centre verticalement |

---

## Marges et paddings

```html
<!-- Marges -->
<div class="margin">...</div>
<div class="small-margin">...</div>
<div class="top-margin">...</div>
<div class="auto-margin">...</div>      <!-- center un bloc -->
<div class="no-margin">...</div>

<!-- Paddings -->
<div class="padding">...</div>
<div class="small-padding">...</div>
<div class="horizontal-padding">...</div>
<div class="no-padding">...</div>
```

---

## Responsive adaptatif (Navigation Material You)

### Mobile (< 600px) → `nav.bottom`
```html
<nav class="bottom">
  <a><i>home</i><span>Accueil</span></a>
  <a><i>search</i><span>Rechercher</span></a>
</nav>
<main class="responsive">...</main>
```

### Tablette (600–1024px) → `nav.left` (rail)
```html
<nav class="left">
  <a><i>home</i><span>Accueil</span></a>
</nav>
<main class="responsive">...</main>
```

### Desktop (> 1024px) → `nav.left` avec texte
```html
<nav class="left">
  <header><h6>Mon App</h6></header>
  <a class="active"><i>home</i><span>Accueil</span></a>
  <a><i>settings</i><span>Paramètres</span></a>
</nav>
<main class="responsive">...</main>
```

> **Astuce** : beerCSS gère automatiquement via media queries si on utilise `nav.left` + `nav.bottom` ensemble — chacun s'affiche au bon breakpoint.

---

## Aside (panneau latéral)

```html
<aside class="left">
  <!-- Contenu panneau gauche -->
</aside>
<main>...</main>
<aside class="right">
  <!-- Contenu panneau droit -->
</aside>
```

---

## Scroll

```html
<div class="scroll">...</div>          <!-- scroll vertical -->
<div class="scroll horizontal">...</div>  <!-- scroll horizontal -->
```

---

## Formes et arrondis

```html
<article class="round">...</article>
<article class="no-round">...</article>
<article class="left-round">...</article>    <!-- arrondi à gauche seulement -->
<button class="circle">...</button>          <!-- cercle parfait -->
<button class="square">...</button>          <!-- carré parfait -->
```

---

## Élévation (ombres)

```html
<article class="elevate">...</article>
<article class="small-elevate">...</article>
<article class="medium-elevate">...</article>
<article class="large-elevate">...</article>
<article class="no-elevate">...</article>
```

---

## Couleurs Material You

### Sur le fond de l'élément
```html
<div class="primary">...</div>
<div class="secondary-container">...</div>
<div class="tertiary">...</div>
<div class="error">...</div>
<div class="surface">...</div>
```

### Sur le texte
```html
<p class="primary-text">...</p>
<span class="error-text">Erreur</span>
```

### Sur la bordure
```html
<div class="border primary-border">...</div>
```

### Couleurs statiques (palette complète)
Format : `{couleur}{1-10}`, `{couleur}`, `{couleur}-text`, `{couleur}-border`
Ex : `red`, `red5`, `red-text`, `blue-border`, `green1`...
