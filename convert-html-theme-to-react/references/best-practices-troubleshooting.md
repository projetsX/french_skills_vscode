# Bonnes pratiques & dépannage

Les choses à faire et à éviter pour les conversions de thème vers React.

## À FAIRE ✅

- **Conserver les noms de classes CSS** — Copier exactement, ne pas renommer
- **Tester visuellement** — Comparer côte à côte avec le thème HTML original
- **Documenter les hypothèses** — Ajouter des commentaires sur le comportement du thème original
- **Utiliser TypeScript** — Taper toutes les props, états et paramètres des hooks
- **Importer le CSS globalement** — Charger les styles du thème dans `main.tsx` ou le composant racine
- **Versionner les assets** — Committer tous les fichiers du thème copiés
- **Vérifier la spécificité CSS** — S'assurer qu'il n'y a pas de conflits avec d'autres styles
- **Créer des hooks** — Réutiliser la logique d'animation/état entre composants
- **Ajouter des commentaires JSDoc** — Documenter les hooks et composants complexes

## À NE PAS FAIRE ❌

- **Ne pas modifier les fichiers CSS du thème** — N'éditer que pour corriger de vrais bugs
- **Ne pas ajouter de CSS supplémentaire** — Utiliser exclusivement les classes du thème
- **Ne pas utiliser CSS Modules** — Le CSS global du thème risquerait de ne pas fonctionner
- **Ne pas manipuler le DOM directement** — Utiliser l'état et les props React
- **Ne pas oublier le nettoyage** — Ajouter les retours de `useEffect` pour le cleanup
- **Ne pas hoister tout l'état au parent** — Garder l'état local au composant quand c'est possible
- **Ne pas créer de composants massifs** — Surveiller la taille et décomposer tôt
- **Ne pas sauter TypeScript** — Utiliser des types précis au lieu de `any`

## Common Issues & Solutions

### Problème : Les classes CSS ne s'appliquent pas

**Symptôme** : Les styles n'apparaissent pas malgré des noms de classes corrects

**Solutions** :

1. Vérifier l'ordre d'import des fichiers CSS dans `main.tsx`
2. Vérifier que l'orthographe des classes correspond exactement au CSS du thème
3. Chercher des conflits de spécificité CSS avec d'autres styles chargés
4. S'assurer que les fichiers CSS utilisent des chemins relatifs corrects dans le dossier assets

```tsx
// main.tsx - Ordre d'import correct
import "./assets/theme-name/css/reset.css"; // Reset en premier
import "./assets/theme-name/css/variables.css"; // Variables
import "./assets/theme-name/css/components.css"; // Composants
import "./assets/theme-name/css/theme.css"; // Thème
import "./index.css"; // Styles de l'app en dernier
```

### Problème : Animations non fluides

**Symptôme** : Les animations saccadent ou ne fonctionnent pas

**Solutions** :

1. Utiliser `requestAnimationFrame` plutôt que `setInterval`
2. Vérifier qu'aucune re-render multiple n'est déclenchée
3. Envelopper les fonctions d'animation dans `useCallback`
4. Vérifier que le nettoyage a bien lieu dans `useEffect`

```tsx
// BON - Animation fluide
const animate = useCallback(() => {
  const start = Date.now();

  const frame = () => {
    const progress = (Date.now() - start) / duration;
    setOpacity(progress);
    if (progress < 1) requestAnimationFrame(frame);
  };

  requestAnimationFrame(frame);
}, []);

// MAUVAIS - Animation saccadée
setInterval(() => {
  setOpacity((prev) => prev + 0.01);
}, 16);
```

### Problème : Fuite mémoire au démontage du composant

**Symptôme** : La console signale des fuites mémoire lors du unmount

**Solutions** :

1. Toujours nettoyer les écouteurs d'événements
2. Effacer timeouts/intervals dans le return de `useEffect`
3. Annuler les animations au démontage

```tsx
// BON - Avec cleanup
useEffect(() => {
  const handler = () => {
    /* ... */
  };
  window.addEventListener("scroll", handler);

  return () => {
    window.removeEventListener("scroll", handler);
  };
}, []);

// MAUVAIS - Pas de nettoyage
useEffect(() => {
  window.addEventListener("scroll", () => {
    /* ... */
  });
}, []);
```

### Problème : Fichier de composant trop volumineux

**Symptôme** : Un seul composant dépasse 600 lignes

**Solutions** :

1. Extraire des sous-composants → fichiers séparés
2. Extraire des hooks → fichiers `useXxx.ts` séparés
3. Extraire les types → fichier `types.ts` séparé
4. Utiliser le pattern répertoire de composant avec `index.tsx`

```
Avant : ComponentName.tsx (800 lignes)

Après :
ComponentName/
├── index.tsx (export)
├── ComponentName.tsx (300 lignes)
├── SubComponent1.tsx
├── SubComponent2.tsx
├── useComponentLogic.ts
└── types.ts
```

