# Guide de Décomposition de Composants

## Stratégies de split

### 1. Par domaine fonctionnel (recommandé)
Chaque sous-composant gère un **domaine distinct**.

**Exemple: UserProfile** (gestion profil utilisateur)
```
├── UserProfilePhoto.tsx      (affichage + upload de photo)
├── UserProfileInfo.tsx       (informations de base)
├── UserProfileBio.tsx        (édition biographie)
├── UserProfileSocial.tsx     (liens réseaux sociaux)
└── UserProfilePreferences.tsx (paramètres utilisateur)
```

### 2. Par section visuelle
Chaque section du UI = un composant.

**Exemple: Dashboard**
```
├── DashboardHeader.tsx    (au-dessus)
├── DashboardSidebar.tsx   (nav gauche)
├── DashboardContent.tsx   (zone principale)
└── DashboardFooter.tsx    (bas de page)
```

### 3. Par type de contenu
Idéal pour listes complexes ou données imbriquées.

**Exemple: ProductCard**
```
├── ProductCardImage.tsx      (image produit)
├── ProductCardPrice.tsx      (prix + promo)
├── ProductCardReviews.tsx    (avis)
└── ProductCardActions.tsx    (boutons d'action)
```

## Critères de split

| Signal | Action |
|--------|--------|
| Bloc `if/else` complet | Créer un composant conditionnel |
| Boucle `.map()` | Extraire l'élément en sous-composant |
| 20+ lignes CSS locals | Isoler en composant avec ses styles |
| Logique métier complexe | Créer un hook personnalisé |
| État utilisé par 1-2 éléments | Laisser dans le parent si simple |
| État complexe (obj/array) | Hook personnalisé + contexte si besoin |

## Extraction de hooks

### Quand extraire ?

✅ **Oui** (hooks complexes/réutilisables):
- Validation de formulaire complexe
- Gestion données avec appels API
- Logique panier (cart) ou recherche
- État avec transformations
- Logique partagée entre 2+ composants

❌ **Non** (trop simple):
- `useState` avec boolean (ex: `isOpen`)
- Simple `useEffect` pour logs
- Quelques lignes de transformation

## Exemple détaillé : Refactoring UserProfile

### État initial (350+ lignes):
```typescript
export function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [photoFile, setPhotoFile] = useState(null);
  const [bio, setBio] = useState('');
  const [social, setSocial] = useState({});
  const [preferences, setPreferences] = useState({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Fetch user data...
  }, [userId]);

  const handlePhotoUpload = async (file) => { /* ... */ };
  const handleBioUpdate = async (newBio) => { /* ... */ };
  const handleSocialUpdate = async (social) => { /* ... */ };
  // ... 200+ lignes de logique mélangée
}
```

### Après refactoring:
```
user_profile/
├── UserProfile.tsx           (50 lignes, orchestration)
├── UserProfilePhoto.tsx      (80 lignes, photo + upload)
├── UserProfileInfo.tsx       (60 lignes, infos de base)
├── UserProfileBio.tsx        (70 lignes, édition bio)
├── UserProfileSocial.tsx     (65 lignes, réseaux)
├── useUserData.ts            (40 lignes, fetch + cache)
└── usePhotoUpload.ts         (50 lignes, upload + validation)
```

**Chaque fichier**: une responsabilité claire
**Chaque hook**: logique réutilisable testable
**Réduction complète**: -70% de complexité par composition

## Bonnes pratiques

1. **Props bien nommées**: ` <UserProfilePhoto onChange={handlePhotoChange} />`
2. **Pas d'effet de bord caché**: Les hooks retournent `[state, setState]`
3. **Testabilité**: Chaque sous-composant testable isolément
4. **Réutilisabilité**: Pas de dépendances externes si possible
5. **Performance**: Utiliser `React.memo` si beaucoup de re-renders

## Anti-patterns à éviter

❌ Créer un composant pour chaque ligne du code  
❌ Passer trop de props (limite: 5-6)  
❌ Nester trop profond (max 3-4 niveaux)  
❌ Oublier les commentaires d'en-tête  
❌ Mélanger imports de domaines différents
