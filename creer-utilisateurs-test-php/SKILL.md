---
name: creer-utilisateurs-test-php
description: "Automatiser la création d'un script PHP de génération d'utilisateurs tests pour un site utilisant la librairie delightPHP. Use when: créer des profils tests avec photos, gérer le throttling delightPHP, éviter les doublons, adapter les données au thème du site."
---

# Créer un Script PHP de Génération Utilisateurs Tests

Automatise la création d'un script PHP complet pour générer des profils tests via **delightPHP**. L'objectif est de fournir un script production-safe qui :
- Crée rapidement des profils avec photos
- Gère les limitations de rate limiting de DelightPHP
- Évite les doublons (email unique)
- Adapte les données et images au contexte du site

---

## 🚀 Processus Complet

### **Étape 1 : Définir le Besoin**

Clarifier avec vous :
- **Nombre d'utilisateurs** à créer
- **Répartition hommes/femmes** (ou autres critères)
- **Thème du site** (exemple : "plateforme de voyage" → biographies et intérêts adaptés)
- **Localisation** des photos source (dossier Windows)

**Sortie** :
```
✓ 15 utilisateurs test (6 hommes, 9 femmes)
✓ Dossier source : C:\projects\site-voyage\photos_source\
✓ Thème : plateforme de rencontres pour voyageurs
```

---

### **Étape 2 : Explorer la Base de Données**

Utiliser l'extension **DBcode** (ou explorer les fichiers de migration) pour identifier :
- **Table `users`** : colonnes présentes (biographie, sexe, location, âge...)
- **Table de photos** (`user_photos`?, `avatars`?) : comment sont associées les images
- **Champs JSON** : interests, travel_styles, wishlist_countries (format du stockage)
- **Contraintes** : unique sur email, username

**Vérification minimale** :
```sql
DESCRIBE users;
DESCRIBE user_photos;  -- ou le nom réel
SELECT * FROM users WHERE id = 1;  -- voir la structure
```

**Sortie** :
```
✓ Colonnes user trouvées : gender, bio, avatar_url, interests (JSON)
✓ Table photos : user_photos (id, user_id, url, is_main, status)
✓ Photos stockées à : /medias/photos_user/{userId}/
```

---

### **Étape 3 : Préparer la Banque de Photos Source**

Examiner le dossier source que vous indiquez.

**Structure attendue** :
```
photos_source/
  ├── HOMMES/
  │   ├── profil1/ (8-10 images)
  │   ├── profil2/
  │   └── profil3/
  └── FEMMES/
      ├── profil1/
      ├── profil2/
      └── profil3/
```

**Si le dossier est incomplet** :
1. Télécharger des images depuis sites libres de droits :
   - **Unsplash** (https://unsplash.com)
   - **Pixabay** (https://pixabay.com/)
   - **Pexels** (https://www.pexels.com/)
   
2. Copier les images dans le dossier source (structure par sexe)

**Sortie** :
```
✓ HOMMES/профil1/ : 9 images (jpg, png)
✓ FEMMES/profil1/ : 10 images
✓ Total : 60 images pour 6 profils × 2
```

---

### **Étape 4 : Adapter le Script Template**

Basé sur le modèle fourni, adapter :

**A] Constantes & Chemins** :
```php
// Mot de passe commun pour tous les tests
const MOT_DE_PASSE_TESTS = 'VotrePassword123!';

// Clé d'accès (pour protéger l'accès web)
const CLE_SECURITE = 'votre_cle_unique_2025';

// Domaine du serveur médias (local ou distant)
const DOMAINE_MEDIAS_LOCAL = 'http://medias.votresite.loc';

// Chemin du dossier medias public_html
$mediaPublicHtmlPath = dirname(__DIR__, 3) . DIRECTORY_SEPARATOR . 'medias.votresite.loc/public_html';
```

**B] Données des Utilisateurs** :
- Adapter **pseudo, email, full_name** à votre contexte  
- Adapter **profession, location, bio** au thème du site
- Adapter **JSON fields** (interests, travel_styles, wishlist_countries)  
- Adapter **photos_folder** aux chemins réels

**C] Colonnes BDD** :
- Remplacer les colonnes inconnues ou ajouter les colonnes manquantes
- Exemple : si votre BDD a `avatar` au lieu de `avatar_url`, adapter la requête UPDATE