### Problème : Erreurs TypeScript avec les props

**Symptôme** : Les props ne sont pas reconnues, de nombreuses erreurs de type

**Solutions** :

1. Définir clairement les interfaces de props
2. Exporter les interfaces depuis un fichier `types`
3. Utiliser des types spécifiques, éviter `any`
4. Activer le mode strict TypeScript

```tsx
// BON - Avec types
interface CardProps {
  title: string;
  onClick: (id: string) => void;
  className?: string;
}

export const Card: React.FC<CardProps> = ({
  title,
  onClick,
  className = "",
}) => {
  // Implémentation
};

// MAUVAIS - Avec any
export const Card: React.FC<any> = (props) => {
  // Implémentation
};
```

### Problème : Dégradation des performances

**Symptôme** : La page ralentit avec de nombreux composants du thème

**Solutions** :

1. Utiliser `React.memo` pour les composants qui n'ont pas besoin de mises à jour fréquentes
2. Utiliser `useMemo` pour les calculs coûteux
3. Charger en lazy le CSS du thème qui n'est pas immédiatement nécessaire
4. Analyser la taille du bundle des assets du thème

```tsx
// BON - Mémoïsation pour éviter les re-renders
export const ThemeCard = React.memo(({ title, content }: Props) => {
  return <div className="theme-card">{title}</div>;
});

// BON - Calcul mémoïsé
const memoizedValue = useMemo(() => {
  return expensiveCalculation(data);
}, [data]);
```

### Problème : Le design responsive casse

**Symptôme** : La disposition ne s'adapte pas aux mobiles/tablettes

**Solutions** :

1. Vérifier que les media queries CSS sont présentes dans les fichiers du thème importés
2. Tester aux points de rupture réels
3. Vérifier la balise meta viewport dans le HTML
4. S'assurer que la taille de police de base est correctement définie

```html
<!-- index.html - Requis pour le responsive -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

## Liste de validation avant déploiement

- [ ] Exécuter `npm run lint` → 0 erreurs
- [ ] Exécuter `npm run build` → s'exécute sans erreurs
- [ ] Ouvrir les DevTools → pas d'erreurs ou avertissements dans la console
- [ ] Vérifier l'onglet réseau → tous les CSS/JS chargés correctement
- [ ] Tester les animations → fluides et réactives
- [ ] Tester sur mobile → le layout responsive fonctionne
- [ ] Audit Lighthouse → Core Web Vitals satisfaisants
- [ ] Régression visuelle → correspond au design du thème original

## Outils de débogage

### Inspecteur (DevTools)

1. Clic droit sur un élément → Inspecter
2. Vérifier si les classes correctes sont appliquées
3. Consulter les styles calculés
4. Rechercher des règles CSS conflictuelles

### React DevTools

1. Installer l'extension React DevTools
2. Vérifier les props des composants dans l'onglet Elements
3. Profiler les performances de rendu
4. Suivre les changements d'état

### Onglet Performance

1. DevTools → onglet Performance
2. Enregistrer une interaction
3. Rechercher les tâches longues et les goulets d'étranglement de rendu
4. Identifier les chutes d'images d'animation

## Indicateurs de performance

Suivre ces métriques pour les composants du thème :

- **First Contentful Paint (FCP)** : < 1.8s
- **Largest Contentful Paint (LCP)** : < 2.5s
- **Cumulative Layout Shift (CLS)** : < 0.1
- **Time to Interactive (TTI)** : < 3.8s
- **Taille du bundle CSS** : < 50KB (après gzip)

Utiliser l'audit Lighthouse : `npm run build && npm run preview`

## Stratégies de test

### Tests de régression visuelle

1. Prendre des captures d'écran du thème HTML original
2. Prendre des captures d'écran des composants React
3. Comparer pixel par pixel
4. Documenter les différences intentionnelles

### Tests d'interaction

```typescript
// Exemple : test d'interaction d'un composant
import { render, screen, userEvent } from '@testing-library/react'
import { Card } from './Card'

test('le gestionnaire de clic du Card est appelé avec les bonnes données', async () => {
  const handleClick = vi.fn()
  render(<Card onClick={handleClick} />)

  await userEvent.click(screen.getByRole('button'))
  expect(handleClick).toHaveBeenCalled()
})
```

### Tests d'animation

```typescript
// Tester les changements d'état d'une animation
test("l'animation se termine correctement", async () => {
  const { result } = renderHook(() => useAnimationFade());

  act(() => {
    result.current.fadeIn(100);
  });

  expect(result.current.isVisible).toBe(true);
});
```

## Obtenir de l'aide

- Vérifier les fichiers CSS du thème pour le comportement des classes d'origine
- Se référer au balisage HTML original pour la structure
- Consulter la console du navigateur pour les erreurs React/TypeScript
- Utiliser React DevTools pour inspecter l'état des composants
- Tester dans l'onglet Réseau des DevTools pour les problèmes de chargement CSS
