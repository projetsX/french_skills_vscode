# Checklist Complète - Créer Utilisateurs Tests PHP

Suivez ces étapes pour générer votre script PHP complet.

---

## 📋 PHASE 1 : PRÉPARATION

### A. Définir les Besoins

- [ ] **Nombre d'utilisateurs** : ___ utilisateurs
- [ ] **Répartition genre** : ___ hommes, ___ femmes
- [ ] **Thème du site** : ___________________
- [ ] **Contexte d'utilisation** : (ex: plateforme voyage, social network, etc.)

### B. Localiser les Photos

- [ ] **Dossier source identifié** : `C:\path\to\photos_source\`
- [ ] **Structure hommes/femmes présente** :
  - [ ] `photos_source/HOMMES/profil1/` ... profil_N/
  - [ ] `photos_source/FEMMES/profil1/` ... profil_N/
- [ ] **Au moins 5-12 images par profil** ✓

### C. Explorer la BDD

- [ ] **Installer l'extension DBcode** (si pas déjà)
- [ ] **Lancer DBcode** et se connecter à la BDD
- [ ] **Vérifier la structure `users` table** :
  ```sql
  DESCRIBE users;
  ```
  - [ ] Colonne `gender` / `sex` / autre ?
  - [ ] Colonne `bio` / `biography` ?
  - [ ] Colonne `avatar_url` / `profile_picture` ?
  - [ ] Colonnes JSON (interests, travel_styles, etc.) ?

- [ ] **Vérifier la table photos** :
  ```sql
  SHOW TABLES LIKE '%photo%';
  ```
  - [ ] Table trouvée : `_________________`
  - [ ] Colonnes : `user_id`, `url`, `is_main`, `status`

- [ ] **Vérifier le chemin médias** :
  - [ ] URL publique : `http://medias.votresite.loc`
  - [ ] Dossier local : `C:/domains/medias/public_html`

---

## 📥 PHASE 2 : TÉLÉCHARGER LES PHOTOS (si besoin)

### Option A : Photos Source Incomplètes

Si le dossier source a moins de 5-12 images par profil :

- [ ] **Obtenir clé API Unsplash** :
  - [ ] Aller sur https://unsplash.com/oauth/applications
  - [ ] Créer une application
  - [ ] Copier l'**Access Key**

- [ ] **Lancer le script PowerShell** :
  ```powershell
  .\download-unsplash-photos.ps1 `
    -AccessKey "votre_cle_ici" `
    -CountMale 6 `
    -CountFemale 9 `
    -PhotosPerProfile 10
  ```

- [ ] **Vérifier les images téléchargées** :
  ```powershell
  Get-ChildItem photos_source -Recurse -Filter "*.jpg" | Measure-Object
  # Doit afficher : Count = (6+9)*10 = 150 images
  ```

### Option B : Photos Source OK

- [ ] Dossier source complet → passer à la phase 3

---

## 🔧 PHASE 3 : ADAPTER LE SCRIPT PHP

### A. Copier le Template

- [ ] Copier `scripts/template-creer-users.php` → `scripts/creer_users_tests.php`

### B. Adapter les Constantes

```php
// Mot de passe commun
const MOT_DE_PASSE_TESTS = 'VotrePassword123!';  // ✏️  À ADAPTER

// Domaine médias
const DOMAINE_MEDIAS_LOCAL = 'http://medias.votresite.loc';  // ✏️  À ADAPTER

// Variables chemins
$mediaPublicHtmlPath = ...  // ✏️  À ADAPTER
$photosSourceBase = ...     // ✏️  À ADAPTER
```

- [ ] Clé sécurité configurée (navigateur)
- [ ] Chemin Autoloader correct
- [ ] Namespace corrects (`TemplatePhp\ConnexionBdd`, etc.)

### C. Adapter les Colonnes BDD

Dans la requête `UPDATE users SET ...` :

- [ ] Remplacer `gender` par la colonne réelle (ou supprimer si absent)
- [ ] Remplacer `bio` par la colonne réelle
- [ ] Vérifier toutes les colonnes JSON (format, nom)
- [ ] Ajouter/supprimer les colonnes selon votre structure

### D. Compléter les Utilisateurs Tests

Array `$usersTests[]` :

- [ ] Adapter les **pseudos** (uniques)
- [ ] Adapter les **emails** (uniques, domaine `.test.loc`)
- [ ] Adapter les **biographies** au thème du site
- [ ] Adapter les **professions** (variées)
- [ ] Adapter les **intérêts/préférences** (cohérents)
- [ ] Adapter les **photos_folder** aux chemins réels

