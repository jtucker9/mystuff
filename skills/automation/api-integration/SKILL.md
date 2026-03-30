---
name: api-integration
description: "Design reliable system-to-system API integrations with auth, rate limiting, data mapping, error recovery, and sync monitoring. Use when: 'API integration', 'connect APIs', 'sync data', 'API to API', 'integrate with', or connecting two systems via APIs. Do NOT use for visual n8n workflows (n8n-workflow-builder), receiving webhooks only (webhook-designer), or cron scheduling where integration is secondary (cron-scheduler)."
---

# API Integration

## Activation

| Context | Status |
|---------|--------|
| "API integration", "connect APIs", "sync data", moving data between systems | ACTIVE |
| OAuth, rate limits, or data mapping as part of integration work | ACTIVE |
| Visual n8n workflow | DORMANT -- n8n-workflow-builder |
| Receiving webhooks only (no full integration) | DORMANT -- webhook-designer |
| Cron job where integration is secondary | DORMANT -- cron-scheduler |

## Instructions

### Step 1: Gather Integration Requirements

Collect before designing anything:

- **Source API** -- name, docs URL, auth method
- **Target system** -- another API, database, or file store
- **Data scope** -- which entities/fields to sync
- **Sync frequency** -- real-time, near-real-time, hourly, daily, on-demand
- **Volume** -- record count, change velocity
- **Direction** -- one-way or bidirectional (bidirectional requires change tokens to prevent sync loops)

> Gate: Do not proceed without source API auth method and target system confirmed.

### Step 2: Select Integration Pattern

| Pattern | When | Trade-off |
|---------|------|-----------|
| Polling | Source lacks webhooks, batch-tolerant | Simple but higher API call cost |
| Webhook | Source supports them, real-time needed | Low cost but requires endpoint hosting |
| Event-driven | High-volume, microservice comms | Lowest latency but requires queue infra (SQS/Redis/BullMQ) |
| Hybrid | Webhook primary + polling reconciliation | Best reliability, highest complexity |

Decision rules:
- Source has webhooks? Webhook-first, poll for reconciliation catch-up.
- Source has no webhooks? Poll at the smallest interval the rate limit allows.
- Need guaranteed delivery? Add a persistent queue between receive and process.
- Bidirectional? Mandatory: change tokens or last-modified timestamps to break sync loops.

> Gate: Confirm pattern choice and justify before proceeding to auth.

### Step 3: Authentication Setup

Choose based on what the source API requires:

| Method | When | Key Concern |
|--------|------|-------------|
| API Key / Bearer token | Simple APIs, server-to-server | Store in env vars, rotate on schedule |
| OAuth 2.0 (client_credentials) | SaaS APIs (Salesforce, HubSpot, etc.) | Cache token until `expires_in - 60s`, refresh proactively |
| OAuth 2.0 (authorization_code) | User-context APIs | Requires initial consent flow + refresh token storage |
| JWT (self-signed) | Google APIs, service accounts | Sign with RS256, expire at 1h max |

Rules:
- Never hardcode credentials. Environment variables or secret manager only.
- Document required scopes/permissions explicitly.
- OAuth token refresh must be transparent to calling code -- wrap in a client that auto-refreshes.
- On 401 response: refresh token once, retry once, then fail loudly.

> Gate: Auth method selected and credentials sourced before writing integration code.

### Step 4: Rate Limit Strategy

Two layers, always both:

1. **Pre-emptive** -- Track calls per window, insert delays to stay under limit. Use token bucket or simple interval math (`1000ms / maxPerSecond`).
2. **Reactive** -- Catch HTTP 429, read `Retry-After` header (default 60s if missing), wait, retry once.

Additional strategies by volume:
- **Batch endpoints** -- Prefer bulk APIs (e.g., 100 items/call) over individual calls.
- **Job queue** -- BullMQ or similar with concurrency set to stay within rate limits.
- **Cursor pagination** -- Never re-fetch pages; store cursor for resume.

Document the source API's limits in a table: endpoint, limit, window, notes.

> Gate: Rate limits documented and handling strategy confirmed before data mapping.

### Step 5: Data Mapping and Transformation

Define every field mapping as: `source.field -> target.field` with transform rule.

Transform patterns to specify:
- Type coercion (string to number, cents to dollars)
- Enum mapping (source status values to target status values)
- Normalization (`.toLowerCase().trim()` on emails)
- Concatenation (address line1 + line2)
- Date format conversion (ISO to YYYY-MM-DD or epoch)
- Constants (sync_source, last_synced_at injected by integration)
- Null handling (default values, skip vs error on missing required fields)

Rules:
- Always add `external_id` (source system ID) and `last_synced_at` to target records.
- Validate mapped records before writing -- reject malformed, continue processing rest.
- Log every skipped record with source ID and reason.

### Step 6: Error Handling and Recovery

Map every failure mode to a recovery action:

