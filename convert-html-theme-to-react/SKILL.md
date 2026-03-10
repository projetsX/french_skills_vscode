---
name: convert-html-theme-to-react
description: 'Convert HTML/CSS theme templates into reusable React components. Use when: migrating theme files to React, preserving existing CSS structure, handling JavaScript animations with React hooks, decomposing large components.'
argument-hint: '[THEME_FOLDER_PATH] - Path to the HTML/CSS theme source files'
user-invocable: true
---

# Convertir un thème HTML en composants React

Flux de travail procédural pour migrer des thèmes HTML/CSS vers des composants React modulaires en conservant le style et la logique d'animation basée sur des hooks.

## Quand l'utiliser

- Importer un thème HTML/CSS complet dans un projet React
- Convertir un balisage HTML statique en une bibliothèque de composants réutilisables
- Migrer des animations JavaScript/jQuery vers des hooks React
- Assurer la cohérence visuelle avec le design du thème original
- Décomposer des fichiers de composants volumineux en modules maintenables

## Prérequis

- Fichiers source HTML/CSS du thème avec la structure complète des assets
- Connaissance des noms de classes CSS et de la mise en page du thème original
- Compréhension des animations ou interactions présentes dans le JavaScript du thème

## Exécution du script d'initialisation

Un script d'initialisation est fourni pour créer rapidement la structure de répertoires requise.

- Linux / macOS (Bash) :
```
bash scripts/theme-to-react-setup.sh [THEME_NAME] [TARGET_PATH]
```

- Windows (PowerShell) :
```
PowerShell -ExecutionPolicy Bypass -File scripts/theme-to-react-setup.ps1 -ThemeName "bootstrap" -ThemePath "."
```

Les arguments sont optionnels : `THEME_NAME` (par défaut `bootstrap`) et `TARGET_PATH` (par défaut `.`).

## Procédure étape par étape

### Phase 1 : Organisation des assets

1. **Create assets subdirectory** in `src/assets/`
   ```
   src/assets/
   ├── theme-name/
   │   ├── css/           # All CSS files from theme
   │   ├── js/            # Original JavaScript files (for reference)
   │   └── images/        # Theme demo images and icons
   ```

2. **Copier les fichiers du thème** sans modification
- Copier tous les fichiers `.css` → `assets/theme-name/css/`
- Copier tous les fichiers `.js` → `assets/theme-name/js/` (à titre de référence uniquement)
- Copier tous les assets images → `assets/theme-name/images/`
- NE PAS modifier ni renommer les fichiers CSS à cette étape

3. **Importer le CSS globalement** dans `src/main.tsx`
   ```tsx
   import './assets/theme-name/css/main.css'
   // ... other theme CSS imports
   ```

### Phase 2 : Conversion HTML → composants React

1. **Analyser la structure HTML** des fichiers du thème
  - Identifier les composants indépendants (navigation, carte, modal, etc.)
  - Noter les dépendances de classes CSS
  - Documenter les interactions JavaScript (gestionnaires de clic, animations)

2. **Créer la structure des composants** en respectant les noms de classes
  - Chaque fichier de composant dans `src/components/`
  - Conserver exactement tous les noms de classes CSS d'origine
  - Utiliser des éléments HTML sémantiques correspondant au thème original
  - **NE PAS ajouter de CSS personnalisé** — utiliser uniquement les classes du thème

3. **Component template example**
   ```tsx
   // src/components/ThemeCard/ThemeCard.tsx
   /**
    * ThemeCard - Reusable card component from theme
    * Maps to original HTML markup with theme CSS classes
    */
   
   import React from 'react'
   
   interface ThemeCardProps {
     title: string
     content: string
     className?: string
   }
   
   export const ThemeCard: React.FC<ThemeCardProps> = ({ 
     title, 
     content, 
     className = '' 
   }) => {
     return (
       <div className={`theme-card ${className}`}>
         <h3 className="theme-card__title">{title}</h3>
         <p className="theme-card__content">{content}</p>
       </div>
     )
   }
   ```

### Phase 3 : Migration JavaScript/jQuery → hooks React

1. **Identifier les animations et interactions** dans les fichiers JS originaux
  - Gestionnaires de clic (afficher/masquer, basculer, développer)
  - Animations de défilement/fondu
  - Soumissions de formulaires
  - Interactions modal/popup

2. **Créer des hooks personnalisés** pour la logique d'animation réutilisable
   ```tsx
   // src/hooks/useThemeAnimation.ts
   /**
    * useThemeAnimation - Handle theme fade/slide animations
    * Maps original jQuery animations to React state
    */
   
   import { useState, useCallback } from 'react'

   interface UseThemeAnimationOptions {
     duration?: number
     triggerEvent?: 'click' | 'hover' | 'scroll'
   }

   export const useThemeAnimation = (
     options: UseThemeAnimationOptions = {}
   ) => {
     const { duration = 300 } = options
     const [isAnimating, setIsAnimating] = useState(false)

     const trigger = useCallback(() => {
       setIsAnimating(true)
       setTimeout(() => setIsAnimating(false), duration)
     }, [duration])

     return { isAnimating, trigger }
   }
   ```

