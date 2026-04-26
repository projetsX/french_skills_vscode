# Référence Helpers beerCSS — Classes Utilitaires

Les helpers modifient les éléments. Ils se combinent librement avec les éléments HTML enrichis.

---

## Alignements

| Classe | Effet |
|---|---|
| `left-align` | Contenu aligné à gauche |
| `right-align` | Contenu aligné à droite |
| `center-align` | Contenu centré horizontalement |
| `top-align` | Contenu aligné en haut |
| `bottom-align` | Contenu aligné en bas |
| `middle-align` | Contenu centré verticalement |

```html
<article class="center-align middle-align small">
  <p>Centré dans la card</p>
</article>
```

---

## Couleurs — Material You (dynamiques)

Ces classes utilisent les variables CSS `--primary`, `--secondary`, etc.

| Classe | Usage |
|---|---|
| `primary` | Fond primary |
| `on-primary` | Texte/icône sur fond primary |
| `primary-container` | Fond primary-container (plus doux) |
| `on-primary-container` | Texte sur primary-container |
| `secondary` | Fond secondary |
| `secondary-container` | Fond secondary-container |
| `tertiary` | Fond tertiary |
| `tertiary-container` | Fond tertiary-container |
| `error` | Fond erreur |
| `error-container` | Fond error-container |
| `surface` | Fond surface |
| `surface-variant` | Fond surface-variant |
| `inverse-surface` | Fond inversé |
| `background` | Fond background |

**Suffixes** : `-text` pour la couleur de texte, `-border` pour la bordure :
```html
<p class="primary-text">Texte en couleur primaire</p>
<div class="border secondary-border">Bordure secondaire</div>
<span class="error-text">Message d'erreur</span>
```

---

## Couleurs — Palette statique

Format : `{nom}` (fond), `{nom}-text` (texte), `{nom}-border` (bordure), `{nom}1`...`{nom}10` (nuances)

**Couleurs disponibles** :
`amber`, `blue`, `blue-grey`, `brown`, `cyan`, `deep-orange`, `deep-purple`, `green`, `grey`, `indigo`, `light-blue`, `light-green`, `lime`, `orange`, `pink`, `purple`, `red`, `teal`, `yellow`

```html
<div class="red">Fond rouge</div>
<div class="red5">Fond rouge nuance 5</div>
<span class="green-text">Texte vert</span>
<div class="border blue-border">Bordure bleue</div>

<!-- Noir/blanc -->
<div class="black">Fond noir</div>
<span class="black-text">Texte noir</span>
```

---

## Directions

| Classe | Effet |
|---|---|
| `horizontal` | Disposition horizontale |
| `vertical` | Disposition verticale |

---

## Élévations (ombres portées)

| Classe | Effet |
|---|---|
| `elevate` | Élévation par défaut |
| `small-elevate` | Légère ombre |
| `medium-elevate` | Ombre moyenne |
| `large-elevate` | Forte ombre |
| `no-elevate` | Supprime l'élévation |

---

## Formes

| Classe | Effet |
|---|---|
| `border` | Ajoute une bordure |
| `no-border` | Supprime la bordure |
| `round` | Coins arrondis (par défaut beerCSS) |
| `no-round` | Coins carrés |
| `small-round` | Léger arrondi |
| `medium-round` | Arrondi moyen |
| `large-round` | Fort arrondi |
| `left-round` | Arrondi côté gauche seulement |
| `right-round` | Arrondi côté droit seulement |
| `top-round` | Arrondi en haut seulement |
| `bottom-round` | Arrondi en bas seulement |
| `circle` | Cercle parfait |
| `square` | Carré parfait |
| `fill` | Remplissage du conteneur |
| `extend` | Extension (FAB étendu) |
| `tabbed` | Style onglet |

---

## Marges

| Classe | Effet |
|---|---|
| `margin` | Marge par défaut |
| `no-margin` | Supprime les marges |
| `auto-margin` | Marges automatiques (center) |
| `tiny-margin` | Très petite marge |
| `small-margin` | Petite marge |
| `medium-margin` | Marge moyenne |
| `large-margin` | Grande marge |
| `left-margin` | Marge gauche uniquement |
| `right-margin` | Marge droite uniquement |
| `top-margin` | Marge haut uniquement |
| `bottom-margin` | Marge bas uniquement |
| `horizontal-margin` | Marges gauche+droite |
| `vertical-margin` | Marges haut+bas |

---

## Paddings

| Classe | Effet |
|---|---|
| `padding` | Padding par défaut |
| `no-padding` | Supprime le padding |
| `tiny-padding` | Très petit padding |
| `small-padding` | Petit padding |
| `medium-padding` | Padding moyen |
| `large-padding` | Grand padding |
| `left-padding` | Padding gauche uniquement |
| `right-padding` | Padding droit uniquement |
| `top-padding` | Padding haut uniquement |
| `bottom-padding` | Padding bas uniquement |
| `horizontal-padding` | Padding gauche+droite |
| `vertical-padding` | Padding haut+bas |

