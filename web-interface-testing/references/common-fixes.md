# Fixes Courantes - Bugs d'Interface Web

Répertoire de fixes courantes pour les problèmes détectés lors du testing d'interface.

## 1. Accessibilité - Images sans Alt

### 🔴 Bug
```html
<!-- MAUVAIS -->
<img src="logo.png">
<img src="banner.jpg" alt="">
```

### ✅ Fix
```html
<!-- BON -->
<img src="logo.png" alt="Logo de l'entreprise">
<img src="banner.jpg" alt="Bannière promotion printemps 2025">
```

### 📝 Guideline
- Chaque `<img>` doit avoir `alt=""` non-vide sauf si purement décorativo
- Pour images décoratives: `alt=""` est correcte
- Décrire le contenu OU l'intention

---

## 2. Accessibilité - Labels non-liés

### 🔴 Bug
```html
<!-- MAUVAIS -->
<label>Email</label>
<input type="email" name="email">

<label for="password">Password</label>
<input type="password" id="pwd">  <!-- id mismatch! -->
```

### ✅ Fix
```html
<!-- BON -->
<label for="email">Email</label>
<input type="email" id="email" name="email">

<label for="password">Password</label>
<input type="password" id="password" name="password">
```

### 📝 Guideline
- `<label for="xxx">` doit correspondre à `<input id="xxx">`
- Ou wrapper l'input dans label: `<label>Email <input type="email"></label>`

---

## 3. Accessibilité - Hiérarchie de Titres

### 🔴 Bug
```html
<!-- MAUVAIS -->
<h1>Page Title</h1>
  <h3>Section 1</h3>  <!-- h1 → h3: saute h2! -->
    <h2>Subsection</h2>

<h1>Another H1</h1>  <!-- Multiple h1s -->
```

### ✅ Fix
```html
<!-- BON -->
<h1>Page Title</h1>
  <h2>Section 1</h2>
    <h3>Subsection</h3>

<!-- Une seule h1 par page -->
```

### 📝 Guideline
- Hiérarchie logique: h1 → h2 → h3 → h4 (pas de sauts!)
- Une seule `<h1>` par page

---

## 4. Responsive - Débordement Horizontal

### 🔴 Bug
```css
/* MAUVAIS */
.container {
    width: 1200px;  /* Fixe, pas responsive! */
}

.image {
    width: 1000px;  /* Trop large sur mobile */
}
```

### ✅ Fix
```css
/* BON */
.container {
    max-width: 1200px;
    width: 100%;
    margin: 0 auto;
    padding: 0 1rem;
}

.image {
    max-width: 100%;
    height: auto;
}

/* Media query pour petit écran */
@media (max-width: 768px) {
    .container {
        padding: 0 0.5rem;
    }
}
```

### 📝 Guideline
- Utiliser `max-width` au lieu de `width` fixe
- Images: `max-width: 100%; height: auto;`
- Padding/margin adaptatif via media queries

---

## 5. Responsive - Menu Mobile

### 🔴 Bug
```html
<!-- MAUVAIS -->
<nav>
    <ul style="display: flex;">
        <li><a href="#">Home</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Contact</a></li>
    </ul>
</nav>

<!-- Menu horizontal sur mobile = débordement -->
```

### ✅ Fix
```html
<!-- BON -->
<nav>
    <button class="menu-toggle" aria-label="Toggle menu">
        ☰
    </button>
    <ul class="menu" id="menu">
        <li><a href="#">Home</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Contact</a></li>
    </ul>
</nav>

<script>
    document.querySelector('.menu-toggle').addEventListener('click', () => {
        document.getElementById('menu').classList.toggle('open');
    });
</script>
```

```css
.menu {
    display: flex;
    gap: 1rem;
}

@media (max-width: 768px) {
    .menu-toggle {
        display: block;
    }

    .menu {
        display: none;
        flex-direction: column;
        gap: 0;
        position: absolute;
        top: 100%;
        width: 100%;
    }

    .menu.open {
        display: flex;
    }

    .menu li {
        border-bottom: 1px solid #ddd;
    }
}
```

### 📝 Guideline
- Toggle menu (burger) sur mobile
- Flexbox responsive
- ARIA labels pour accessibilité

---

## 6. Performance - Image trop Large

### 🔴 Bug
```html
<!-- MAUVAIS -->
<img src="banner.jpg">  <!-- 5MB, pas optimisé! -->
```

