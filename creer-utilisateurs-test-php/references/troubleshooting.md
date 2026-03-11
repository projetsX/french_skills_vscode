# Dépannage - Erreurs Courantes

## ⚠️ Erreurs de Création de Compte

### **1. UserAlreadyExistsException - Email déjà utilisé**

```
✘ Email déjà utilisé et introuvable en BDD : thomas.blanchard.test@madamevoyage.loc
```

**Cause** :
- Email existe dans un autre système ou table
- Compte suspendu/archivé non visible en BDD
- Contrainte unique sur une autre colonne

**Solution** :
```sql
-- Vérifier si email existe
SELECT id, email, deleted_at FROM users WHERE email = 'thomas.blanchard.test@madamevoyage.loc';

-- Si compte archivé : le restaurer
UPDATE users SET deleted_at = NULL WHERE email = 'thomas.blanchard.test@madamevoyage.loc';

-- Ou changer l'email dans le script et relancer
```

---

### **2. DuplicateUsernameException - Pseudo déjà pris**

```
✘ Pseudo déjà utilisé et introuvable en BDD : thomas_blnch
```

**Cause** :
- Pseudo supprimé d'un compte désactivé
- Pseudo réservé/système
- BDD incohérente

**Solution** :
```sql
-- Chercher le compte associé
SELECT id, username, verified FROM users WHERE username = 'thomas_blnch';

-- Ou changer simplement le pseudo dans le script
```

---

### **3. InvalidEmailException - Email invalide**

```
✘ Email invalide : thomas.blanchard.test@madamevoyage.loc
```

**Cause** :
- Email vide ou mal formaté
- Caractères spéciaux non échappés en PHP
- Validation DelightPHP stricte

**Solution** :
```php
// ❌ Mauvais (quote manquantes)
'email' => thomas@site.loc,

// ✓ Correct
'email' => 'thomas@site.loc',

// ✓ Si caractères spéciaux
'email' => 'thomas+test@site.loc',  // + fonctionne
'email' => 'thomas_test@site.co.uk',  // _ et .uk fonctionnent
```

---

### **4. InvalidPasswordException - Mot de passe invalide**

```
✘ Mot de passe invalide pour : thomas_blnch
```

**Cause** :
- Mot de passe trop court (< 8 caractères)
- Pas d'uppercase/lowercase/chiffre/spécial
- Valeur vide ou null

**Solution** :
```php
// ❌ Mauvais
const MOT_DE_PASSE_TESTS = '123';      // Trop court
const MOT_DE_PASSE_TESTS = 'password'; // Pas d'uppercase/chiffre/spécial

// ✓ Correct → minimum 8 chars + uppercase + lowercase + chiffre + spécial
const MOT_DE_PASSE_TESTS = 'Voyage2024!';
const MOT_DE_PASSE_TESTS = 'TestUser@123';
```

---

### **5. TooManyRequestsException - Throttling DelightPHP**

```
✘ Trop de requêtes — attente requise pour : thomas_blnch
```

**Cause** :
- Table `users_throttling` a limité les requêtes
- Création trop rapide (plus de N comptes par minute)

**Solution** :

**A) Vider le throttling (développement)**
```php
// AVANT la boucle foreach
$pdo->exec('DELETE FROM users_throttling');
```

**B) Ajouter un délai entre les créations**
```php
foreach ($usersTests as $userData) {
    // ... création
    sleep(1);  // Attendre 1 seconde entre chaque compte
}
```

**C) Créer par batch**
```php
for ($batch = 0; $batch < count($usersTests); $batch += 3) {
    // Créer groupe de 3
    foreach (array_slice($usersTests, $batch, 3) as $userData) {
        // ... création
    }
    sleep(5);  // Attendre 5 sec entre les batches
}
```

---

## 🔥 Erreurs de Photos

### **6. Dossier source introuvable**

```
⚠  Dossier photos introuvable : C:\projects\site\photos_source\HOMMES\profil1
```

