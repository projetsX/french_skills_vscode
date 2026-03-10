# Checklist de Refactorisation

## Avant de commencer

- [ ] Composant fait **400+ lignes** de code
- [ ] Composant a **5+ états ou props** importants
- [ ] Vous pouvez identifier **3+ sections logiques distinctes**
- [ ] Tests existants pour le composant
- [ ] Branche git créée pour les changements

## Création de la structure

- [ ] Dossier `snake_case` créé avec nom adapté au parent
  - Exemple: `infosProfilUser` → `infos_profil_user/`
- [ ] Fichier parent `ComponentName.tsx` dans le dossier
- [ ] Sous-dossier ne contient QUE ce qui est spécifique
- [ ] Fichier index (optionnel) pour exporter facilement

## Création des sous-composants

- [ ] Chaque sous-composant a **un seul domaine** de responsabilité
- [ ] Noms respectent la convention: `ParentNamePart.tsx`
  - ✅ `UserProfilePhoto.tsx`, `UserProfileBio.tsx`
  - ❌ `Photo.tsx`, `Section1.tsx`
- [ ] **Commentaire d'en-tête** en haut de chaque fichier
  - Format: `// Composant pour [description rapide]`
- [ ] Props clairement typées (TypeScript)
- [ ] Aucun état partagé "caché" entre sous-composants

### Exemple de commentaire d'en-tête:
```typescript
/**
 * Composant pour afficher et éditer la biographie de l'utilisateur.
 * Gère les changements d'état et API calls pour la mise à jour.
 */
export function UserProfileBio({ bio, onUpdate }) {
  // ...
}
```

## Extraction des hooks

- [ ] Hooks complexes **extraits en fichiers séparés**
- [ ] Nomage suit la convention `use[Feature].ts`
  - ✅ `usePhotoUpload.ts`, `useUserData.ts`
  - ❌ `photo.ts`, `data.ts`
- [ ] **Commentaire d'en-tête** pour chaque hook
  - Format: `// Hook pour [responsabilité], retourne [types]`
- [ ] Hooks génériques (réutilisables) clairement documentés
- [ ] Dépendances du hook listées et justifiées

### Exemple de commentaire d'en-tête pour hook:
```typescript
/**
 * Hook pour gérer le formulaire de biographie.
 * Retourne: [bio, setBio, hasChanged, handleSubmit]
 */
export function useBioForm(initialBio: string) {
  // ...
}
```

## Styles et CSS

- [ ] Import de styles mis à jour si nécessaire
  - Styles globaux: reste dans parent ou séparé
  - Styles spécifiques: reste avec le sous-composant
- [ ] Classes CSS renommées si nécessaire pour clarté
- [ ] Pas de duplication de styles

## État et Props

- [ ] État complexe migré dans hooks personnalisés
- [ ] Props enfants **simples et nombreuses < 6**
- [ ] Valeurs par défaut définies pour props optionnelles
- [ ] Pas d'effet de bord dans le corps du composant
- [ ] `useCallback` utilisé pour handlers si performance critique

## Import/Exports

- [ ] Imports organisés (React, libs, composants, hooks, styles)
- [ ] Exports sont nommés (pas d'exports par défaut si possible)
- [ ] Chemins clairs: `./UserProfilePhoto` ou `./hooks/usePhotoUpload`
- [ ] Fichier `index.ts` (optionnel) pour exporter facilement

```typescript
// index.ts (optionnel)
export { UserProfile } from './UserProfile';
export { usePhotoUpload } from './hooks/usePhotoUpload';
```

## Tests & Validation

- [ ] Tests unitaires mis à jour pour chaque sous-composant
- [ ] Tests d'intégration pour le composant parent
- [ ] Tous les tests **passent sans erreur**
- [ ] Pas de `console.warn` ou `console.error`
- [ ] Comportement visuel **identique** aux avant/après

## Fonctionnalités préservées

- [ ] Tous les appels API/logique métier fonctionnent
- [ ] Pas de perte de données lors de refactoring
- [ ] Animations/transitions si présentes, toujours actives
- [ ] Accessibilité (a11y) respectée et testée

## Documentation & Cleanup

- [ ] Commentaires clarifiés sur les sections complexes
- [ ] Pas de code "mort" ou console.log() de debug
- [ ] Dépendances package.json à jour si besoin
- [ ] Fichier `package.json` ou `tsconfig` ajusté si paths utilisées

## Validation finale

- [ ] Branche prête pour PR/review
- [ ] Messaging git clair: 
  - "refactor: decompose UserProfile into smaller components"
- [ ] Au moins un co-dev a review le refactoring
- [ ] Performance acceptable (pas de reg perf)
- [ ] Deploi prévu en staging d'abord