**D] Gestion des Photos** :
- Vérifier la table de destination (`user_photos` vs autre)
- Vérifier le chemin de stockage réel (`/medias/photos_user/` vs autre)
- Vérifier le format de l'URL publique

**Sortie** : Script `creer_users_tests.php` prêt pour votre site.

---

### **Étape 5 : Gestion du Throttling DelightPHP**

DelightPHP met en place une table `users_throttling` pour limiter les créations rapides.

**Code inclus dans le script** :
```php
// Vider le throttling avant chaque tentative (script de dev UNIQUEMENT)
$pdo->exec('DELETE FROM users_throttling');  // ⚠️ À commenter en production

// Utiliser registerWithUniqueUsername() au lieu de register()
// → crée le compte WITHOUT email confirmation
$userId = $auth->registerWithUniqueUsername($email, $password, $username);
```

**Si le script s'arrête pour throttling** :
- Ajouter un délai entre les créations : `sleep(0.5);`
- Ou créer les utilisateurs par batch avec intervalle

---

### **Étape 6 : Éviter les Doublons**

Le script utilise **`UserAlreadyExistsException`** pour gérer les email/pseudo déjà existants :

```php
try {
    $userId = $auth->registerWithUniqueUsername($email, $password, $pseudo);
    // ...
} catch (\Delight\Auth\UserAlreadyExistsException $e) {
    // Si le compte existe → récupérer son ID et mettre à jour le profil
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = :email');
    $stmt->execute([':email' => $email]);
    $existingId = $stmt->fetchColumn();
    if ($existingId) {
        // Mettre à jour les profils existants
        $completerProfil((int)$existingId);
    }
}
```

**Avantage** : Relancer le script ne crée pas de doublon, met à jour les profils existants.

---

### **Étape 7 : Télécharger et Copier les Photos**

Le script fait 3 choses pour chaque utilisateur :

1. **Lister** les images du dossier source
   ```php
   $fichiersSources = array_values(array_filter(
       scandir($photosSourceDir),
       fn(string $f) => preg_match('/\.(jpg|jpeg|png|webp|gif)$/i', $f)
   ));
   ```

2. **Copier** chaque image dans le dossier utilisateur du serveur médias
   ```php
   copy($cheminSource, $cheminDest);  // From LOCAL to MEDIA SERVER
   ```

3. **Enregistrer** l'URL dans la BDD (`user_photos`) et marquer la première comme photo principale (`is_main = 1`)
   ```php
   INSERT INTO user_photos (user_id, url, is_main, status, uploaded_at, reviewed_at)
   VALUES ($userId, $photoUrl, $isMain, 'approved', NOW(), NOW());
   ```

**Important** : Les photos ne sont JAMAIS supprimées, vous pouvez relancer le script sans perdre les images précédentes.

---

### **Étape 8 : Exécuter le Script**

Deux modes d'exécution :

**Mode CLI (recommandé pour dev)** :
```bash
cd /chemin/vers/votre/projet
php scripts/creer_users_tests.php
```

**Mode Web (sécurisé par clé)** :
```
https://api.votresite.loc/scripts/creer_users_tests.php?cle=votre_cle_unique_2025
```

**Sortie attendue** :
```
========================================================
 Création des utilisateurs tests - Votre Site
========================================================

▶  [homme] Thomas Blanchard (thomas_blnch) ...
   ✔  Profil créé/mis à jour — ID: 42 | Photos: 9

▶  [femme] Sophie Martin (sophie_martin_v) ...
   ✔  Profil créé/mis à jour — ID: 43 | Photos: 10

...

========================================================
 RAPPORT FINAL
========================================================
 ✔  Succès   : 15 / 15
 ✘  Erreurs  : 0

MOT DE PASSE COMMUN : VotrePassword123!
========================================================
```

---

### **Étape 9 : Vérifier et Tester**

Une fois les utilisateurs créés :

