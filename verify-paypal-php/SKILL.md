---
name: verify-paypal-php
description: 'Verify PayPal PHP implementation: check correctness, security, and compliance with official SDK. Use when: auditing PayPal integration, ensuring secure token handling, validating webhook setup, reviewing API calls, checking PHP compatibility.'
argument-hint: 'Specify file path or directory with PayPal implementation code'
user-invocable: true
disable-model-invocation: false
---

# Verify PayPal PHP Implementation

## When to Use

- Audit an existing PayPal PHP integration for correctness and bugs
- Verify security best practices (authentication, token handling, validation)
- Check SDK version compatibility and updates
- Review webhook implementation and error handling
- Generate compliance report before production deployment

## Required Information

Provide:
- **File path** or **directory path** containing PayPal integration code
- **PHP version** in use (if known)
- **SDK version** currently in use (if known)

## Documentation Sources (By Priority)

The skill will consult official PayPal documentation via:

1. **MCP Context7** — PayPal PHP Server SDK documentation
2. **Fallback URL** — `https://context7.com/paypal/paypal-php-server-sdk/` with direct fetching
3. **GitHub README** — `https://raw.githubusercontent.com/paypal/PayPal-PHP-Server-SDK/refs/heads/main/README.md`

## Verification Procedure

### 1. Code Analysis
- Extract PayPal initialization and API call patterns
- Identify SDK version constraints and dependencies
- Map webhook implementation details

### 2. Security Domain Checks
Review [security-checklist.md](./references/security-checklist.md) for:
- Credential and token storage (no hardcoding)
- API signature validation
- HTTPS enforcement
- Input sanitization and validation
- Error message handling (sensitive data leakage)

### 3. Authentication & API Integration
Verify:
- OAuth 2.0 flow correctness
- Token refresh mechanisms
- Client ID/Secret handling
- Permission scopes

### 4. Error Handling & Logging
Check:
- Exception handling for PayPal API responses
- Proper error logging (secure, no sensitive data)
- Retry logic and timeout configuration
- Fallback mechanisms

### 5. Data Validation
Validate:
- Input sanitization before API calls
- Response validation from PayPal
- Type checking and null safety
- Business logic validation (amounts, currencies, etc.)

### 6. PHP & SDK Compatibility
Verify:
- PHP version compatibility with SDK requirements
- Required PHP extensions (curl, json, etc.)
- SDK version up-to-date
- Deprecated methods usage

### 7. Webhook Implementation
Review [webhook-checklist.md](./references/webhook-checklist.md):
- Webhook endpoint HTTPS
- Signature verification
- Event ID tracking (prevent duplicates)
- Proper response codes

## Output Report Format

Generate a `.md` report with:

```
# PayPal Implementation Audit Report
- Date: [generated date]
- File(s) analyzed: [list of files]
- PHP Version: [detected or provided]
- SDK Version: [detected]

## Critical Issues (Must Fix)
[List items blocking production deployment]

## High Priority (Fix Before Launch)
[Items that impact security or core functionality]

## Medium Priority (Improve)
[Best-practice recommendations]

## Low Priority (Nice to Have)
[Code quality and maintainability]

## Summary & Recommendations
[Key takeaways and action plan]
```

## Related References

- [security-checklist.md](./references/security-checklist.md) — Detailed security verification points
- [webhook-checklist.md](./references/webhook-checklist.md) — Webhook implementation validation
- [php-compatibility.md](./references/php-compatibility.md) — PHP version and extension requirements
- [best-practices.md](./references/best-practices.md) — PayPal SDK best practices

## Example Invocations

```
/verify-paypal-php src/PayPal/PaymentHandler.php

/verify-paypal-php /app/payments/
```

---

**Note**: This skill requires internet access to fetch PayPal documentation. All checks are performed against the latest official PayPal PHP Server SDK standards.
