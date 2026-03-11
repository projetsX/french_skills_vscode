<?php
/**
 * Script de création d'utilisateurs tests
 * 
 * ⚠️  SCRIPT DE DÉVELOPPEMENT UNIQUEMENT - NE PAS EXÉCUTER EN PRODUCTION SANS MODIFICATIONS
 * 
 * Ce script crée des profils de test via DelightPHP avec :
 *   - Comptes créés et vérifiés
 *   - Biographies et infos profil remplies
 *   - Photos copiées depuis photos_source/
 *   - Gestion des doublons (email unique)
 *   - Gestion du throttling DelightPHP
 * 
 * PRÉREQUIS :
 *   - DelightPHP installé via Composer
 *   - Dossier photos_source/ avec structure HOMMES/FEMMES
 *   - Base de données accessible
 *   - Permissions d'accès en lecture/écriture
 * 
 * EXÉCUTION CLI :
 *   php scripts/creer_users_tests.php
 * 
 * EXÉCUTION WEB :
 *   https://api.votresite.loc/scripts/creer_users_tests.php?cle=votre_cle_ici
 * 
 * @version 1.0
 */

declare(strict_types=1);

// ============================================================================
// PROTECTION - Clé d'accès requise (navigateur) ou mode CLI
// ============================================================================
$isCli = (php_sapi_name() === 'cli');

if (!$isCli) {
    $cleAttendue = 'YOUR_SECURITY_KEY_HERE';  // À ADAPTER
    $cleFournie = $_GET['cle'] ?? '';

    if ($cleFournie !== $cleAttendue) {
        http_response_code(403);
        die('Accès refusé. Clé manquante ou invalide.');
    }
}

// ============================================================================
// CONSTANTES DE CONFIGURATION
// ============================================================================

/** Mot de passe commun à tous les comptes tests */
const MOT_DE_PASSE_TESTS = 'TestPassword123!';  // À ADAPTER

/** Domaine médias */
const DOMAINE_MEDIAS_LOCAL = 'http://medias.votresite.loc';  // À ADAPTER

// Chemin du public_html du serveur médias (ajuster selon votre structure)
$mediaPublicHtmlPath = dirname(__DIR__, 3) . DIRECTORY_SEPARATOR 
    . 'medias.votresite.loc' . DIRECTORY_SEPARATOR . 'public_html';  // À ADAPTER

/** Dossier source des photos */
$photosSourceBase = __DIR__ . DIRECTORY_SEPARATOR . 'photos_source';

// ============================================================================
// BOOTSTRAP
// ============================================================================

require_once dirname(__DIR__) . '/private/vendor/autoload.php';

use TemplatePhp\ConnexionBdd;
use TemplatePhp\ChargeurEnv;

try {
    // Charger configuration
    ChargeurEnv::charger(dirname(__DIR__));
    
    // Connexion BDD
    $pdo = ConnexionBdd::getInstance()->getConnexion();
    
    // DelightPHP Auth
    $auth = new \Delight\Auth\Auth($pdo);
    
} catch (Exception $e) {
    die("❌ Erreur initialisation : " . $e->getMessage());
}

// ============================================================================
// DONNÉES DES UTILISATEURS TESTS
// ============================================================================

$usersTests = [
    // EXEMPLE : modifier selon votre contexte
    [
        'genre' => 'homme',
        'pseudo' => 'pseudo1',
        'email' => 'user1@test.loc',
        'full_name' => 'User One',
        'age' => 30,
        'date_of_birth' => '1994-03-15',
        'location' => 'Paris, France',
        'bio' => 'Biographie personnalisée ici...',
        'profession' => 'Votre Métier',
        'height' => '180cm',
        'body_type' => 'Athlétique',
        'ethnicity' => 'Européen',
        'interests' => ['Intérêt1', 'Intérêt2'],
        'travel_styles' => ['Style1'],
        'visited_countries' => ['Pays1'],
        'wishlist_countries' => ['Pays2'],
        'photos_folder' => 'HOMMES/profil1',
    ],
    // Ajouter d'autres profils ici...
];

// ============================================================================
// EXÉCUTION
// ============================================================================

$resultats = [];
$erreurs = [];
$nbSuccess = 0;

echo "==========================================================\n";
echo " Création des utilisateurs tests\n";
echo "==========================================================\n\n";

