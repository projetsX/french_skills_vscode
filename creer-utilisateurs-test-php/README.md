# 🚀 Skill : Créer Utilisateurs Tests PHP

Automatise la création d'un script PHP complet pour générer des profils tests avec photos, via la librairie **delightPHP**.

---

## 📌 À Quoi Ça Sert ?

Vous avez besoin de :
- Créer 10, 50, 100 profils utilisateurs tests rapidement
- Générer des profils réalistes avec photos
- Éviter les doublons et les limites de rate limiting
- Adapter les données au thème de votre site

**Ce skill vous guide étape par étape** → génère le script PHP adapté → vous pouvez exécuter directement.

---

## 🎯 Avant de Commencer

**Vous devez avoir** :

```
✓ Dossier source photos (C:/projects/site/photos_source/)
✓ Structure : HOMMES/profil_N/ + FEMMES/profil_N/
✓ Base de données accessible (avec DBcode, idéalement)
✓ DelightPHP installé via Composer
✓ Accès CLI ou WEB au serveur
```

---

## 📂 Structure du Skill

```
creer-utilisateurs-test-php/
├── SKILL.md                           ← Guide complet (9 étapes)
├── references/
│   ├── gestion-photos.md              ← Copie, stockage, téléchargement
│   ├── adaptation-donnees.md          ← Biographies, données pertinentes
│   ├── checklist-complet.md           ← À cocher pendant la création
│   └── troubleshooting.md             ← Erreurs courantes + solutions
├── scripts/
│   ├── template-creer-users.php       ← Script template complet
│   └── download-unsplash-photos.ps1   ← Télécharger photos Unsplash
└── README.md                           ← Ce fichier
```

---

## 🚀 Utilisation Rapide

### **Étape 1 : Lancer le Skill**

Dans VS Code Chat :

```
@copilot creer-utilisateurs-test-php

Nombre d'utilisateurs : 15
Répartition : 6 hommes, 9 femmes
Thème du site : plateforme de voyage
Photos source : C:\projects\site\photos_source\
```

### **Étape 2 : Suivre le Guide Principal**

Ouvrir `SKILL.md` → suivre les 9 étapes :

1. ✅ Définir le besoin
2. ✅ Explorer la BDD
3. ✅ Préparer les photos
4. ✅ Adapter le script template
5. ✅ Gérer le throttling DelightPHP
6. ✅ Éviter les doublons
7. ✅ Télécharger et copier les photos
8. ✅ Exécuter le script
9. ✅ Vérifier et tester

### **Étape 3 : Consulter les Références au Besoin**

- 📸 **Photos non prêtes ?** → 
  1. Consulter [gestion-photos.md](references/gestion-photos.md) pour les bonnes pratiques
  2. Ou utiliser [`download-unsplash-photos.ps1`](scripts/download-unsplash-photos.ps1) :
     ```powershell
     cd scripts
     .\\download-unsplash-photos.ps1  # Charge automatiquement .env
     ```
- 📝 **Données génériques ?** → Consulter [adaptation-donnees.md](references/adaptation-donnees.md)
- 🔧 **Erreur lors de l'exécution ?** → Consulter [troubleshooting.md](references/troubleshooting.md)
- ☑️ **Vérifier la progression ?** → Utiliser [checklist-complet.md](references/checklist-complet.md)

### **Étape 4 : Exécuter et Valider**

```bash
# CLI
php scripts/creer_users_tests.php

# Ou WEB
https://api.votresite.loc/scripts/creer_users_tests.php?cle=votre_cle_ici
```

Résultat : 15 profils test créés avec photos ✓

---

## 💡 Exemples de Résultats

### **Avant** (Sans ce skill)
```
❌ Créer les utilisateurs un à un manuellement (3h+)
❌ Copier les photos manuellement (1h+)
❌ Adapter les biographies (1h+)
❌ Gérer les doublons (risque)
❌ Gérer les photos principales (complexe)
Total : 5-6 heures
```

