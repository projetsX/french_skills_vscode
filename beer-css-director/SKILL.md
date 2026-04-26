---
name: beer-css-director
description: "Expert beerCSS v4.0.20 : choisir les bonnes classes, structurer le HTML, utiliser les helpers, résoudre les bugs visuels et JS. Use when: améliorer l'interface beerCSS d'un site, utiliser beerCSS pour une partie du site, intégrer beerCSS dans un projet, créer une interface HTML avec beerCSS, composant beerCSS ne s'affiche pas, choisir entre chip/button/badge, structurer un layout responsive beerCSS, utiliser data-ui, dialog, menu, snackbar, tabs, grid s/m/l, navigation rail, couleurs Material You, thème dynamique, dark/light mode beerCSS, beerCSS scoped, beerCSS custom element."
argument-hint: "composant ou problème à résoudre (ex: 'dialog ne s\\'ouvre pas', 'grid responsive', 'améliorer l\\'interface beerCSS')"
---

# beerCSS Director — v4.0.20

Expert **beerCSS v4.0.20** — génère du HTML correct avec les bonnes classes, identifie les pièges courants et résout les bugs visuels ou JS.

> Ce skill cible exclusivement **beerCSS 4.0.20** (+ material-dynamic-colors 1.1.4). Pour d'autres versions, les noms de classes et l'API JS peuvent différer.

## Philosophie beerCSS (lire en premier)

beerCSS suit la "Reinheitsgebot" (loi de pureté) : **3 ingrédients seulement**.

| Ingrédient | Rôle |
|---|---|
| **Settings** | Thème global (dark/light, CSS variables) |
| **Elements** | Composants HTML natifs enrichis (`<button>`, `<dialog>`, `<nav>`, etc.) |
| **Helpers** | Classes utilitaires qui modifient les éléments (`round`, `fill`, `small`, `center-align`…) |

> beerCSS n'est PAS BEM, ni Tailwind, ni Bootstrap. Il enrichit les balises HTML sémantiques natives.

## Procédure de résolution

### Étape 1 — Identifier l'intention

Classer la demande :
- **Nouveau composant** → [components-reference.md](./references/components-reference.md)
- **Mise en page / layout / grid** → [layout-grid-reference.md](./references/layout-grid-reference.md)
- **Helpers (couleurs, marges, formes, tailles…)** → [helpers-reference.md](./references/helpers-reference.md)
- **Thème dynamique / Material You / dark-light** → [theme-dynamic-reference.md](./references/theme-dynamic-reference.md)
- **Intégration partielle / framework / scoped** → [versions-scoped-custom-element.md](./references/versions-scoped-custom-element.md)
- **Bug / comportement inattendu** → [debug-bugs-reference.md](./references/debug-bugs-reference.md)

### Étape 2 — Vérifier la documentation source

La documentation complète est dans `./docs/`. Consulter le fichier correspondant au composant :

| Composant | Fichier doc |
|---|---|
| Button | [BUTTON.md](./docs/BUTTON.md) |
| Card/Article | [CARD.md](./docs/CARD.md) |
| Dialog | [DIALOG.md](./docs/DIALOG.md) |
| Grid | [GRID.md](./docs/GRID.md) |
| Icon | [ICON.md](./docs/ICON.md) |
| Input/Field | [INPUT.md](./docs/INPUT.md) |
| Layout principal | [MAIN_LAYOUT.md](./docs/MAIN_LAYOUT.md) |
| Navigation | [NAVIGATION.md](./docs/NAVIGATION.md) |
| Menu | [MENU.md](./docs/MENU.md) |
| Overlay | [OVERLAY.md](./docs/OVERLAY.md) |
| Snackbar | [SNACKBAR.md](./docs/SNACKBAR.md) |
| Table | [TABLE.md](./docs/TABLE.md) |
| Tabs/Page | [TABS.md](./docs/TABS.md) |
| Typography | [TYPOGRAPHY.md](./docs/TYPOGRAPHY.md) |
| Tous les helpers | [HELPERS.md](./docs/HELPERS.md) |
| Résumé global | [SUMMARY.md](./docs/SUMMARY.md) |
| JavaScript API | [JAVASCRIPT.md](./docs/JAVASCRIPT.md) |

### Étape 3 — Générer le HTML

Règles absolues à respecter :
1. **Ne jamais mettre des classes beerCSS sur les enfants directs d'une `grid`** — encapsuler dans un `<div>` neutre
2. **Les icônes Material Symbols** s'écrivent avec `<i>nom_icone</i>` (pas de balise `<span>` ni de classe spéciale)
3. **`data-ui="#id"`** remplace le JS pour ouvrir/fermer dialog, menu, overlay, snackbar, pages
4. **`responsive`** sur `<main>` centre le contenu et applique une max-width
5. **Les couleurs** sont des helpers CSS : `primary`, `secondary`, `tertiary`, `error` + suffixes `-text`, `-border`, `-container`

### Étape 4 — Valider

Checklist rapide :
- [ ] Les éléments natifs HTML sémantiques sont utilisés (`<nav>`, `<header>`, `<main>`, `<dialog>`, `<button>`, `<article>`)
- [ ] La grid n'a que des `<div>` neutres en enfants directs
- [ ] Les tailles responsives sont définies : `s12 m6 l3` (ou similaire)
- [ ] `data-ui` est présent sur les déclencheurs si un JS minimal est souhaité
- [ ] Le thème est défini sur `<body>` (`light` ou `dark`) ou laissé auto

## Settings & Thème

```html
<!-- Auto (suit le device) -->
<body>

<!-- Force light -->
<body class="light">

<!-- Force dark -->
<body class="dark">
```

**Variables CSS principales** : `--primary`, `--secondary`, `--tertiary`, `--background`, `--surface`, `--on-primary`…

**Thème dynamique** (requiert `material-dynamic-colors`) :
```js
await ui("theme", "#6750a4");  // depuis une couleur hex
await ui("mode", "dark");       // changer le mode
```

## Installation rapide (rappel)

```html
<link href="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.css" rel="stylesheet" />
<script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.js"></script>
<script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
```

## Références détaillées

- [Composants & classes courantes](./references/components-reference.md)
- [Layout, Grid & responsive](./references/layout-grid-reference.md)
- [Helpers complets (couleurs, marges, formes…)](./references/helpers-reference.md)
- [Thème dynamique & Material You](./references/theme-dynamic-reference.md)
- [Versions Default / Scoped / Custom Element](./references/versions-scoped-custom-element.md)
- [Debug & bugs courants](./references/debug-bugs-reference.md)