foreach ($usersTests as $userData) {
    $pseudo = $userData['pseudo'];
    $email = $userData['email'];
    $fullName = $userData['full_name'];
    $genre = $userData['genre'];

    echo "▶  [{$genre}] {$fullName} ({$pseudo}) ...\n";

    // Closure pour mettre à jour le profil
    $completerProfil = function (int $userId) use ($pdo, $userData, $photosSourceBase, $mediaPublicHtmlPath): void {
        
        // ÉTAPE 1 : Marquer comme vérifié
        $stmtVerify = $pdo->prepare('UPDATE users SET verified = 1 WHERE id = :id');
        $stmtVerify->execute([':id' => $userId]);

        // ÉTAPE 2 : Mettre à jour le profil
        // ⚠️  À ADAPTER : remplacer les colonnes selon votre BDD
        $stmtProfil = $pdo->prepare('
            UPDATE users
            SET
                gender             = :gender,
                full_name          = :full_name,
                age                = :age,
                date_of_birth      = :date_of_birth,
                location           = :location,
                bio                = :bio,
                profession         = :profession,
                height             = :height,
                body_type          = :body_type,
                ethnicity          = :ethnicity,
                interests          = :interests,
                travel_styles      = :travel_styles,
                visited_countries  = :visited_countries,
                wishlist_countries = :wishlist_countries
            WHERE id = :id
        ');

        $stmtProfil->execute([
            ':id' => $userId,
            ':gender' => $userData['genre'],
            ':full_name' => $userData['full_name'],
            ':age' => $userData['age'],
            ':date_of_birth' => $userData['date_of_birth'],
            ':location' => $userData['location'],
            ':bio' => $userData['bio'],
            ':profession' => $userData['profession'],
            ':height' => $userData['height'],
            ':body_type' => $userData['body_type'],
            ':ethnicity' => $userData['ethnicity'],
            ':interests' => json_encode($userData['interests'], JSON_UNESCAPED_UNICODE),
            ':travel_styles' => json_encode($userData['travel_styles'], JSON_UNESCAPED_UNICODE),
            ':visited_countries' => json_encode($userData['visited_countries'], JSON_UNESCAPED_UNICODE),
            ':wishlist_countries' => json_encode($userData['wishlist_countries'], JSON_UNESCAPED_UNICODE),
        ]);

        // ÉTAPE 3 : Traitement des photos
        $photosSourceDir = $photosSourceBase . DIRECTORY_SEPARATOR . $userData['photos_folder'];

        if (!is_dir($photosSourceDir)) {
            echo "   ⚠  Dossier photos introuvable : {$photosSourceDir}\n";
            return;
        }

        // Créer dossier user sur serveur médias
        $destUserDir = $mediaPublicHtmlPath . DIRECTORY_SEPARATOR . 'photos_user' . DIRECTORY_SEPARATOR . $userId;
        if (!is_dir($destUserDir)) {
            mkdir($destUserDir, 0755, true);
        }

        // Lister les images
        $fichiersSources = array_values(array_filter(
            scandir($photosSourceDir),
            fn(string $f) => preg_match('/\.(jpg|jpeg|png|webp|gif)$/i', $f)
        ));

        $premiereFoto = true;
        $urlPhotoMain = null;
        $photosInserted = 0;

        foreach ($fichiersSources as $fichierOriginal) {
            $cheminSource = $photosSourceDir . DIRECTORY_SEPARATOR . $fichierOriginal;

            // Déterminer extension
            $extRaw = strtolower(pathinfo($fichierOriginal, PATHINFO_EXTENSION));
            $ext = ($extRaw === 'jpeg') ? 'jpg' : $extRaw;

            // Générer nom unique
            $nomFichierDest = uniqid('photo_', true) . '_' . time() . '.' . $ext;
            $cheminDest = $destUserDir . DIRECTORY_SEPARATOR . $nomFichierDest;

            // Copier fichier
            if (!copy($cheminSource, $cheminDest)) {
                echo "   ⚠  Impossible de copier : {$fichierOriginal}\n";
                continue;
            }

            // URL publique
            $photoUrl = DOMAINE_MEDIAS_LOCAL . '/photos_user/' . $userId . '/' . $nomFichierDest;
            $isMain = $premiereFoto ? 1 : 0;

            // Insérer en BDD
            // ⚠️  À ADAPTER : adapter le nom de la table et les colonnes si nécessaire
            $stmtPhoto = $pdo->prepare('
                INSERT INTO user_photos (user_id, url, is_main, status, uploaded_at, reviewed_at)
                VALUES (:user_id, :url, :is_main, \'approved\', NOW(), NOW())
            ');
            $stmtPhoto->execute([
                ':user_id' => $userId,
                ':url' => $photoUrl,
                ':is_main' => $isMain,
            ]);

            if ($premiereFoto) {
                $urlPhotoMain = $photoUrl;
                $premiereFoto = false;
            }

            $photosInserted++;
        }

        // Mettre à jour avatar
        if ($urlPhotoMain !== null) {
            $stmtAvatar = $pdo->prepare('UPDATE users SET avatar_url = :url WHERE id = :id');
            $stmtAvatar->execute([':url' => $urlPhotoMain, ':id' => $userId]);
        }

        echo "   ✔  Profil créé — ID: {$userId} | Photos: {$photosInserted}\n";
    };

    try {
        // Vider le throttling (développement uniquement !)
        $pdo->exec('DELETE FROM users_throttling');

        // Créer le compte
        $userId = $auth->registerWithUniqueUsername($email, MOT_DE_PASSE_TESTS, $pseudo);

        // Compléter le profil
        $completerProfil($userId);

        $nbSuccess++;
        $resultats[] = [
            'id' => $userId,
            'pseudo' => $pseudo,
            'email' => $email,
            'genre' => $genre,
            'statut' => 'OK',
        ];

    } catch (\Delight\Auth\UserAlreadyExistsException $e) {
        // Récupérer et mettre à jour compte existant
        $stmtExist = $pdo->prepare('SELECT id FROM users WHERE email = :email LIMIT 1');
        $stmtExist->execute([':email' => $email]);
        $existingId = $stmtExist->fetchColumn();
        
        if ($existingId) {
            echo "   ↩  Compte existant (ID: {$existingId}), mise à jour...\n";
            $completerProfil((int) $existingId);
            $nbSuccess++;
            $resultats[] = ['id' => (int) $existingId, 'pseudo' => $pseudo, 'email' => $email, 'genre' => $genre, 'statut' => 'MIS À JOUR'];
        }

    } catch (\Delight\Auth\DuplicateUsernameException $e) {
        $stmtExist = $pdo->prepare('SELECT id FROM users WHERE username = :username LIMIT 1');
        $stmtExist->execute([':username' => $pseudo]);
        $existingId = $stmtExist->fetchColumn();
        
        if ($existingId) {
            echo "   ↩  Pseudo existant (ID: {$existingId}), mise à jour...\n";
            $completerProfil((int) $existingId);
            $nbSuccess++;
            $resultats[] = ['id' => (int) $existingId, 'pseudo' => $pseudo, 'email' => $email, 'genre' => $genre, 'statut' => 'MIS À JOUR'];
        }

    } catch (\Delight\Auth\InvalidEmailException $e) {
        $msg = "Email invalide : {$email}";
        echo "   ✘  {$msg}\n";
        $erreurs[] = ['pseudo' => $pseudo, 'erreur' => $msg];

    } catch (\Delight\Auth\InvalidPasswordException $e) {
        $msg = "Mot de passe invalide";
        echo "   ✘  {$msg}\n";
        $erreurs[] = ['pseudo' => $pseudo, 'erreur' => $msg];

    } catch (\Delight\Auth\TooManyRequestsException $e) {
        $msg = "Trop de requêtes (throttling) — attente requise";
        echo "   ✘  {$msg}\n";
        $erreurs[] = ['pseudo' => $pseudo, 'erreur' => $msg];

    } catch (PDOException $e) {
        $msg = "Erreur BDD : " . $e->getMessage();
        echo "   ✘  {$msg}\n";
        $erreurs[] = ['pseudo' => $pseudo, 'erreur' => $msg];

    } catch (Throwable $e) {
        $msg = "Erreur inattendue : " . $e->getMessage();
        echo "   ✘  {$msg}\n";
        $erreurs[] = ['pseudo' => $pseudo, 'erreur' => $msg];
    }
}

// ============================================================================
// RAPPORT FINAL
// ============================================================================

echo "\n==========================================================\n";
echo " RAPPORT FINAL\n";
echo "==========================================================\n";
echo " ✔  Succès   : {$nbSuccess} / " . count($usersTests) . "\n";
echo " ✘  Erreurs  : " . count($erreurs) . "\n\n";

if (!empty($resultats)) {
    echo "Comptes créés :\n";
    foreach ($resultats as $r) {
        echo "  [{$r['genre']}] ID {$r['id']} — {$r['pseudo']} ({$r['email']}) [{$r['statut']}]\n";
    }
}

if (!empty($erreurs)) {
    echo "\nErreurs rencontrées :\n";
    foreach ($erreurs as $err) {
        echo "  - {$err['pseudo']} : {$err['erreur']}\n";
    }
}

echo "\n MOT DE PASSE COMMUN : " . MOT_DE_PASSE_TESTS . "\n";
echo "==========================================================\n";
echo " ⚠️  Ce script doit être supprimé après utilisation (dev).\n";
echo "==========================================================\n";