### **Après** (Avec ce skill)
```
✓ Lancer le script PHP (5 min)
✓ Profils créés avec photos (5 min machine)
✓ Avatars définis automatiquement (inclus)
✓ Pas de doublons (géré)
✓ Données thématiques (votre contexte)
Total : 30-45 minutes
```

---

## 📖 Guides Détaillés

### [SKILL.md](SKILL.md)
**Le cœur du workflow en 9 étapes logiques**
- Comment définir les besoins
- Explorer et adapter la BDD
- Gérer les photos (copie, stockage, URLs)
- Éviter les pièges (throttling, doublons)
- Exécuter et valider

### [gestion-photos.md](references/gestion-photos.md)
**Tout sur les photos : structure, copie, erreurs courantes, optimisation**
- Structure dossier attendue
- Processus de copie (source → médias server)
- Enregistrement BDD
- Problèmes courants + solutions
- Télécharger depuis Unsplash/Pixabay

### [adaptation-donnees.md](references/adaptation-donnees.md)
**Créer des données réalistes et pertinentes**
- Principes généraux
- Par type de site (voyages, B2B, e-commerce, réseau social...)
- Répartition démographique réaliste
- Template biographies
- Checklist de validation

### [checklist-complet.md](references/checklist-complet.md)
**Guide à cocher étape par étape**
- 6 phases de travail
- Points d'étapes pour chaque phase
- Questions de test
- Résumé final

### [troubleshooting.md](references/troubleshooting.md)
**Résoudre les 14 erreurs courantes**
1. UserAlreadyExistsException (email déjà utilisé)
2. DuplicateUsernameException (pseudo déjà pris)
3. InvalidEmailException (email invalide)
4. InvalidPasswordException (mot de passe invalide)
5. TooManyRequestsException (throttling)
6-9. Erreurs de photos
10-12. Erreurs BDD
13-14. Erreurs de sécurité

---

## 📦 Scripts Fournis

### 1️⃣ `template-creer-users.php`
**Script PHP complet prêt à adapter**

Inclut :
- Bootstrap delightPHP + Autoloader
- Gestion protection (clé sécurité)
- Création d'utilisateurs
- Gestion des doublons
- Copie photos + enregistrement BDD
- Rapport d'exécution

À adapter :
- Constantes (mot de passe, domaine médias, chemins)
- Colonnes BDD
- Données utilisateurs
- Clé sécurité

### 2️⃣ `download-unsplash-photos.ps1`
**PowerShell pour télécharger des photos libres de droit depuis Unsplash**

**Installation** :
1. Créer un fichier `.env` dans le dossier `scripts/`
2. Remplir votre clé API Unsplash
3. Exécuter le script

**Utilisation simple** (charge automatiquement `.env`):
```powershell
# Commande minimale - charge .env automatiquement
.\download-unsplash-photos.ps1

# Avec paramètres personnalisés
.\download-unsplash-photos.ps1 -CountMale 6 -CountFemale 9 -PhotosPerProfile 10
```

**Utilisation complète** :
```powershell
# Avec tous les paramètres
.\download-unsplash-photos.ps1 `
  -OutputDir "photos_source" `
  -EnvFile ".env" `
  -CountMale 6 `
  -CountFemale 9 `
  -PhotosPerProfile 10

# Ou passer la clé directement (sans .env)
.\download-unsplash-photos.ps1 `
  -AccessKey "votre_cle_unsplash_ici" `
  -CountMale 6 `
  -CountFemale 9
```

**Paramètres disponibles** :
| Paramètre | Type | Défaut | Description |
|----|----|----|----|
| `-OutputDir` | string | `"photos_source"` | Dossier de destination |
| `-EnvFile` | string | `".env"` | Chemin du fichier .env (recherche aussi dans le répertoire du script) |
| `-AccessKey` | string | (vide) | Clé API Unsplash (optionnel si .env présent) |
| `-CountMale` | int | `6` | Nombre de profils hommes à générer |
| `-CountFemale` | int | `6` | Nombre de profils femmes à générer |
| `-PhotosPerProfile` | int | `9` | Photos par profil |