---

## 🧪 PHASE 4 : TEST EN DEVELOPMENT

### A. Préparation

- [ ] Cloner la BDD vers une BD de développement (optionnel)
- [ ] Vérifier que le script a accès en lecture aux photos
- [ ] Vérifier que le script a accès en écriture aux médias

### B. Exécution CLI

```bash
cd /chemin/vers/votre/projet
php scripts/creer_users_tests.php
```

- [ ] Script exécuté sans erreur fatale
- [ ] Utilisateurs affichés dans la sortie
- [ ] ✔ ou ❌ affiché pour chaque utilisateur

### C. Vérification BDD

Après exécution, tester en DBcode :

```sql
-- Comptes créés
SELECT COUNT(*) as total FROM users WHERE email LIKE '%.test%';

-- Profils remplis
SELECT id, full_name, bio FROM users WHERE email LIKE '%.test%' LIMIT 1;

-- Photos associées
SELECT user_id, COUNT(*) as nb_photos FROM user_photos 
WHERE user_id IN (SELECT id FROM users WHERE email LIKE '%.test%')
GROUP BY user_id;

-- Avatar défini
SELECT id, avatar_url FROM users WHERE email LIKE '%.test%' LIMIT 1;
```

- [ ] Nombre d'utilisateurs OK
- [ ] Biographies présentes
- [ ] Photos copiées (5-12 par utilisateur)
- [ ] Avatar URL correcte

---

## 🔐 PHASE 5 : SÉCURISER & FINALISER

### A. Protection d'Accès Web

- [ ] Clé de sécurité définie (long string aléatoire)
- [ ] Clé documentée (note secrète si souhaitée)

```php
// Dans le script
const CLE_SECURITE = 'madame_test_2024';

// URL d'accès web (avec clé)
https://api.votresite.loc/scripts/creer_users_tests.php?cle=madame_test_2024
```

### B. Protection du Fichier

- [ ] Placer en `/scripts/` (dossier accessible)
- [ ] Ou restreindre via `.htaccess` / nginx config
- [ ] Ou placer hors du web (CLI uniquement)

### C. Documentation

- [ ] Commenter le mot de passe commun
- [ ] Noter la date d'exécution
- [ ] Noter le nombre d'utilisateurs créés

```php
/**
 * Script exécuté le 2025-03-11
 * ✓ 15 utilisateurs test créés (6H + 9F)
 * ✓ 60 photos copiées
 * MOT DE PASSE : Voyage2024!
 * CLÉS TEST : user1@test.loc → user15@test.loc
 */
```

### D. Suppression (Important!)

Après utilisation :

- [ ] Supprimer le script du serveur
- [ ] Archive dans dossier "OLD" / "ARCHIVE" si besoin
- [ ] Valider que le script n'est plus accessible en web

---

## ✅ PHASE 6 : TESTS FINAUX

### Dans l'Application

- [ ] Se connecter avec un compte test
- [ ] Vérifier le profil rempli (bio, intérêts, etc.)
- [ ] Vérifier l'avatar affiché
- [ ] Vérifier la galerie de photos (5-12 images)
- [ ] Vérifier les données JSON correctes

### Sécurité

- [ ] Vérifier que le script n'est plus accessible via HTTP
- [ ] Vérifier les permissions des dossiers photos
- [ ] Vérifier que la table `users_throttling` a été vidée

### Performance

- [ ] Temps d'exécution : < 5 min pour 15 users
- [ ] Taille du dossier médias : ~ 3-5 MB pour 150 images

---

## 📊 RÉSUMÉ FINAL

Avant de clôturer :

- [ ] **Nombre final d'utilisateurs** : ___/15
- [ ] **Photos copiées** : ___/150
- [ ] **Erreurs rencontrées** : ___
- [ ] **Date d'exécution** : ___
- [ ] **Script supprimé** : OUI / NON
- [ ] **BDD validée** : OUI / NON

---

## 🆘 SOS

**Si quelque chose échoue** :

1. Consulter le guide [Troubleshooting](troubleshooting.md)
2. Checker les logs (cf. phase 4C)
3. Isoler le problème (création compte vs photos vs BDD)
4. Adapter et relancer

---

**Script prêt ? 🚀 Bonne exécution !**
