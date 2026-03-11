# PayPal SDK Best Practices

## API Integration Pattern

### Correct Initialization

```php
// ✅ CORRECT:
$environment = new SandboxEnvironment($clientId, $clientSecret);
if ($isProduction) {
    $environment = new ProductionEnvironment($clientId, $clientSecret);
}
$client = new PayPalHttpClient($environment);

// ❌ AVOID:
$client = new PayPalHttpClient("https://api.paypal.com"); // Missing proper environment setup
```

## Error Handling Best Practices

### Handling PayPal API Exceptions

✅ **DO:**
- Catch specific exceptions (`HttpClientException`, `IOException`)
- Log full exception details server-side
- Return generic error to client
- Implement retry logic for transient failures

❌ **DON'T:**
- Expose internal PayPal error messages to clients
- Log sensitive data like API credentials or tokens
- Ignore exceptions silently
- Treat all errors as permanent failures

## Request/Response Validation

### Validate Before Use

- [ ] Check response status code (200, 201 expected for success)
- [ ] Validate response structure matches expected schema
- [ ] Handle null or missing fields gracefully
- [ ] Log unexpected response formats

### Example:

```php
$response = $client->execute($request);
if ($response->statusCode >= 400) {
    // Handle error
    $error = $response->result->details[0]->issue ?? 'Unknown error';
    throw new PaymentException("PayPal error: " . $error);
}
```

## Idempotency Keys

### Implementation

- [ ] Use `Idempotency-Key` header for all modifying operations
- [ ] Generate unique key per request: `UUID` or `uniqid()`
- [ ] Persist key in database to track duplicate requests
- [ ] Reuse response for duplicate requests (don't retry with PayPal)

```php
$headers = [
    'Idempotency-Key' => bin2hex(random_bytes(16))
];
```

## Webhook Security

### Webhook Signature Verification (Mandatory)

```php
use PayPalCheckoutSdk\Core\PayPalHttpClient;

// ✅ CORRECT: Always verify signature first
$webhookId = $_SERVER['HTTP_PAYPAL_TRANSMISSION_ID'] ?? null;
$webhookSignature = $_SERVER['HTTP_PAYPAL_TRANSMISSION_SIG'] ?? null;
$webhookCert = $_SERVER['HTTP_PAYPAL_CERT_URL'] ?? null;

$verified = $client->verifyWebhookSignature(
    $webhookId,
    $webhookSignature,
    $webhookCert,
    file_get_contents('php://input'),
    $webhookId // Your registered webhook ID
);

if (!$verified) {
    http_response_code(403);
    exit('Signature verification failed');
}

// Process webhook only after verification
$data = json_decode(file_get_contents('php://input'), true);
```

## Rate Limiting

### Best Practices

- [ ] Implement exponential backoff for retries
- [ ] Monitor API call rate (track calls per minute)
- [ ] Cache responses when appropriate (order status, subscription details)
- [ ] Batch operations when possible (rather than individual calls)
- [ ] Respect PayPal rate limit headers in responses

## Testing Best Practices

### Sandbox Environment Setup

- [ ] Use dedicated sandbox credentials for testing
- [ ] Create test business and buyer accounts in sandbox
- [ ] Test both success and failure scenarios
- [ ] Verify webhook handling with PayPal simulator
- [ ] Don't use production credentials in test code

### Test Coverage

- [ ] Unit tests for PayPal integration logic
- [ ] Integration tests with sandbox API
- [ ] Error handling tests
- [ ] Security tests (credential handling, injection attacks)
- [ ] Webhook processing tests

## Common Issues & Solutions

| Issue | Cause | Solution |
|---|---|---|
| "Unauthorized" (401) | Invalid credentials or expired token | Verify Client ID/Secret, check sandbox vs production |
| "Bad Request" (400) | Invalid request format | Validate all required fields, check date formats |
| "Unprocessable Entity" (422) | Business logic error | Check currency, amount format, payee details |
| "Too Many Requests" (429) | Rate limit exceeded | Implement backoff, cache responses |
| Webhook not received | Wrong event registration | Verify webhook URL is public HTTPS in PayPal Dashboard |

## Security Reminders

- [ ] Never commit API credentials (use environment variables)
- [ ] Rotate credentials quarterly
- [ ] Use separate sandbox and production credentials
- [ ] Enable 2FA for PayPal Dashboard access
- [ ] Review API activity logs monthly
- [ ] Keep SDK dependencies up-to-date
- [ ] Use HTTPS everywhere (production must enforce)