**Résultat** :
- Structure créée : `photos_source/HOMMES/profil1-N + FEMMES/profil1-N`
- Total images : `(CountMale + CountFemale) × PhotosPerProfile`
- Prêt pour le script PHP `creer_users_tests.php`

---

## 🔑 Configuration du Fichier `.env` (pour Unsplash)

Avant de lancer le script PowerShell, créer un fichier `.env` dans `scripts/` :

### **Étape 1 : Obtenir une clé API Unsplash**
1. Allez sur [https://unsplash.com/oauth/applications](https://unsplash.com/oauth/applications)
2. Cliquez "New Application"
3. Acceptez les termes et remplissez le formulaire
4. Récupérez votre **"Access Key"** (gratuit)

### **Étape 2 : Créer le fichier `.env`**
Créer `scripts/.env` :
```env
UNSPLASH_ACCESS_KEY=votre_cle_api_ici
UNSPLASH_SECRET_KEY=votre_secret_key_ici
```

### **Étape 3 : Utiliser le template**
Un fichier `.env.example` est fourni - vous pouvez le dupliquer et remplir.

---

## ⚙️ Configuration Minimale

Avant de lancer le script, préparer :

```
Configuration Requise :
├─ Dossier photos source : C:\my_project\photos_source\
│  └─ HOMMES/ + FEMMES/ avec min. 5 images chacun
├─ Base de données accessible + DelightPHP installé
├─ Chemins corrects dans le script PHP :
│  ├─ Autoloader Composer
│  ├─ Connexion BDD
│  ├─ Dossier médias destination
│  └─ Domaine publique des médias
└─ Protection sécurité (clé d'accès ou CLI uniquement)
```

---

## 🔍 FAQ Rapide

**Q: Combien de temps ça prend ?**
A: 30-45 min si tout est prêt, 2-3h si photos à télécharger.

**Q: Les utilisateurs tests vont-ils créer des doublons ?**
A: Non, le script gère `UserAlreadyExistsException` et met simplement à jour les profils.

**Q: Je peux relancer le script plusieurs fois ?**
A: Oui, il va mettre à jour/ajouter sans problème.

**Q: Comment je supprime les utilisateurs tests après ?**
A: Une requête SQL simple : `DELETE FROM users WHERE email LIKE '%.test%';`

**Q: Les photos vont où physiquement ?**
A: `/medias/photos_user/{userId}/photo_xxx.jpg` sur le serveur médias.

**Q: Il faut une clé API Unsplash ?**
A: Mais oui si tu télécharges des photos. C'est gratuit et quick : https://unsplash.com/oauth/applications

---

## ⚠️ Important

- **Script de développement UNIQUEMENT** → À supprimer après usage en production
- **Throttling DelightPHP** → Le script gère la table `users_throttling`
- **Mot de passe commun** → À communiquer via canal sécurisé uniquement
- **Biographies** → À adapter au contexte du site (pas génériques)
- **Photos libres de droit** → Unsplash/Pixabay autorisent un usage commercial

---

## 🎓 Prochaines Étapes

Après avoir créé les utilisateurs tests :

1. **Tests fonctionnels** : Vérifier que le site fonctionne avec les données tests
2. **Tests de performance** : Charger le site avec tous les profils tests
3. **Tests d'intégration** : Vérifier matchs, messages, interactions
4. **Cleanup** : Supprimer les utilisateurs tests et archiver le script

---

## 📞 Support

Si vous avez une question :

1. **Consulter d'abord** : [troubleshooting.md](references/troubleshooting.md)
2. **Relire** : [SKILL.md](SKILL.md) étape concernée
3. **Vérifier** : [checklist-complet.md](references/checklist-complet.md) pour les points d'étapes

---

**Prêt ? Lancer le skill !** 🚀

```
@copilot creer-utilisateurs-test-php
```

Bonne création de profils tests ! 💪
