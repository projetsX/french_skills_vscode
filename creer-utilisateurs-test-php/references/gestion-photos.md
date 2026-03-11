# Gestion des Photos - Guide Détaillé

## Structure Attendue du Dossier Source

```
photos_source/
  ├── HOMMES/
  │   ├── profil1/      (5-10 images par profil)
  │   ├── profil2/
  │   ├── profil3/
  │   └── ...
  ├── FEMMES/
  │   ├── profil1/
  │   ├── profil2/
  │   └── ...
  └── COUPLE/           (optionnel)
      ├── profil1/
      └── ...
```

### Formats Acceptés

- **JPG/JPEG** (idéal, compression bonne)
- **PNG** (sans perte, recommandé pour portraits)
- **WebP** (optimal pour web mais rare en source)
- **GIF** (acceptable mais éviter animés pour profils)

---

## Processus de Copie et Stockage

### 1️⃣ **Copie Locale → Serveur Médias**

Le script :
1. Lit le dossier source : `/chemins/local/photos_source/HOMMES/profil1/`
2. Copie chaque image vers : `/medias_server/photos_user/{userId}/`
3. Génère un nom unique : `photo_5670ab1c234567.23456789_1710000000.jpg`

```php
// Exemple code dans le script
$cheminSource = 'photos_source/HOMMES/profil1/photo1.jpg';
$nomFichierDest = uniqid('photo_', true) . '_' . time() . '.jpg';
$cheminDest = '/medias/photos_user/42/photo_567.jpg';

copy($cheminSource, $cheminDest);  // Copie physique
$photoUrl = 'http://medias.site.loc/photos_user/42/photo_567.jpg';  // URL publique
```

---

### 2️⃣ **Enregistrement en BDD**

La table `user_photos` stocke les références :

```sql
INSERT INTO user_photos (user_id, url, is_main, status, uploaded_at, reviewed_at)
VALUES (42, 'http://medias.site.loc/photos_user/42/photo_567.jpg', 1, 'approved', NOW(), NOW());
```

**Colonnes clés** :
- `user_id` : ID de l'utilisateur
- `url` : URL publique complète de l'image
- `is_main` : `1` pour la photo de profil principale, `0` pour les autres
- `status` : `'approved'` pour les insérer immédiatement
- `uploaded_at`, `reviewed_at` : Timestamps

---

### 3️⃣ **Avatar Principal**

L'utilisateur `users` table reçoit aussi l'URL :

```php
// Première photo devient avatar
$stmtAvatar = $pdo->prepare('UPDATE users SET avatar_url = :url WHERE id = :id');
$stmtAvatar->execute([':url' => $urlPremiereFoto, ':id' => $userId]);
```

---

## Problèmes Courants & Solutions

### ❌ **Dossier source introuvable**

```php
if (!is_dir($photosSourceDir)) {
    echo "⚠  Dossier photos introuvable : {$photosSourceDir}\n";
    return;
}
```

**Solution** :
1. Vérifier le chemin exact avec l'explorateur Windows
2. Vérifier les permissions d'accès en lecture
3. Adapter le chemin dans le script

---

### ❌ **Erreur `DOMAINE_MEDIAS_LOCAL` invalide**

SI la table `user_photos` reçoit une URL locale comme `C:\medias\photos\...` au lieu d'une URL HTTP :

**Cause** : `DOMAINE_MEDIAS_LOCAL` incorrectement configuré.

**Solution** :
```php
// ❌ Mauvais
const DOMAINE_MEDIAS_LOCAL = 'C:\medias';

// ✓ Correct
const DOMAINE_MEDIAS_LOCAL = 'http://medias.votresite.loc';
// ou
const DOMAINE_MEDIAS_LOCAL = 'https://medias.votresite.com';
```

---

### ❌ **Images non copiées (permission denied)**

**Cause** : 
- Dossier destination n'existe pas
- Permissions insuffisantes sur `/medias/photos_user/`

**Solution** :
```php
// Créer le dossier s'il n'existe pas
if (!is_dir($destUserDir)) {
    mkdir($destUserDir, 0755, true);  // permissions rwx:rx:rx
}

// Vérifier les permissions Windows (si nécessaire : chown www-data:www-data)
```

---

### ❌ **Même image pour tous les utilisateurs**

**Cause** : Dossier source contient les mêmes fichiers pour tous (copie-pâte de profil1).

**Solution** : 
- Préparer des images différentes par profil
- Ou utiliser un seul dossier partagé et les répartir manuellement

---

### ❌ **Doublons d'image (même photo deux fois)**

Le script insère chaque image du dossier source. Si le dossier contient 10 images, l'utilisateur en recevra 10.

**Si vous relancez le script** : Les anciennes photos ne sont PAS supprimées, seules les nouvelles sont ajoutées → risque de doublons cumulatifs.

**Solutions** :
1. Vider manuellement la table avant de relancer :
   ```sql
   DELETE FROM user_photos WHERE user_id IN (42, 43, 44, ...);
   ```

2. Ou modifier le script pour vérifier l'existence :
   ```php
   $stmt = $pdo->prepare('SELECT 1 FROM user_photos WHERE user_id = :id LIMIT 1');
   $stmt->execute([':id' => $userId]);
   if (!$stmt->rowCount()) {
       // Insérer les photos
   }
   ```

---

## Télécharger des Photos (Unsplash/Pixabay)

Si le dossier source est incomplet, télécharger depuis des sites libres de droit.

### **Unsplash (API)**

```powershell
# PowerShell script : télécharger 10 photos de portrait homme
$outputDir = "photos_source\HOMMES\profil1"
mkdir $outputDir -Force

for ($i = 1; $i -le 10; $i++) {
    $url = "https://api.unsplash.com/photos/random?query=man+portrait&client_id=YOUR_ACCESS_KEY"
    $response = Invoke-RestMethod -Uri $url
    $imageUrl = $response.urls.regular
    
    $filename = "photo_$i.jpg"
    Invoke-WebRequest -Uri $imageUrl -OutFile "$outputDir\$filename"
    Write-Host "✓ Téléchargé : $filename"
}
```

### **Pixabay (URL directe)**

Chercher manuellement et télécharger les images PNG/JPG :
1. Aller sur https://pixabay.com
2. Rechercher : "man portrait" ou "woman portrait"
3. Télécharger en qualité HD/Full HD
4. Placer dans `/photos_source/HOMMES/profil1/` ou FEMMES

---

## Optimisation des Images

Les images de profil doivent être :
- **Dimensions** : 300x400px minimum (portrait)
- **Taille** : < 500KB par image (JPG 80% quality)
- **Nombre** : 5-12 par profil (galerie complète)

**Batch compress avec PowerShell** :

```powershell
# Compresser toutes les JPG du dossier source
$sourceDir = "photos_source"
Get-ChildItem -Path $sourceDir -Recurse -Filter "*.jpg" | ForEach-Object {
    $imageMagick = "magick.exe"  # Si ImageMagick est installé
    & $imageMagick $_.FullName -quality 80 -resize "300x400>" $_.FullName
    Write-Host "✓ Compressé : $($_.Name)"
}
```

---

## Checklist Photos

- [ ] Dossier `/HOMMES/`, `/FEMMES/` créés et remplis
- [ ] Chaque profil contient 5-12 images
- [ ] Formats JPG/PNG uniquement
- [ ] Pas d'espaces dans les noms (photo1.jpg, pas "photo 1.jpg")
- [ ] Chemin source correct dans le script
- [ ] Permissions d'accès lecteur vérifiées
- [ ] Dossier médias destination accessible en écriture
- [ ] URL publique correctement configurée