**Cause** :
- Chemin incorrect dans le script
- Dossier n'existe pas
- Permission de lecture refusée

**Solution** :
```php
// Vérifier le chemin réel
echo "Chemin testé : " . $photosSourceDir . "\n";
var_dump(is_dir($photosSourceDir));  // true ou false

// Corriger le script
$photosSourceBase = __DIR__ . DIRECTORY_SEPARATOR . 'photos_source';
// ou chemin complet
$photosSourceBase = 'C:\Users\mathi\projects\site\photos_source';
```

---

### **7. Permission denied - Impossible de copier les photos**

```
⚠  Impossible de copier : photo1.jpg
```

**Cause** :
- Dossier destination n'existe pas
- Permissions insuffisantes
- Chemin destination incorrect

**Solution** :
```php
// Créer le dossier avec permissions
if (!is_dir($destUserDir)) {
    if (!mkdir($destUserDir, 0755, true)) {
        echo "Erreur : Impossible de créer $destUserDir\n";
        var_dump(error_get_last());
    }
}

// Vérifier les permissions (Windows/Linux)
if (!is_writable($destUserDir)) {
    echo "⚠  Permissions insuffisantes : $destUserDir\n";
}

// Vérifier que copy() fonctionne
$test = copy($cheminSource, $cheminDest);
if (!$test) {
    echo "Erreur copy() : vérifier les chemins\n";
}
```

---

### **8. Photos non copiées, mais aucune erreur**

**Cause** :
- copy() retourne `false` silencieusement
- Dossier source vide

**Solution** :
```php
// Ajouter de la log
$fichiersSources = array_values(array_filter(
    scandir($photosSourceDir),
    fn(string $f) => preg_match('/\.(jpg|jpeg|png|webp|gif)$/i', $f)
));

echo "Photos trouvées : " . count($fichiersSources) . "\n";
foreach ($fichiersSources as $f) {
    echo "  - $f\n";
}

if (count($fichiersSources) === 0) {
    echo "❌ Aucune photo trouvée ! Vérifier le dossier.\n";
}
```

---

### **9. Même URL pour toutes les photos**

```
user_photos : url toujours ...photo_567.jpg
```

**Cause** :
- Boucle ne traite pas toutes les images
- Variable `$nomFichierDest` réutilisée sans changement

**Solution** :
```php
// Vérifier que uniqid() génère chaque fois un ID différent
$nomFichierDest = uniqid('photo_', true) . '_' . time() . '.' . $ext;
// Chaque appel doit créer un nom unique ✓

// Sinon, forcer un compteur
foreach ($fichiersSources as $i => $fichier) {
    $nomFichierDest = "photo_{$userId}_{$i}." . $ext;
}
```

---

## 📊 Erreurs BDD

### **10. Table user_photos n'existe pas**

```
SQLSTATE[42S02]: Table 'base.user_photos' doesn't exist
```

**Cause** :
- Table a un autre nom (`user_images`, `photos`, etc.)
- Table n'a pas été migrée
- BDD en "mode dev" sans structure complète

**Solution** :
```sql
-- Lister les tables disponibles
SHOW TABLES;

-- Trouver la table photos
SHOW TABLES LIKE '%photo%';
SHOW TABLES LIKE '%avatar%';
SHOW TABLES LIKE '%image%';

-- Adapter le script au nom réel
// Avant: INSERT INTO user_photos
// Après: INSERT INTO user_images
```

---

### **11. Colonnes introuvables**

```
SQLSTATE[42S22]: Column 'interests' doesn't exist
```

**Cause** :
- Colonne a un autre nom (`hobbies`, `preferences`, etc.)
- Colonne n'existe pas
- Table différente

**Solution** :
```sql
-- Lister les colonnes de users
DESCRIBE users;

-- Si la colonne est absente, la créer (dev)
ALTER TABLE users ADD COLUMN interests JSON;
ALTER TABLE users ADD COLUMN travel_styles JSON;

-- Ou adapter le script pour ignorer les colonnes manquantes
```

