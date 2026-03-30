---
name: webhook-designer
description: "Design secure webhook endpoints (inbound or outbound) with signature verification, idempotency, retry semantics, and dead letter queues. WHEN: 'webhook', 'webhook handler', 'webhook endpoint', 'receive webhooks', 'webhook security', HMAC/signature verification, idempotency for event-driven systems. NOT WHEN: full n8n workflow (n8n-workflow-builder), scheduled tasks (cron-scheduler), polling-based integrations with no event source."
---

# Webhook Designer

## Activation

| Context | Status |
|---------|--------|
| User says "webhook", "webhook handler", "webhook endpoint" | ACTIVE |
| User needs to receive or send events between services | ACTIVE |
| User mentions HMAC, signature verification, idempotency | ACTIVE |
| Full n8n workflow where webhook is just the trigger | DORMANT — n8n-workflow-builder |
| Scheduled task, not event-driven | DORMANT — cron-scheduler |
| Polling integration, no event source publishes hooks | DORMANT — api-integration |

Output on activation: `Webhook Designer — Designing your webhook handler...`

## Instructions

### Step 1: Classify and Gather

Determine direction first:
- **Inbound**: receiving events from an external source (Stripe, GitHub, Shopify, custom)
- **Outbound**: delivering events to subscriber endpoints
- **Both**: building a platform that receives AND sends webhooks

Gather: event types, source/target system, payload format (JSON default), runtime (Express/Next.js/Fastify/serverless), security requirements.

**Gate**: Do not proceed without knowing direction, at least one event type, and the runtime.

### Step 2: Webhook vs Polling Decision

Use webhooks when: source supports them, near-real-time matters, event volume is unpredictable.
Use polling when: source has no webhook support, you need guaranteed ordering, rate limits make webhooks unreliable, or you need historical backfill.
Hybrid: webhook for real-time + periodic polling to catch missed events.

**Gate**: If polling is the better fit, redirect to api-integration skill.

### Step 3: Design Endpoint and Security

Route pattern: `POST /api/webhooks/{source}` — one endpoint per source system.

**Signature verification** (non-negotiable for production):
- HMAC-SHA256 with timing-safe comparison is the standard pattern
- Use source SDK when available (e.g., `stripe.webhooks.constructEvent`)
- Custom sources: document the signing algorithm, require HMAC minimum
- Reject requests with missing/empty signature headers immediately

**Replay prevention**: reject events with timestamps older than 5 minutes. Compare `abs(now - event_timestamp)` against threshold.

**Additional layers**: HTTPS only, IP allowlisting if source publishes ranges, rate limiting even on webhook endpoints, no secrets in URL paths.

**Gate**: Signature verification approach must be defined before writing handler code.

### Step 4: Payload Design and Validation

**Inbound**: define schema matching source API docs. Allow unknown fields (sources add fields without notice). Validate structure and types, not just presence.

**Outbound** (if designing your own webhook system): follow the canonical envelope:
```
{ event: "resource.action", data: {...}, timestamp: ISO8601, webhook_id: unique }
```

Event type taxonomy: `resource.action` format (e.g., `payment.completed`, `order.shipped`, `user.deleted`). Group by resource, use past tense for completed actions.

**Gate**: Schema must be defined before implementing the handler.

### Step 5: Idempotency and Delivery Semantics

Webhooks are **at-least-once** delivery. Duplicates are expected. Every handler must:
1. Extract a unique event ID from the payload (`webhook_id`, `event.id`, or header)
2. Check a dedup table before processing (`processed_webhooks` with unique constraint on event_id)
3. Mark as processed after successful handling (INSERT ON CONFLICT DO NOTHING)
4. Return 200 for duplicates — do not reprocess

Dedup table: `event_id` (unique), `event_type`, `processed_at`, optional `payload` JSONB for debugging. Add TTL index on `processed_at`, clean records older than 30 days.

### Step 6: Retry and Failure Handling

