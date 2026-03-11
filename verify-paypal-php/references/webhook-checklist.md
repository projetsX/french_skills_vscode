# Webhook Implementation Checklist

## Webhook Configuration

- [ ] Webhook URL registered in PayPal Dashboard
- [ ] Webhook endpoint is publicly accessible and returns HTTP 200 OK
- [ ] Endpoint accessible via HTTPS only (no HTTP fallback)
- [ ] HTTPS certificate valid and not self-signed (production)
- [ ] Webhook can receive POST requests with JSON payloads
- [ ] Timeout configured appropriately (PayPal retries in ~16 minutes if no 200 response)

## Security: Signature Verification

- [ ] Webhook signature verification implemented using PayPal SDK
- [ ] Signature verified **before** processing any webhook data
- [ ] Webhook ID and API signature from request headers validated
- [ ] Verification fails gracefully with proper logging (no silent failures)
- [ ] Failed signature attempts logged for security monitoring

## Webhook Event Handling

- [ ] Only expected event types processed (e.g., `PAYMENT.CAPTURE.COMPLETED`)
- [ ] Event ID tracked in database to prevent duplicate processing
- [ ] Webhook gracefully handles malformed JSON
- [ ] All required fields in event payload validated before use
- [ ] Transaction IDs from webhook matched against internal records

## Idempotency & Duplicate Prevention

- [ ] Database unique constraint on PayPal transaction/order IDs
- [ ] Event ID (`id` field from PayPal) stored and checked for duplicates
- [ ] Duplicate webhook events detected and ignored safely
- [ ] Update operations idempotent (re-running doesn't cause issues)
- [ ] Race conditions handled (concurrent webhook events for same transaction)

## Error Handling & Response

- [ ] Webhook returns HTTP 200 OK immediately to PayPal (processing happens asynchronously)
- [ ] Long-running operations queued in background job (don't block webhook response)
- [ ] Database errors don't leave transaction in inconsistent state
- [ ] Partial failures handled gracefully (rollback or retry logic)
- [ ] Webhook logs include all relevant details (event ID, transaction ID, outcome)

## Webhook Events Monitored

- [ ] **PAYMENT.CAPTURE.COMPLETED** — Payment successfully captured
- [ ] **PAYMENT.CAPTURE.DENIED** — Payment was denied
- [ ] **PAYMENT.CAPTURE.REFUNDED** — Refund processed
- [ ] **CHECKOUT.ORDER.APPROVED** — Checkout order approved (if using Orders API)
- [ ] **BILLING.SUBSCRIPTION.CREATED** — Subscription created
- [ ] **BILLING.SUBSCRIPTION.CANCELLED** — Subscription cancelled
- [ ] **BILLING.SUBSCRIPTION.UPDATED** — Subscription modified

## Testing Webhook Implementation

- [ ] Test mode enabled in PayPal Dashboard to simulate events
- [ ] Webhook endpoint tested locally before production deployment
- [ ] Sample webhook payloads received and processed correctly
- [ ] Failure scenarios tested (malformed data, missing fields, invalid signatures)
- [ ] Duplicate event handling tested (same event sent twice)

## Production Readiness

- [ ] Monitoring/alerts set up for webhook failures
- [ ] Dead-letter queue or retry mechanism for failed webhooks
- [ ] Regular validation that webhook endpoint is responding
- [ ] Logs retained for audit purposes (at least 90 days recommended)
- [ ] Load testing done to ensure webhook endpoint scales
