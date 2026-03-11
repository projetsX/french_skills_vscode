# Troubleshooting - PayPal PHP Implementation

## Problèmes courants détectés par le skill

### Credentials en code

**Issue**: API keys/secrets directement dans les fichiers PHP

```php
// ❌ MAUVAIS
$clientId = "ADr...";
$clientSecret = "ABC...";
```

**Solution**:
```php
// ✅ BON
$clientId = getenv('PAYPAL_CLIENT_ID') ?? $_ENV['PAYPAL_CLIENT_ID'];
$clientSecret = getenv('PAYPAL_CLIENT_SECRET') ?? $_ENV['PAYPAL_CLIENT_SECRET'];
```

**Action**: 
1. Créer fichier `.env` avec les vraies valeurs
2. Ajouter `.env` dans `.gitignore`
3. Redéployer avec nouvelles variables d'env
4. Révoquer anciennes keys en PayPal Dashboard

---

### HTTPS non forcé en production

**Issue**: Webhooks ou API calls sur HTTP

```php
// ❌ MAUVAIS
$url = "http://example.com/webhook";
```

**Solution**:
```php
// ✅ BON
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
if ($protocol === 'http' && in_production()) {
    throw new Exception("HTTPS required for PayPal in production");
}
```

**Action**:
1. Configurer certificat SSL/TLS
2. Rediriger HTTP → HTTPS
3. Mettre à jour URL webhooks en PayPal Dashboard
4. Tester accès HTTPS directement

---

### Validation de signature webhook manquante

**Issue**: Webhooks traités sans vérification PayPal

```php
// ❌ MAUVAIS
$webhook = json_decode(file_get_contents('php://input'));
// Process directement...
```

**Solution**:
```php
// ✅ BON
$signatureVerifiable = $client->verifyWebhookSignature(
    $_SERVER['HTTP_PAYPAL_TRANSMISSION_ID'],
    $_SERVER['HTTP_PAYPAL_TRANSMISSION_SIG'],
    $_SERVER['HTTP_PAYPAL_CERT_URL'],
    file_get_contents('php://input'),
    $WEBHOOK_ID
);

if (!$signatureVerifiable) {
    http_response_code(403);
    return;
}
```

**Action**:
1. Obtenir webhook ID du PayPal Dashboard
2. Implémenter `verifyWebhookSignature`
3. Tester avec PayPal webhook simulator
4. Logguer les vérifications échouées

---

### Gestion d'erreurs manquante

**Issue**: Exceptions PayPal non capturées

```php
// ❌ MAUVAIS
$response = $client->execute($request);
$orderId = $response->result->id;
```

**Solution**:
```php
// ✅ BON
try {
    $response = $client->execute($request);
    if ($response->statusCode < 200 || $response->statusCode >= 300) {
        $error = $response->result->details[0]->issue ?? 'Unknown error';
        throw new PayPalException($error, $response->statusCode);
    }
    $orderId = $response->result->id;
} catch (HttpClientException $ex) {
    logger()->error("PayPal API error: " . $ex->getMessage());
    throw new PaymentException("Payment processing failed");
}
```

**Action**:
1. Wrappen tous les appels PayPal avec try-catch
2. Logger les erreurs côté serveur
3. Retourner messages génériques au client
4. Monitorer les taux d'erreur

---

### Données sensibles dans les logs

**Issue**: Tokens/credentials loggés

```php
// ❌ MAUVAIS
logger()->info("API Response: " . json_encode($response->result));
```

**Solution**:
```php
// ✅ BON
$safeResponse = array_filter((array)$response->result, function($key) {
    return !in_array($key, ['access_token', 'secret', 'id_token']);
}, ARRAY_FILTER_USE_KEY);
logger()->info("Payment processed: " . json_encode($safeResponse));
```

**Action**:
1. Auditer tous les logs pour données sensibles
2. Redacter tokens/secrets avant logging
3. Utiliser des outils de log masquant les patterns sensibles
4. Supprimer les anciens logs contenant secrets

---

### Webhook déduplication manquante

**Issue**: Même webhook traité plusieurs fois

```php
// ❌ MAUVAIS
$eventId = $payload['id'];
// Process immédiatement sans vérifier si déjà traité
```

