# Thème Dynamique & Material You — beerCSS

## Installation requise

Pour le thème dynamique, **deux libs sont nécessaires** :

```html
<!-- CSS + JS beerCSS -->
<link href="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.css" rel="stylesheet" />
<script type="module" src="https://cdn.jsdelivr.net/npm/beercss@4.0.20/dist/cdn/beer.min.js"></script>

<!-- Material Dynamic Colors (requis pour ui("theme", ...) ) -->
<script type="module" src="https://cdn.jsdelivr.net/npm/material-dynamic-colors@1.1.4/dist/cdn/material-dynamic-colors.min.js"></script>
```

```js
// NPM
import "beercss";
import "material-dynamic-colors";
```

> `ui("mode", ...)` ne requiert **pas** material-dynamic-colors.  
> `ui("theme", ...)` le **requiert**.

---

## Changer le mode (dark / light)

```js
// Passer en mode clair
ui("mode", "light");

// Passer en mode sombre
ui("mode", "dark");

// Suivre les préférences du device
ui("mode", "auto");

// Lire le mode actuel → retourne "light" ou "dark"
const mode = ui("mode");
```

**Via HTML** (au chargement) :
```html
<body class="light">   <!-- force light -->
<body class="dark">    <!-- force dark -->
<body>                 <!-- suit le device (recommandé) -->
```

---

## Générer un thème depuis une couleur (Material You)

```js
// Depuis une couleur hex
let theme = await ui("theme", "#6750a4");

// Depuis une URL d'image (attention CORS)
let theme = await ui("theme", "https://example.com/image.jpg");

// Depuis un chemin local
let theme = await ui("theme", "/assets/image.png");

// Depuis un input[type=file]
const file = document.querySelector("input[type='file']").files[0];
let theme = await ui("theme", file);

// Depuis un Blob
let theme = await ui("theme", blob);

// Lire le thème actuel
let theme = await ui("theme");
```

### Structure retournée par `ui("theme")`

```js
{
  dark: "--primary:#cfbcff;--on-primary:#381e72;--primary-container:#4f378a;...",
  light: "--primary:#6750a4;--on-primary:#ffffff;--primary-container:#e9ddff;..."
}
```

### Sauvegarder et réappliquer un thème

```js
// Sauvegarder
const theme = await ui("theme");
localStorage.setItem("app-theme", JSON.stringify(theme));

// Réappliquer au prochain chargement
const saved = localStorage.getItem("app-theme");
if (saved) await ui("theme", JSON.parse(saved));
```

---

## Personnaliser le thème statiquement (CSS)

Pour une marque avec couleurs fixes, sans Material You :

```css
:root,
body.light {
  --primary: #1a73e8;
  --on-primary: #ffffff;
  --primary-container: #d2e3fc;
  --on-primary-container: #001d35;

  --secondary: #0f9d58;
  --on-secondary: #ffffff;
  --secondary-container: #c8e6c9;
  --on-secondary-container: #002106;

  --background: #f8f9fa;
  --on-background: #202124;
  --surface: #ffffff;
  --on-surface: #202124;

  /* Autres tokens Material 3 selon besoin... */
}

body.dark {
  --primary: #8ab4f8;
  --on-primary: #003062;
  --primary-container: #004994;
  --on-primary-container: #d2e3fc;

  --background: #202124;
  --on-background: #e8eaed;
  --surface: #292a2d;
  --on-surface: #e8eaed;
}
```

---

## Variables CSS disponibles

| Variable | Rôle |
|---|---|
| `--primary` | Couleur principale |
| `--on-primary` | Texte sur fond primary |
| `--primary-container` | Fond léger primary |
| `--on-primary-container` | Texte sur primary-container |
| `--secondary` | Couleur secondaire |
| `--on-secondary` | Texte sur fond secondary |
| `--secondary-container` | Fond léger secondary |
| `--tertiary` | Couleur tertiaire |
| `--error` | Couleur erreur |
| `--background` | Fond de page |
| `--on-background` | Texte sur background |
| `--surface` | Fond des surfaces (cartes, dialogs) |
| `--on-surface` | Texte sur surface |
| `--surface-variant` | Variante surface |
| `--outline` | Bordures |
| `--outline-variant` | Bordures légères |
| `--shadow` | Couleur des ombres |
| `--size` | Taille de base (rem) |
| `--font` | Police principale |
| `--font-icon` | Police des icônes |
| `--speed1`...`--speed4` | Durées d'animation |

---

## Bouton toggle dark/light — exemple complet

```html
<button class="circle border" id="btn-theme">
  <i id="theme-icon">dark_mode</i>
</button>

<script type="module">
  import "beercss";

  const btn = document.getElementById("btn-theme");
  const icon = document.getElementById("theme-icon");

  btn.addEventListener("click", () => {
    const current = ui("mode");
    const next = current === "dark" ? "light" : "dark";
    ui("mode", next);
    icon.textContent = next === "dark" ? "light_mode" : "dark_mode";
  });
</script>
```

---

## Sélecteur de couleur de thème — exemple complet

```html
<input type="color" id="color-picker" value="#6750a4">
<p id="theme-status">Thème appliqué</p>

<script type="module">
  import "beercss";
  import "material-dynamic-colors";

  document.getElementById("color-picker").addEventListener("input", async (e) => {
    const theme = await ui("theme", e.target.value);
    document.getElementById("theme-status").textContent = "Thème : " + e.target.value;
  });
</script>
```

---

## Depuis une image uploadée

```html
<div class="field label prefix border">
  <i>image</i>
  <input type="file" accept="image/*" id="img-input">
  <label>Image pour le thème</label>
</div>

<script type="module">
  import "beercss";
  import "material-dynamic-colors";

  document.getElementById("img-input").addEventListener("change", async (e) => {
    const file = e.target.files[0];
    if (file) await ui("theme", file);
  });
</script>
```

---

## Notes importantes

- `material-dynamic-colors` doit être importé **avant** tout appel à `ui("theme", value)`
- Le thème est appliqué sur l'élément `<body>` sous forme d'attribut `style` inline
- Compatible avec toutes les couleurs Material You (M3)
- Voir [Codepen officiel](https://codepen.io/leo-bnu/pen/LYWxjVG) pour un exemple interactif complet