| Failure | Detection | Recovery |
|---------|-----------|----------|
| Source API down | Timeout / 5xx | Retry 3x with exponential backoff (1s, 4s, 16s), skip cycle + alert |
| Bad source data | Validation failure | Log + skip record, process remaining batch |
| Target write failure | Insert/update error | Retry 3x, then dead-letter queue for manual review |
| Partial sync (crash mid-batch) | Missing checkpoint update | Resume from last stored cursor, never restart from zero |
| Rate limit | 429 | Backoff per Step 4, resume from current position |
| Auth expired | 401 | Refresh token, retry request once |

Idempotency rules:
- Every write must be idempotent. Use upsert (ON CONFLICT UPDATE) keyed on `external_id`.
- Store sync cursor/checkpoint before processing each batch page, not after.
- For multi-step operations: log completed steps, resume from last incomplete step.

Retry backoff formula: `delay = baseDelay * (2 ^ attempt)` with jitter. Max 3 retries for transient errors. Never retry 4xx (except 429 and 401).

### Step 7: Monitoring and Sync Tracking

Track in a `sync_status` table: integration name, last sync timestamp, status (success/partial/failed), records synced/failed, last cursor, error message, duration.

Alert thresholds:
- No successful sync in 2x the expected interval
- Error rate exceeds 5% of records
- Sync duration exceeds 3x historical average

Expose a health check endpoint or dashboard: status, last sync time, record counts, data freshness, next scheduled sync.

### Step 8: Deliver Specification

Output the complete integration spec covering: pattern, auth, rate limits, data mapping, error handling, caching decisions, and monitoring -- all in one document.

Cache decisions: cache lookup tables (1h TTL), cache auth tokens (until expiry - 60s), cache pagination cursors (duration of sync), never cache transactional data.

## Examples

**Stripe to Supabase order sync:**
Polling pattern (Stripe has webhooks but polling for reconciliation). OAuth not needed -- API key auth. Map `amount` cents-to-dollars, `status` enum to internal values. Upsert on `stripe_order_id`. Poll every 5 min with `created[gte]` filter.

**HubSpot bidirectional contact sync:**
Hybrid pattern -- HubSpot webhooks for real-time + hourly polling reconciliation. OAuth 2.0 client_credentials. Change tokens (`hs_lastmodifieddate`) to prevent sync loops. Dead-letter queue for contacts failing validation. Batch API for bulk reads (100/request).

## Common Issues

| Issue | Fix |
|-------|-----|
| Sync loop in bidirectional integration | Use change tokens or `updated_by` field to skip changes made by the integration itself |
| OAuth token expires mid-sync | Cache token with 60s buffer before expiry; auto-refresh transparently in HTTP client wrapper |
| Partial sync leaves orphaned records | Always store cursor checkpoint before processing; resume from last checkpoint, never restart |

## Anti-Patterns

- **Retry without backoff** -- Hammering a failing API guarantees rate limiting on top of the original failure.
- **Restart instead of resume** -- Re-syncing from the beginning on failure wastes API calls and risks duplicates.
- **Ignoring idempotency** -- Every target write must be an upsert keyed on `external_id`; INSERT-only creates duplicates on retry.
- **Caching transactional data** -- Orders, payments, inventory must always be fetched fresh; stale cache causes data integrity bugs.
- **Bidirectional without change tokens** -- Guaranteed infinite sync loop.

## Escalation

- Source API has no pagination and returns unbounded result sets -- flag as architectural risk, recommend negotiating API changes or implementing client-side windowing by date range.
- Source API has no idempotency keys and no upsert support -- require manual dedup strategy before proceeding.
- Rate limits too low for data volume -- calculate if sync can complete within the window; if not, escalate to user for batch API access or higher tier.

## Inputs

- Source API: name, docs URL, auth method, rate limits
- Target system: type (API/DB/file), auth, write method
- Data scope: entities, fields, volume, change velocity
- Sync requirements: frequency, direction, latency tolerance

## Outputs

- Integration pattern recommendation with justification
- Auth setup specification (method, scopes, refresh strategy)
- Rate limit handling strategy (pre-emptive + reactive)
- Field mapping table with transform rules
- Error handling matrix with recovery per failure type
- Caching decisions with TTLs
- Monitoring spec: sync_status schema, alert thresholds, health check
- Complete integration specification document

## Level History

- **Lv.1** -- Base: Integration pattern selection (polling/webhook/event-driven/hybrid), auth setup (API key, OAuth 2.0, JWT), rate limit handling (pre-emptive + reactive + queue), data mapping with transforms, error recovery matrix with compensating transactions, caching strategy, sync status monitoring with freshness tracking. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Rewritten to creator-level density. Removed tutorial code and full implementation examples. Added validation gates between steps, anti-patterns, escalation triggers, idempotency rules, retry backoff formula, bidirectional sync loop prevention, and alert thresholds. (Origin: MemStack v3.3, Mar 2026)