---

## Positions

| Classe | Effet |
|---|---|
| `left` | Positionne à gauche |
| `right` | Positionne à droite |
| `top` | Positionne en haut |
| `bottom` | Positionne en bas |
| `center` | Centre horizontalement |
| `middle` | Centre verticalement |
| `front` | z-index avant |
| `back` | z-index arrière |

---

## Tailles

| Classe | Effet |
|---|---|
| `tiny` | Très petit |
| `small` | Petit |
| `medium` | Moyen |
| `large` | Grand |
| `extra` | Très grand (ex: FAB) |
| `max` | Prend tout l'espace disponible |
| `responsive` | Centré + max-width adaptative |
| `wrap` | Permet le retour à la ligne |
| `no-wrap` | Force sur une seule ligne |
| `auto-width` | Largeur automatique |
| `small-width` | Largeur fixe petite |
| `medium-width` | Largeur fixe moyenne |
| `large-width` | Largeur fixe grande |
| `auto-height` | Hauteur automatique |
| `small-height` | Hauteur fixe petite |
| `medium-height` | Hauteur fixe grande |
| `large-height` | Hauteur fixe grande |

---

## Espaces (grid)

| Classe | Effet |
|---|---|
| `space` | Espacement par défaut entre cellules |
| `no-space` | Pas d'espacement |
| `small-space` | Petit espacement |
| `medium-space` | Espacement moyen |
| `large-space` | Grand espacement |

---

## Opacités

| Classe | Effet |
|---|---|
| `opacity` | Opacité par défaut (réduite) |
| `no-opacity` | Opaque (100%) |
| `small-opacity` | Légère transparence |
| `medium-opacity` | Transparence moyenne |
| `large-opacity` | Forte transparence |

---

## Ombres directionnelles

```html
<div class="shadow">Ombre générale</div>
<div class="top-shadow">Ombre en haut</div>
<div class="bottom-shadow">Ombre en bas</div>
<div class="left-shadow">Ombre à gauche</div>
<div class="right-shadow">Ombre à droite</div>
```

---

## Flous (backdrop-filter)

```html
<div class="blur">Flou standard</div>
<div class="small-blur">Léger flou</div>
<div class="medium-blur">Flou moyen</div>
<div class="large-blur">Fort flou</div>
<div class="light">Fond clair transparent</div>
<div class="dark">Fond sombre transparent</div>
```

---

## Scroll

```html
<div class="scroll">Scroll vertical</div>
<div class="scroll horizontal">Scroll horizontal</div>
<div class="no-scroll">Scroll désactivé</div>
```

---

## Ripple (effet Material)

```html
<div class="ripple">Ripple par défaut</div>
<div class="slow-ripple">Ripple lent</div>
<div class="fast-ripple">Ripple rapide</div>
```

---

## État actif

```html
<!-- active — utilisé pour dialog, tabs, page, menu, input label -->
<a class="active">Onglet actif</a>
<dialog class="active">Dialog ouvert</dialog>
<div class="page active">Page visible</div>
<input class="active">  <!-- label monté -->
```

---

## Responsive grid (breakpoints)

```html
<!-- s = small (< 600px), m = medium (600–1024px), l = large (> 1024px) -->
<div class="grid">
  <div class="s12 m6 l4"><!-- pleine largeur mobile, demi tablette, 1/3 desktop --></div>
  <div class="s12 m6 l4">...</div>
  <div class="s12 m12 l4">...</div>
</div>

<!-- Classes visibilité responsive -->
<div class="s">Visible seulement sur mobile</div>
<div class="m">Visible seulement sur tablette</div>
<div class="l">Visible seulement sur desktop</div>
```

---

## Combinaisons courantes

```html
<!-- Centrer un bloc -->
<div class="auto-margin medium-width">Contenu centré</div>

<!-- Card colorée avec padding -->
<article class="primary-container medium-padding round">
  <p class="on-primary-container-text">Texte</p>
</article>

<!-- Bouton pleine largeur + arrondi -->
<button class="responsive round">S'inscrire</button>

<!-- Barre de navigation fixe en bas -->
<nav class="bottom primary">
  <a><i>home</i><span>Accueil</span></a>
</nav>

<!-- Texte d'erreur sous un champ -->
<div class="field label border">
  <input type="email">
  <label>Email</label>
  <span class="error-text small-text">Email invalide</span>
</div>
```

---

## Typographie (helpers)

| Classe | Balise associée |
|---|---|
| `bold` | Texte en gras |
| `italic` | Texte en italique |
| `underline` | Texte souligné |
| `upper` | Texte en majuscules |
| `lower` | Texte en minuscules |
| `capitalize` | Première lettre en majuscule |
| `small-text` | Petit texte |
| `large-text` | Grand texte |
| `no-line` | Supprime le soulignement des liens |
| `link` | Style lien |
| `inverse-link` | Lien inversé (pour fond sombre) |