**Solution**:
```php
// ✅ BON
$eventId = $payload['id'];

// Check if already processed
$existing = db()->query("SELECT * FROM webhook_events WHERE event_id = ?", [$eventId]);
if ($existing) {
    http_response_code(200); // Return OK but don't reprocess
    return;
}

// Log new event
db()->insert('webhook_events', ['event_id' => $eventId, 'received_at' => now()]);

// Process webhook
// ...
```

**Action**:
1. Créer table `webhook_events` si inexistante
2. Vérifier déduplication avant traitement
3. Tester en envoyant le même webhook deux fois
4. Monitorer les doublons rejetés

---

### Version SDK obsolète

**Issue**: Security patches manqués

```bash
# Check version
composer show paypal/*

# Output: paypal/checkout-sdk-php 1.0.0
# But latest is 1.2.0!
```

**Solution**:
```bash
# Update
composer update paypal/checkout-sdk-php

# Verify
composer show paypal/checkout-sdk-php
```

**Action**:
1. Vérifier version actuelle
2. Comparer avec [GitHub releases](https://github.com/paypal/Checkout-PHP-SDK/releases)
3. Lire changelog pour breaking changes
4. Tester après update en sandbox
5. Déployer progressivement (canary deployment)

---

### Extensions PHP manquantes

**Issue**: Extensions requises non activées

```bash
# Check
php -m | grep -E "curl|json|openssl"

# If empty, extensions missing
```

**Solution** (linux):
```bash
apt-get install php-curl php-json php-openssl
systemctl restart php-fpm
```

**Solution** (Windows/XAMPP):
1. Edit `\xampp\php\php.ini`
2. Uncomment: `;extension=curl` → `extension=curl`
3. Redémarrer Apache/PHP

**Action**:
1. Vérifier extensions requises
2. Activer dans `php.ini`
3. Redémarrer web server
4. Tester: `php -r "echo 'Extensions OK';" | grep OK`

---

### Rate limiting PayPal

**Issue**: Erreur 429 "Too Many Requests"

```
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

**Solution**:
```php
// Implement exponential backoff
$maxRetries = 3;
$delay = 1; // seconds

for ($attempt = 0; $attempt < $maxRetries; $attempt++) {
    try {
        return $client->execute($request);
    } catch (HttpClientException $ex) {
        if ($ex->getStatusCode() === 429) {
            sleep($delay);
            $delay *= 2; // exponential backoff
        } else {
            throw $ex;
        }
    }
}
```

**Action**:
1. Implémenter exponential backoff pour retries
2. Monitorer les appels par minute
3. Cacher les réponses payPal quand possible
4. Batcher les opérations

---

### Pas de idempotency keys

**Issue**: Réexécution de requêtes crée duplicat

```php
// ❌ MAUVAIS
$response = $client->execute($request);
// Si erreur réseau et retry: requête envoyée 2x
```

**Solution**:
```php
// ✅ BON
$idempotencyKey = bin2hex(random_bytes(16));
$request->headers['Idempotency-Key'] = $idempotencyKey;

try {
    $response = $client->execute($request);
} catch (Exception $ex) {
    // Retry with same key - PayPal returns same response
    $response = $client->execute($request);
}
```

**Action**:
1. Ajouter `Idempotency-Key` à toutes mutations
2. Persister clés en base pour dupliquer identification
3. Reutiliser réponse pour duplicates
4. Tester en envoyant deux fois la même requête

---

## Diagnostic pas à pas

Si vous avez une erreur PayPal :

1. **Relevez le code erreur** (400, 401, 422, 429, 500...)
2. **Consultez le tableau ci-dessous**
3. **Appliquez la solution spécifique**

| Code | Cause | Solution |
|---|---|---|
| 400 | Bad Request | Valider format JSON, formats de date, champs requis |
| 401 | Unauthorized | Vérifier Client ID/Secret, credentials correctes pour sandbox/prod |
| 403 | Forbidden | Vérifier permissions, signature webhook invalidée |
| 404 | Not Found | Vérifier l'ID existe, bon endpoint PayPal |
| 422 | Unprocessable Entity | Loi métier PayPal violée (validation logique) |
| 429 | Too Many Requests | Rate limité - attendre, implémenter backoff |
| 500 | Server Error | Côté PayPal - retry avec backoff, notifier support |

---

## Réinvoqué le skill après fixes

Après avoir corrigé les issues, réinvoquez le skill :

```
/verify-paypal-php app/paypal/

Vérifier que les issues précédentes ont disparu ✓
```

---

**Dernière mise à jour**: 2026-03-11
