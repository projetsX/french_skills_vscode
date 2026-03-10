---
name: react-component-refactoring
description: 'Refactoriser un composant React trop gros en petits composants et hooks réutilisables. Utiliser quand : composant dépasse 400 lignes, trop de états/logiques mélangées, complexité excessive, besoin de réutilisabilité.'
argument-hint: 'Fournir le composant React à refactoriser'
---

# Refactorisation de Composants React

## Quand utiliser

- Composant dépasse **400+ lignes**
- **Plus de 5 états** (useState) ou props importants
- **Logique mélangée** (plusieurs responsabilités)
- Besoin de **réutiliser** certaines parties en d'autres endroits
- Difficile à **maintenir et tester**

## Principes clés

1. **Organisation par domaine**: Chaque sous-composant = une responsabilité unique
2. **Nommage cohérent**: Les sous-composants reprennent le nom du parent
   - Exemple: `UserProfile.tsx` → `user_profile/` → `UserProfilePhoto.tsx`, `UserProfileBio.tsx`
3. **Extraction intelligente des hooks**: Seulement les hooks **complexes ou réutilisables**
4. **Documentation**: Peu de commentaires en haut de chaque fichier
5. **Colocalisaion**: Hooks et sous-composants dans le **même dossier**

## Procédure pas-à-pas

### Étape 1 : Analyser le composant
Consulter le [guide de décomposition](./references/decomposition-guide.md) pour :
- Identifier les blocs logiques distincts
- Déterminer quels états vont où
- Lister les hooks complexes à extraire

### Étape 2 : Planifier la structure
1. Créer un **sous-dossier** avec le nom du composant en snake_case
   - Exemple: `infosProfilUser.tsx` → `infos_profil_user/`
2. Lister chaque sous-composant à créer
3. Identifier hooks à extraire

### Étape 3 : Créer les fichiers
- Utiliser les [templates](./scripts/component-template.tsx) pour cohérence
- Ajouter un **commentaire d'en-tête** explicatif sur chaque fichier
- Pour les hooks: `// Hook personnalisé pour gérer [responsabilité]`

### Étape 4 : Valider la refactorisation
Suivre la [checklist de refactorisation](./references/refactoring-checklist.md) :
- Aucune perte de fonctionnalité
- Tous les styles/animations préservés
- Tests toujours passants
- Code plus lisible et maintenable

## Exemple de transformation

**Avant** (750 lignes, trop complexe):
```
UserProfile.tsx (logique profil + upload + stats + forms mélangées)
```

**Après** (organisé et réutilisable):
```
user_profile/
├── UserProfile.tsx (composant parent orchestrateur)
├── UserProfilePhoto.tsx (gestion photo profil)
├── UserProfileBio.tsx (édition biographie)
├── UserProfileStats.tsx (affichage statistiques)
├── useProfileForm.ts (gestion du formulaire)
└── usePhotoUpload.ts (gestion upload photos)
```

## Ressources

- **[Guide détaillé de décomposition](./references/decomposition-guide.md)** : Stratégies de split, tips avancés
- **[Checklist de refactorisation](./references/refactoring-checklist.md)** : Points de validation
- **[Template composant](./scripts/component-template.tsx)** : Structure de base
- **[Template hook](./scripts/hook-template.ts)** : Hook personnalisé