1. **En BDD** (via DBcode) :
   ```sql
   SELECT id, username, email, full_name, gender, bio, avatar_url 
   FROM users WHERE id >= 100;
   
   SELECT user_id, url, is_main, status, COUNT(*) as nb_photos
   FROM user_photos 
   GROUP BY user_id;
   ```

2. **In App** : Se connecter avec un compte test et vérifier :
   - ✓ Profil rempli (bio, profession, intérêts)
   - ✓ Avatar affiché
   - ✓ Galerie de photos visible

3. **Sécurité** : Vérifier que le script a un statut **[DEVELOPMENT ONLY]** ou est supprimé après usage

---

## 📋 Checklist

- [ ] **Nombre d'utilisateurs** fixé et répartition claire
- [ ] **Thème du site** esquissé (biographies, données adaptées ?)
- [ ] **Dossier source photos** identifié et accessible
- [ ] **BDD explorée** (colonnes user, table photos, format JSON)
- [ ] **Script template** adapté (constantes, chemins, colonnes)
- [ ] **Délai throttling** configuré si needed
- [ ] **Protection accès** activée (clé de sécurité ou CLI)
- [ ] **Script testé** en dev
- [ ] **BDD vérifiée** (données présentes, photos copées)
- [ ] **Script supprimé/archivé** après utilisation

---

## 🔗 Ressources Complémentaires

- [Gestion des photos : Guide détaillé](./references/gestion-photos.md)
- [Adaptation données au site : Guide des biographies](./references/adaptation-donnees.md)
- [Dépannage : Erreurs courantes](./references/troubleshooting.md)
- [Template script complet](./scripts/template-creer-users.php)
- [Script PSScript : Télécharger photos Unsplash](./scripts/download-unsplash-photos.ps1)

---

## 🔑 Configuration Unsplash (Téléchargement Photos)

### **Obtenir votre clé API Unsplash**

1. Allez sur [https://unsplash.com/oauth/applications](https://unsplash.com/oauth/applications)
2. Cliquez sur "New Application"
3. Acceptez les termes et créez l'app
4. Une clé **"Access Key"** vous est attribuée (gratuit)

### **Configurer le fichier `.env`**

Créez un fichier `.env` **dans le dossier `scripts/`** :

```env
UNSPLASH_ACCESS_KEY=z_PNBQRdlDCL-xdUSADPOFMtCV3js0KyyaXGjWd_GMs
UNSPLASH_SECRET_KEY=sCfcG0jDcZ0NOTKPQNIirxrjgDDynN3QV51MSAIf480
```

### **Réglages supplémentaires du script PowerShell**

```powershell
# Le script charge automatiquement le fichier .env
$null = .\download-unsplash-photos.ps1 -CountMale 6 -CountFemale 6 -PhotosPerProfile 9

# Ou spécifier un chemin .env personnalisé
$null = .\download-unsplash-photos.ps1 -EnvFile "C:\config\.env" -CountMale 6
```

**Paramètres disponibles** :
- `-OutputDir` : Dossier destination (défaut : "photos_source")
- `-CountMale` : Nombre de profils hommes (défaut: 6)
- `-CountFemale` : Nombre de profils femmes (défaut: 6)
- `-PhotosPerProfile` : Photos par profil (défaut: 9)
- `-EnvFile` : Chemin du fichier .env (défaut: ".env")
- `-AccessKey` : Clé API (optionnel si .env présent)

---

## ⚡ Usage Rapide

Pour créer un script rapid pour votre site :

```
@copilot creer-utilisateurs-test-php

Nombre d'utilisateurs : 20
Répartition : 8 hommes, 12 femmes
Site : Plateforme de voyages d'aventure
Photos source : C:\projects\adventure\photos/
```

Le skill vous guidera etape par étape et générera le script adapté.

---

## ⚠️ Important

- **Script développement UNIQUEMENT** → déclarer `[DEV ONLY]` en haut et supprimer après utilisation  
- **Throttling DelightPHP** → Toujours vider avant d'exécuter (cf. Étape 5)
- **Biographies** → À adapter au thème ! Pas de génériques
- **Photos** → Respecter la licence libre de droit (Unsplash, Pixabay authorisent usage commercial)
- **Mot de passe** → Unique et complexe, à communiquer **via canal sécurisé** uniquement