3. **Apply hooks to components**
   ```tsx
   // Use in component:
   const { isAnimating, trigger } = useThemeAnimation({ duration: 500 })
   
   return (
     <button onClick={trigger}>
       <div className={`animated-element ${isAnimating ? 'is-active' : ''}`}>
         Content
       </div>
     </button>
   )
   ```

### Phase 4 : Décomposition des composants (si > 600 lignes)

1. **Surveiller la taille des fichiers de composants**
  - Garder chaque fichier de composant sous la barre des 600 lignes
  - Identifier la logique qui peut être extraite

2. **Create subdirectory for large components**
   ```
   src/components/
   ├── ComplexFeature/
   │   ├── index.tsx         # Parent container component
   │   ├── ComplexFeature.tsx # Main export
   │   ├── SubComponent1.tsx
   │   ├── SubComponent2.tsx
   │   └── useComplexLogic.ts
   ```

3. **Add header comment** to each sub-component
   ```tsx
   /**
    * SubComponent1
    * 
    * Part of ComplexFeature feature. Handles [specific responsibility].
    * Keeps parent component under 600-line limit.
    */
   ```

4. **Extract hooks** for reusable logic
   - State management logic → custom hooks
   - API calls / data fetching → service hooks
   - Animation controllers → animation hooks

### Phase 5 : Vérification de la qualité

Utilisez la [liste de contrôle qualité](./references/conversion-checklist.md) pour vérifier :

- [ ] Tous les noms de classes CSS correspondent exactement au thème original
- [ ] Aucun CSS personnalisé ajouté en dehors des fichiers du thème
- [ ] Toutes les animations migrées vers des hooks ou l'état des composants
- [ ] Taille des fichiers de composants sous 600 lignes (avec décomposition si nécessaire)
- [ ] Chaque composant possède un commentaire de documentation
- [ ] Toutes les props correctement typées en TypeScript
- [ ] Pas de collisions CSS avec d'autres composants
- [ ] Assets du thème correctement importés dans main.tsx
- [ ] ESLint sans avertissements

## Example Output Structure

```
src/
├── assets/
│   └── bootstrap-theme/
│       ├── css/
│       │   ├── bootstrap.css
│       │   ├── theme.css
│       │   └── components.css
│       ├── js/
│       │   └── animations.js (reference only)
│       └── images/
├── components/
│   ├── Navigation/
│   │   └── Navigation.tsx
│   ├── HeroSection/
│   │   └── HeroSection.tsx
│   ├── CardGrid/
│   │   ├── index.tsx
│   │   ├── CardGrid.tsx
│   │   ├── Card.tsx
│   │   └── useCardAnimation.ts
│   └── Footer/
│       └── Footer.tsx
├── hooks/
│   ├── useThemeAnimation.ts
│   ├── useScrollAnimation.ts
│   └── useModalToggle.ts
└── main.tsx (imports all theme CSS)
```

## Patterns courants

### Gestion du basculement de classes CSS
```tsx
const [isActive, setIsActive] = useState(false)

return (
  <div className={`theme-element ${isActive ? 'is-active' : ''}`}>
    {/* Respects original theme's is-active CSS state */}
  </div>
)
```

### Gestionnaires d'événements issus du JavaScript
```tsx
// Original: $('#element').on('click', function() { ... })
// React:
const handleClick = useCallback(() => {
  // animation or state change
}, [])

return <element onClick={handleClick} className="original-class" />
```

### Form Interactions
```tsx
const [formData, setFormData] = useState({})

const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  // Trigger validation or animations via CSS classes
}
```

## Conseils et bonnes pratiques

1. **Conserver les noms** — Garder les noms de classes CSS d'origine tels quels
2. **CSS immuable** — Ne pas modifier les fichiers CSS du thème après import
3. **Tester visuellement** — Comparer les composants rendus avec le thème HTML d'origine
4. **Documenter les animations** — Ajouter des commentaires expliquant le mapping vers les hooks
5. **Amélioration progressive** — Ajouter l'interactivité React par-dessus un CSS stable
6. **Tout typer** — Utiliser des interfaces TypeScript pour toutes les props
7. **Surveiller le bundle** — Vérifier les doublons de CSS lors d'importations multiples

## Dépannage

### Les classes CSS ne s'appliquent pas
- Vérifier l'ordre d'import des CSS dans `main.tsx`
- Vérifier que l'orthographe des classes correspond exactement à l'original
- S'assurer qu'aucun CSS module n'interfère avec les styles globaux

### Les animations ne fonctionnent pas
- Revoir la logique JavaScript d'origine dans les fichiers de référence
- Mapper les gestionnaires jQuery vers des hooks React + setState
- Tester via la timeline d'animations dans les DevTools du navigateur

### Composant trop volumineux
- Utiliser la répartition par taille pour identifier la logique extractible
- Créer des hooks pour la gestion d'état
- Séparer la présentation de la logique du conteneur
