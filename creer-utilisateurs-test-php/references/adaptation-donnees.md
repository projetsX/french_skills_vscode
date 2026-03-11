# Adaptation des Données au Site - Guide

## Principes Généraux

Les données des utilisateurs tests doivent **refléter le contexte et le thème du site** pour être réalistes et utiles aux tests.

### ❌ Mauvais Exemple
```php
[
    'pseudo' => 'user_test_1',
    'bio' => 'Lorem ipsum dolor sit amet',
    'profession' => 'N/A',
    'interests' => [],
]
```

### ✓ Bon Exemple
```php
[
    'pseudo' => 'thomas_blnch',
    'bio' => 'Ingénieur passionné de voyages, je parcours le monde avec ma valise et mon appareil photo.',
    'profession' => 'Ingénieur',
    'interests' => ['Randonnée', 'Photographie', 'Gastronomie', 'Architecture'],
]
```

---

## Par Type de Site

### 🌍 **Plateforme de Voyages / Rencontres Voyageurs**

**Données essentielles** :
- `bio` : Récit court personnel (3-4 phrases)
- `location` : Ville de résidence actuelle
- `interests` : Activités de voyages (Randonnée, Plage, Culturel, Luxe, Eco-tourisme...)
- `visited_countries` : Pays déjà visités
- `wishlist_countries` : Destinations rêvées
- `travel_styles` : Modes de voyage (Backpacker, Luxe, Aventure, Road trip...)
- `profession` : Métier (important : influe sur disponibilité/budget)
- `age`, `gender` : Critères de matching

**Exemple de `bio` adapté** :
```
"Architecte passionnée par les villes historiques, j'aime combiner 
architecture et gastronomie locale. Après un Erasmus en Espagne, 
j'ai attrapé le virus des voyages. Cherche compagnon curieux pour 
explorer ensemble les petits villages oubliés."
```

---

### 💼 **Site B2B / SaaS Professionnel**

**Données essentielles** :
- `company_role` : Rôle dans l'entreprise (Admin, Manager, User...)
- `department` : Département (Finance, IT, Marketing...)
- `seniority_level` : Junior, Senior, Lead, Manager
- `industry` : Secteur (Tech, Finance, Santé...)
- `company_size` : Petite, PME, Grande

**Exemple** :
```php
[
    'username' => 'marie_dupont',
    'email' => 'marie.dupont@acme.com',
    'company_role' => 'Product Manager',
    'department' => 'Produit',
    'seniority_level' => 'Senior',
]
```

---

### 🛍️ **E-commerce / Marketplace**

**Données essentielles** :
- `customer_type` : Individu, Pro-seller, Corporate
- `purchase_history` : Catégories fréquentes (Electronics, Fashion, Books...)
- `avg_order_value` : Montant moyen panier
- `loyalty_status` : Bronze, Silver, Gold
- `preferences` : Livraison standard/express, délais...

---

### 🎨 **Réseau Social / Création de Contenu**

**Données essentielles** :
- `bio` : Ligne de présentation personnelle (80-160 chars)
- `profile_type` : Individual, Brand, Creator, Business
- `follower_count` : Crédibilité initiale (peut être 0)
- `content_categories` : Types de contenu (Photos, Art, Tech, Beauty...)
- `verified` : Badge de vérification

---

## Répartition Démographique Réaliste

Pour 15 utilisateurs test (exemple site voyages) :

### **Genre**
```
6 hommes (40%)
9 femmes (60%)
```

### **Âge** (répartition naturelle)
```
18-25 ans   : 2 personnes (13%)
26-35 ans   : 6 personnes (40%)  ← majorité active
36-50 ans   : 5 personnes (33%)
50+ ans     : 2 personnes (13%)
```

### **Localisation** (France exemple)
```
Paris/IDF        : 3 personnes
Province (grand)  : 7 personnes (Lyon, Marseille, Toulouse, Bordeaux, Nantes...)
Petite ville      : 5 personnes
```

### **Professions** (variété)
```
Libéraux/Indépendants : 4 (architecte, journaliste, photographe, entrepreneur)
Employés              : 6 (ingénieur, médecin, styliste, designer, prof, avocat)
Étudiants/Jeunes      : 2
Retraités/Inactifs    : 3
```

---

## Étapes de Création des Biographies

### **1. Esquisse par profil**

Pour chaque utilisateur, noter :
```
Pseudo : thomas_blnch
Nom : Thomas Blanchard
Âge : 34
Profession : Ingénieur
Ville : Paris
Hobby principal : Photographie + Voyages
```

### **2. Biographie personnalisée (200-300 mots)**

Structure suggérée :
1. **Accroche** : qui je suis, ce que je fais
2. **Passion** : raison de voyager / intérêts
3. **Expérience** : 1-2 pays/événements marquants
4. **Recherche** : qu'est-ce que je cherche chez un partenaire / sur la plateforme