**Inbound**: return 200 immediately for valid signatures. Process asynchronously if work exceeds 5 seconds. Source systems retry on non-2xx (Stripe: 3 days, GitHub: 3 days, exponential backoff).

**Outbound**: exponential backoff with jitter, max 5 attempts, cap delay at 30 seconds. After max attempts, send to dead letter queue.

**Dead letter queue**: store failed deliveries (URL, payload, error, attempt count, timestamp). Review via admin interface or retry with separate cron job. Never silently drop events.

### Step 7: Registration API (Outbound Only)

If building outbound webhooks, provide a subscription API:
- `POST /api/webhooks/subscriptions` — register URL + event types + optional secret
- `GET /api/webhooks/subscriptions` — list active subscriptions
- `DELETE /api/webhooks/subscriptions/{id}` — unsubscribe
- Verify endpoint on registration (send challenge request, expect echo)
- Store subscriber secret for per-subscriber HMAC signing

### Step 8: Logging and Testing

**Log per event**: event_id, event_type, source, signature_valid, processing_status (success/failed/duplicate/skipped), processing_time_ms. Do NOT log full payloads in production (PII risk) — store in idempotency table only.

**Test commands**: provide curl with computed HMAC signature, test cases for invalid signature (expect 401), valid duplicate (expect 200 + already_processed), and malformed payload (expect 400).

### Step 9: Deliver Output

Present: endpoint route + auth method, handler code, validation schema, idempotency migration SQL, security checklist with status, curl test commands. For outbound: add subscription API and delivery worker.

## Examples

**Stripe payment webhook (inbound)**: POST `/api/webhooks/stripe`, verify via `stripe.webhooks.constructEvent`, handle `payment_intent.succeeded` + `charge.refunded`, idempotency on `event.id`, return 200 immediately, queue fulfillment async.

**SaaS platform event delivery (outbound)**: subscriber registers URL + events via REST API, platform signs each delivery with per-subscriber HMAC-SHA256, exponential retry up to 5 attempts, dead letter queue after exhaustion, admin dashboard shows delivery status per subscriber.

## Common Issues

1. **Raw body parsing**: signature verification requires the raw request body (not parsed JSON). In Express, use `express.raw({type: 'application/json'})` on the webhook route. Parsing before verification = signature mismatch.
2. **Timeout on slow processing**: source retries because handler takes too long. Fix: return 200 immediately, process via queue/background job.
3. **Missing idempotency**: duplicate charges, double emails, repeated side effects. Always dedup before processing, even if "it shouldn't happen."

## Anti-Patterns

- Putting secrets or API keys in webhook URL paths
- Synchronous heavy processing before returning 200
- String equality for signature comparison (timing attack vulnerable — use timing-safe compare)
- Logging full payloads containing PII to stdout
- Silently dropping failed outbound deliveries instead of dead-lettering
- Trusting webhook payload without signature verification in production

## Escalation

- Source system has no signing mechanism and refuses to add one: require IP allowlisting + shared secret in custom header as minimum, flag as security risk
- Delivery failures exceed dead letter queue capacity: escalate to infrastructure (queue service like SQS/Redis), not solvable at application level alone
- Ordering requirements across events: webhooks do not guarantee order — if ordering matters, add sequence numbers and reorder on receipt, or use polling

## Inputs

- Event types and source/target system
- Direction: inbound, outbound, or both
- Payload format and schema
- Runtime environment
- Security requirements

## Outputs

- Webhook handler with signature verification
- Payload validation schema
- Idempotency migration and dedup logic
- Retry strategy with dead letter queue concept
- Security checklist
- curl test commands
- Subscription API (outbound only)

## Level History

- **Lv.1** — Base: Secure webhook handler with HMAC signature verification (timing-safe), Zod payload validation, idempotency with dedup table, exponential backoff retry, dead letter queue, structured logging, replay prevention, security checklist, curl test commands. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Decision rules only, no full implementations. Added webhook-vs-polling decision gate, outbound registration API pattern, event type taxonomy, direction classification, escalation paths, anti-patterns. (Origin: MemStack v3.2, Mar 2026)