### ✅ Fix
```html
<!-- BON: avec responsive images -->
<picture>
    <source srcset="banner-small.webp 375w, banner-medium.webp 768w, banner-large.webp 1200w" 
            type="image/webp">
    <img src="banner.jpg" 
         srcset="banner-small.jpg 375w, banner-medium.jpg 768w, banner-large.jpg 1200w"
         sizes="(max-width: 768px) 100vw, 1200px"
         alt="Bannière">
</picture>

<!-- ou: lazy loading -->
<img src="image.jpg" loading="lazy" alt="Description">
```

### 📝 Guideline
- WebP au lieu de PNG/JPG (30-50% plus petit)
- Srcset + sizes pour responsive
- `loading="lazy"` pour lazy loading

---

## 7. Performance - Script Bloc-Rendu

### 🔴 Bug
```html
<!-- MAUVAIS -->
<head>
    <script src="heavy-library.js"></script>  <!-- Bloque rendering! -->
</head>
<body>
    <!-- Contenu affiche tard... -->
</body>
```

### ✅ Fix
```html
<!-- BON -->
<head>
    <!-- Critical CSS inline -->
    <style>
        body { margin: 0; }
        .header { background: #333; }
    </style>
</head>
<body>
    <!-- Contenu visible immédiatement -->

    <!-- Scripts généraux en fin de body -->
    <script src="library.js" defer></script>
    
    <!-- Scripts critiques: async, defer ou dynamic -->
    <script async src="analytics.js"></script>
</body>
```

### 📝 Guideline
- `async` : télécharge en parallèle, exécute immédiatement (order pas garanti)
- `defer` : télécharge en parallèle, exécute après parsing (order garanti)
- Scripts non-critiques: `async` ou `defer`
- Critical CSS: inline dans `<head>`

---

## 8. Console Error - Missing Element

### 🔴 Bug Console
```
Uncaught ReferenceError: null is not an object (evaluating 'element.addEventListener')
```

### 🔍 Cause Probable
```javascript
// MAUVAIS
const button = document.getElementById('submit-btn'); 
button.addEventListener('click', handler);  // Error si element n'existe pas
```

### ✅ Fix
```javascript
// BON
const button = document.getElementById('submit-btn');
if (button) {
    button.addEventListener('click', handler);
} else {
    console.warn('Button #submit-btn not found');
}

// Ou: Optional chaining (ES2020+)
document.getElementById('submit-btn')?.addEventListener('click', handler);
```

### 📝 Guideline
- Toujours vérifier que l'élément existe avant usage
- Utiliser optional chaining `?.` au lieu de chaîning direct

---

## 9. Console Error - CORS Issue

### 🔴 Bug Console
```
Access to XMLHttpRequest at 'https://api.example.com/data' from origin 'http://localhost:3000' 
has been blocked by CORS policy
```

### ✅ Fix (Backend)
```javascript
// Node/Express
app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true
}));

// ou wildcard (dev only, NOT production)
app.use(cors());
```

### ✅ Fix (Frontend)
```javascript
// Ajouter headers
fetch('https://api.example.com/data', {
    method: 'GET',
    credentials: 'include',
    headers: {
        'Content-Type': 'application/json'
    }
});
```

### 📝 Guideline
- CORS doit être configurée côté backend/API
- Frontend: utiliser `credentials: 'include'` si nécessaire
- En dev: utiliser CORS proxy ou dev server

---

## 10. Performance - Console Warnings

### 🟡 Warning Détecté
```
[Deprecation] 'XYZMethod' is deprecated and will be removed.
```

### ✅ Fix
- Remplacer la méthode dépréciée par l'équivalent moderne
- Consulter les docs du framework/browser pour l'API moderne

### Exemples Courants
```javascript
// Vieux
var x = 5;  // → const x = 5;

// Vieux
document.write('<p>text</p>');  // → DOM manipulation avec appendChild

// Vieux
var xhr = new XMLHttpRequest();  // → fetch API

// Vieux
Class.prototype.method = function() {};  // → class syntax
```

---

## Workflow de Correction

1. **Identifier le bug** (console, accessibility, responsive, perf)
2. **Chercher le pattern** dans cette référence
3. **Appliquer la fix**
4. **Re-tester** (snapshot, console, click tests)
5. **Valider pas de régression**

---

## Ressources Utiles

| Topic | Link |
|-------|------|
| WCAG 2.1 Accessibility | https://www.w3.org/WAI/WCAG21/quickref/ |
| HTML Best Practice | https://developer.mozilla.org/en-US/docs/Learn/HTML |
| CSS Responsive | https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design |
| Web Vitals | https://web.dev/vitals/ |
| JavaScript Modern | https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide |

---

**Mise à jour**: 2025-03-10  
**Mantenue par**: Web Testing Skill
