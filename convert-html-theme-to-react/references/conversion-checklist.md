# Liste de contrôle pour la conversion Thème → React

Complétez cette liste après chaque conversion pour garantir la qualité et la cohérence.

## Configuration des assets

- [ ] Création du répertoire `src/assets/[theme-name]/css/`
- [ ] Création du répertoire `src/assets/[theme-name]/js/` (référence uniquement)
- [ ] Création du répertoire `src/assets/[theme-name]/images/`
- [ ] Tous les fichiers CSS copiés sans modification
- [ ] Tous les fichiers JavaScript copiés dans le dossier de référence
- [ ] Toutes les images copiées avec la structure de dossiers correcte
- [ ] Imports CSS ajoutés dans `src/main.tsx`

## Structure des composants

- [ ] Composants principaux créés dans `src/components/`
- [ ] Noms des composants en PascalCase
- [ ] Chaque composant a une interface TypeScript définie pour ses props
- [ ] Toutes les props correctement typées (pas de `any`)

## Conservation des classes CSS

- [ ] Tous les noms de classes CSS originaux préservés exactement
- [ ] Aucun CSS personnalisé ajouté en dehors des fichiers du thème
- [ ] Pas de changement ou de renommage de classes
- [ ] Spécificité CSS respectée comme dans le thème original
- [ ] Cohérence visuelle testée avec le thème HTML original

## Migration des animations et interactions

- [ ] Animations JavaScript documentées dans des hooks
- [ ] Gestionnaires jQuery convertis en gestionnaires d'événements React
- [ ] Hooks personnalisés créés pour la logique d'animation réutilisable
- [ ] `useState` et `useCallback` utilisés correctement
- [ ] Aucune manipulation directe du DOM en dehors de React

## Taille et organisation des composants

- [ ] Création de sous-composants pour les fichiers proches de 600 lignes
- [ ] Création de sous-répertoires avec `index.tsx` pour les fonctionnalités complexes
- [ ] Chaque sous-composant a un commentaire d'en-tête de documentation
- [ ] Logique d'animation/état extraite dans des fichiers `useXxx`
- [ ] Imports des composants parents propres et organisés

## Qualité du code

- [ ] Avertissements/erreurs ESLint : aucun
- [ ] Compilateur TypeScript passe sans erreurs
- [ ] Tous les composants correctement exportés dans les fichiers index
- [ ] Pas d'erreurs ou avertissements dans la console du navigateur
- [ ] Attributs d'accessibilité préservés (`alt`, `role`, `aria-*`)

## Documentation

- [ ] Chaque composant a un commentaire d'en-tête de documentation
- [ ] Hooks documentés avec des commentaires JSDoc
- [ ] Les interfaces de props incluent des descriptions
- [ ] Le comportement des animations expliqué dans les commentaires
- [ ] Exemples créés dans Storybook si applicable

## Tests

- [ ] Composants rendus correspondent visuellement au thème original
- [ ] Toutes les animations et interactions fonctionnelles
- [ ] Points de rupture responsive fonctionnent correctement
- [ ] Testé dans différents navigateurs (Chrome, Firefox, Safari)
- [ ] Pas de fuites mémoire dans les hooks (fonctions de nettoyage ajoutées)

## Performance

- [ ] Fichiers CSS chargés efficacement (pas de duplication)
- [ ] Images optimisées (pas d'assets surdimensionnés)
- [ ] Composants React n'entraînent pas de re-renders inutiles
- [ ] Modules Node correctement tree-shakés lors du build

## Vérification finale

- [ ] `npm run dev` démarre sans erreurs
- [ ] `npm run build` s'exécute avec succès
- [ ] `npm run lint` ne signale pas d'erreurs
- [ ] Tests de régression visuelle passés
- [ ] Prêt pour la revue de code et la fusion
