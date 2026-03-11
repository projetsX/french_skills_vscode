# PHP Compatibility & PayPal SDK Requirements

## PHP Version Support

### PayPal PHP Server SDK Requirements
- **Minimum PHP**: 7.4 or higher (check official SDK documentation for latest)
- **Recommended PHP**: 8.0 or higher for best performance and security fixes
- **Production**: Use actively maintained PHP versions (avoid unsupported versions)

### Version Compatibility Table

| PHP Version | Status | Notes |
|---|---|---|
| 7.4 | Supported | End of Life: 28 Nov 2022; use if legacy support required |
| 8.0 | Supported | End of Life: 26 Nov 2023; acceptable for production |
| 8.1 | Security fixes only | Ends: 25 Nov 2024; upgrade recommended |
| 8.2 | Active support | Recommended for new projects |
| 8.3+ | Latest | Preferred version |

## Required PHP Extensions

Verify these extensions are enabled in `php.ini`:

- [ ] **curl** — Required for HTTP requests to PayPal API
  ```bash
  php -m | grep curl
  ```
- [ ] **json** — Required for JSON encoding/decoding
- [ ] **openssl** — Required for HTTPS and secure connections
- [ ] **mb_string** — Required for multi-byte string handling
- [ ] **filter** — For input validation functions
- [ ] **spl** — Standard PHP Library (usually enabled by default)

## SDK Dependency Verification

### Composer Requirements

Check `composer.json` and `composer.lock`:

- [ ] PayPal SDK version pinned or constrained appropriately
  ```json
  "paypal/paypalhttp": "^1.0",
  "paypal/checkout-sdk-php": "^1.0"
  ```
- [ ] Lock file committed to version control
- [ ] Dependencies updated within 6 months
- [ ] No deprecated versions pinned

### Installation Verification

```bash
composer require paypal/checkout-sdk-php
php -r "require 'vendor/autoload.php'; print_r(new PayPalCheckoutSdk());"
```

## SDK Version Information

### Check Installed Version

```php
// In your code
$vendorDir = __DIR__ . '/vendor/paypal/checkout-sdk-php';
$composerJson = json_decode(file_get_contents($vendorDir . '/composer.json'), true);
$version = $composerJson['version'] ?? 'Unknown';
echo "SDK Version: " . $version;
```

### Latest Stable Release

Check latest version at:
- **GitHub**: https://github.com/paypal/Checkout-PHP-SDK/releases
- **Packagist**: https://packagist.org/packages/paypal/checkout-sdk-php

### Deprecated Methods

Review code for:
- [ ] `PayPal\Client` (old SDK) → Use `PayPal\Core\PayPalHttpClient` (new SDK)
- [ ] `PayPal_API_Operation` → Replace with modern SDK classes
- [ ] Old `nvp/` endpoints → Use REST API (`v2/` endpoints)

## Type Declarations & Strict Mode

### Recommended PHP Configuration

```php
// Enable strict type mode in PayPal integration files
declare(strict_types=1);

// Use type hints for better safety
function processPayment(float $amount, string $currency): array {
    // ...
}
```

- [ ] Type declarations used for function arguments
- [ ] Return types declared for functions
- [ ] Nullable types properly handled (`?string`, `?int`)
- [ ] Union types supported (PHP 8.0+) for flexibility

## Memory & Performance Considerations

- [ ] Sufficient memory allocated: `memory_limit = 128M` (minimum)
- [ ] Timeout appropriately set: `max_execution_time = 300` (or custom for long operations)
- [ ] PayPal API calls timeout configured (30-60 seconds recommended)
- [ ] Bulk operations handled efficiently (pagination, batching)

## Testing Environment

### Local Development Setup

```bash
# Verify PHP version
php -v

# Verify extensions
php -m

# Test SDK loading
php -r "require 'vendor/autoload.php'; echo 'SDK loaded successfully';"
```

### Continuous Integration / CD Pipeline

- [ ] PHP version specified in CI configuration (`.github/workflows/`, `.gitlab-ci.yml`, etc.)
- [ ] Composer dependencies installed and cached
- [ ] Tests run against minimum and maximum supported PHP versions
- [ ] Type checking enabled (if using static analysis tools)

## Migration Path

### Upgrading PHP Version

1. Test code on new PHP version (local dev environment)
2. Run full test suite
3. Check for deprecated features
4. Monitor for deprecation warnings
5. Update production gradually (canary deployment)

### Upgrading SDK Version

1. Review changelog: https://github.com/paypal/Checkout-PHP-SDK/releases
2. Check for breaking changes
3. Update `composer.json` version constraint
4. Run `composer update`
5. Test all PayPal-related functionality
6. Deploy and monitor