**Template** :
```
[Métier - personnalité brève], j'ai [petit exploit/expérience]. 
Ma passion : [hobby]. Lorsque je voyage, j'aime [détails: randonnée, gastronomie...].

Jusqu'à présent, j'ai découvert [2-3 destinations] et j'ai rêve de [wishlist].
Je suis à la recherche de [type de partenariat] avec quelqu'un qui...
```

### **3. Valider thème du site**

- ✓ La bio reflète-t-elle le ton du site ?
- ✓ Les intérêts sont-ils cohérents avec le genre de personne ?
- ✓ Les destinations visitées/rêvées font-elles sens ?

---

## Exemple Complet pour Site Voyages

```php
[
    'pseudo' => 'thomas_blnch',
    'email' => 'thomas.blanchard.test@madamevoyage.loc',
    'full_name' => 'Thomas Blanchard',
    'gender' => 'homme',
    'age' => 34,
    'date_of_birth' => '1991-04-12',
    'location' => 'Paris, France',
    
    'bio' => 'Ingénieur passionné de voyages, je parcours le monde avec ma valise 
             et mon appareil photo. Mon objectif : découvrir une nouvelle culture 
             chaque année. J\'adore les marchés locaux, les randonnées en montagne 
             et partager un repas avec des inconnus. Je recherche une partenaire de 
             voyage curieuse et aventurière pour explorer ensemble des destinations 
             hors des sentiers battus.',
    
    'profession' => 'Ingénieur',
    'height' => '180cm',
    'body_type' => 'Athlétique',
    'ethnicity' => 'Européen',
    
    'interests' => [
        'Randonnée',
        'Photographie',
        'Gastronomie',
        'Architecture'
    ],
    'travel_styles' => [
        'Aventure',
        'Culturel',
        'Road trip'
    ],
    'visited_countries' => [
        'Japon',
        'Pérou',
        'Maroc',
        'Islande',
        'Thaïlande'
    ],
    'wishlist_countries' => [
        'Nouvelle-Zélande',
        'Éthiopie',
        'Géorgie',
        'Colombie'
    ],
    
    'photos_folder' => 'HOMMES/profil1',
]
```

---

## Checklist d'Adaptation

**Avant de valider les données** :

- [ ] **Thème du site** identifié et respecté
- [ ] **Biographies** personnalisées, min 100 chars, max 300
- [ ] **Illogicités corrigées** : pas de voyageur étouffé au bureau, pas de freelancer sans autonomie...
- [ ] **Données JSON** (interests, travel_styles...) cohérentes
- [ ] **Noms/prenoms** réalistes et variés (pas tous "John Smith")
- [ ] **Répartition genre/âge/ville** proche de la réalité
- [ ] **Professions** variées et crédibles
- [ ] **Dates de naissance** cohérentes avec l'âge déclaré
- [ ] **Photos** correspondent au genre/type de personne

---

## Pièges Courants

### ❌ **Bio générique**
```
"J'aime voyager et rencontrer des gens."
```
→ Trop vague, pas utile aux tests.

### ✓ **Bio spécifique**
```
"Journaliste reporter qui couvre des événements mondiaux. J'ai appris que 
la meilleure story, c'est celle avec les gens. Cherche compagne intrépide 
pour explorer en slow travel."
```

---

### ❌ **Données incohérentes**
```
age: 25
date_of_birth: "1970-01-01"     ← ❌ Incohérent ! (55 ans)
visited_countries: ['nowhere']  ← ❌ Illogique
```

### ✓ **Données cohérentes**
```
age: 25
date_of_birth: "1999-03-14"
visited_countries: ['Espagne', 'Italie', 'Portugal']
```

---

## Intégration dans le Script

Adapter dans `$usersTests[]` :

```php
$usersTests = [
    [
        'genre' => 'homme',
        'pseudo' => 'votre_pseudo_1',
        'email' => 'votre_email@votresite.loc',
        'full_name' => 'Votre Nom Complet',
        'age' => 30,
        'date_of_birth' => '1994-03-15',  // Cohérent avec age
        'location' => 'Paris, France',
        
        'bio' => 'Votre bio adaptée au site...',
        
        'profession' => 'Votre métier',
        'interests' => ['Votre', 'Intérêt', 'Ici'],
        'travel_styles' => ['Style', 'Voyage'],
        'visited_countries' => ['Pays', 'Visité'],
        'wishlist_countries' => ['Pays', 'Rêve'],
        
        'photos_folder' => 'HOMMES/profil1',
    ],
    // ... autres profils
];
```

Et voilà ! Vos données tests sont prêtes pour refléter la réalité du site.