---

### **12. Erreur de format JSON**

```
Incorrect JSON in argument to function json
```

**Cause** :
- JSON malformé (guillemets mal échappés)
- Encodage UTF-8 manquant

**Solution** :
```php
// ❌ Mauvais
'interests' => "['Randonnée', 'Plage']",  // PHP array, pas JSON

// ✓ Correct → Encoder en JSON d'abord
'interests' => json_encode(['Randonnée', 'Plage'], JSON_UNESCAPED_UNICODE),

// Vérifier le JSON généré
$json = json_encode(['Randonnée', 'Plage'], JSON_UNESCAPED_UNICODE);
var_dump($json);
// string(34) "["Randonnée","Plage"]"
```

---

## 🔐 Erreurs de Sécurité & Accès

### **13. Accès refusé (403) - Clé de sécurité invalide**

```
HTTP 403 - Accès refusé. Clé manquante ou invalide.
```

**Cause** :
- URL sans paramètre `?cle=`
- Clé incorrecte

**Solution** :
```php
// Dans le script
const CLE_SECURITE = 'madame_test_2024';

// Dans l'URL
https://api.site.loc/scripts/creer_users_tests.php?cle=madame_test_2024  // ✓
https://api.site.loc/scripts/creer_users_tests.php?cle=wrong            // ✗
```

---

### **14. Fichier script non trouvé**

```
404 - /scripts/creer_users_tests.php not found
```

**Cause** :
- Chemin URL incorrect
- Script placé au mauvais endroit

**Solution** :
```
✓ Bon : https://api.site.loc/scripts/creer_users_tests.php
✗ Mauvais : https://api.site.loc/creer_users_tests.php
✗ Mauvais : https://site.loc/scripts/creer_users_tests.php  (domain différent)

À placer dans : /var/www/api.site.loc/public_html/scripts/creer_users_tests.php
```

---

## ✅ Vérification Complète

Après exécution du script, valider :

```sql
-- 1. Comptes créés
SELECT COUNT(*) FROM users WHERE email LIKE '%.test@%';

-- 2. Profils remplis
SELECT COUNT(*) FROM users WHERE bio IS NOT NULL AND bio != '';

-- 3. Photos associées
SELECT user_id, COUNT(*) as nb_photos FROM user_photos GROUP BY user_id;

-- 4. Avatars définis
SELECT COUNT(*) FROM users WHERE avatar_url IS NOT NULL;

-- 5. Données JSON valides
SELECT id, interests FROM users WHERE email LIKE '%.test@%' LIMIT 1;
-- Doit afficher : ["Randonnée","Photographie"]
```

---

## 🆘 Aide Urgente

**Si le script plante complètement** :

1. **Vérifier l'Autoloader** :
```php
require_once dirname(__DIR__) . '/private/vendor/autoload.php';
// Fichier autoload.php existe-t-il ?
// Composer a-t-il été installé ?
```

2. **Vérifier la connexion BDD** :
```php
try {
    $pdo = ConnexionBdd::getInstance()->getConnexion();
    $pdo->query("SELECT 1");
    echo "✓ BDD OK\n";
} catch (PDOException $e) {
    echo "❌ BDD Error : " . $e->getMessage();
}
```

3. **Vérifier DelightPHP** :
```php
try {
    $auth = new \Delight\Auth\Auth($pdo);
    echo "✓ DelightPHP OK\n";
} catch (Exception $e) {
    echo "❌ DelightPHP Error : " . $e->getMessage();
}
```

4. **Activer les erreurs** (dev) :
```php
ini_set('display_errors', 1);
ini_set('log_errors', 1);
error_reporting(E_ALL);
```

---

Toujours ajouter des `echo` et `var_dump()` pour tracer les étapes et identifier où le script échoue! 🔍
