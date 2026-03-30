---
name: n8n-workflow-builder
description: "Design complete n8n workflows with node mapping, data transformations, error handling, and importable JSON. WHEN: 'n8n workflow', 'build a workflow', 'automation workflow', 'n8n', 'workflow builder', connecting services with trigger-process-output chains. NOT WHEN: standalone webhook endpoint without a workflow (webhook-designer), cron/scheduled task outside n8n (cron-scheduler), direct API-to-API integration without visual orchestration (api-integration), content publishing pipeline strategy (content-pipeline)."
---

# N8N Workflow Builder

## Activation

| Context | Status |
|---------|--------|
| User says "n8n workflow", "build a workflow", "automation" | ACTIVE |
| User wants to connect services with trigger-process-output | ACTIVE |
| User mentions n8n nodes, credentials, or workflow JSON | ACTIVE |
| Standalone webhook endpoint, not a full workflow | DORMANT -- webhook-designer |
| Cron job outside n8n | DORMANT -- cron-scheduler |
| Direct API-to-API sync, no visual orchestration | DORMANT -- api-integration |
| Content publishing strategy, not a specific workflow | DORMANT -- content-pipeline |

Output on activation: `N8N Workflow Builder -- Designing your automation workflow...`

## Instructions

### Step 1: Gather and Classify

Determine workflow shape:
- **Trigger type**: webhook, schedule, app event (e.g., new Stripe charge), or manual
- **Data source**: API, database, email, file, form submission
- **Desired output**: what happens at the end (send email, update DB, post to Slack, create record)
- **Integrations**: which services (Google Sheets, Slack, Stripe, GitHub, Notion, Airtable, etc.)
- **Frequency**: one-time, on-demand, or recurring (if recurring, how often)

**Gate**: Do not proceed without knowing trigger type, at least one integration, and desired output.

### Step 2: Node Chain Design

Map the workflow as a node chain: Trigger -> Process -> Transform -> Output.

For each node, specify:

| Node | Type | Purpose | Config |
|------|------|---------|--------|
| 1. Trigger | Webhook/Schedule/App Trigger | what starts it | settings |
| 2. Fetch | HTTP Request/App Node | get data | endpoint, auth |
| 3. Process | Code/Set/IF/Switch | transform/filter | logic |
| 4. Output | App Node/HTTP Request | deliver result | settings |

Branching rules:
- **IF node**: two-path conditional (e.g., status === 'paid' -> receipt vs reminder)
- **Switch node**: multi-path routing on a single field
- **Merge node**: recombine parallel branches before output

For complex workflows, add sub-workflow nodes to keep the canvas readable. If a branch exceeds 8 nodes, extract it.

**Gate**: Node chain must be mapped and reviewed with the user before defining transformations.

### Step 3: Data Transformations

For each connection between nodes, define field mapping:
- **Source expression**: `{{ $json.fieldName }}` syntax
- **Target field**: destination property name
- **Transform**: direct pass-through, template string, type conversion, or formula

Common transforms:
- String: `.toLowerCase()`, `.trim()`, template literals
- Number: cents to dollars (`/ 100`), rounding
- Date: `DateTime.fromISO().toFormat('yyyy-MM-dd')`, timezone conversion
- Array: `.map()`, `.filter()` in Code node (not in expression fields)
- Object: spread, pick fields, rename keys via Set node

**Gate**: Verify no field references point to nodes that don't exist in the chain.

### Step 4: Error Handling

Design failure paths for each critical node:

| Node Type | On Failure | Retry | Fallback |
|-----------|-----------|-------|----------|
| HTTP Request | Log + retry | 3x, 5s backoff | Alert + skip |
| Database | Log + alert | 1x | Queue for manual review |
| External API | Log + retry | 3x exponential | Use cached data |
| Webhook delivery | Log + retry | 5x backoff | Dead letter queue |

Every workflow gets an error notification node: Slack channel, email, or webhook on any unhandled error. Include workflow name, failed node, error message, and input data.

### Step 5: Credential Setup

For each integration, specify:
- Auth type (API Key / OAuth2 / Basic Auth)
- Where to create credentials (URL to developer console)
- Required scopes
- Rate limits, expiration, rotation notes
- n8n path: Settings -> Credentials -> Add -> [Service]

**Gate**: All credentials must be identified before generating workflow JSON.

### Step 6: Scheduling (if applicable)

For scheduled workflows:
- Set timezone explicitly (n8n defaults to server timezone)
- Avoid exact hour marks (:00) -- stagger by 3-7 minutes to reduce API congestion
- Confirm previous run will finish before next starts (overlap risk)
- Cron reference: `*/15 * * * *` (every 15 min), `0 9 * * 1-5` (weekdays 9AM)

### Step 7: Testing Plan

**Node-level**: run each node alone with pinned test data, verify output shape matches downstream expectations.

**End-to-end**: execute full workflow via n8n's "Test Workflow" button. Check each node's output in execution log. Test edge cases: empty data, large payloads, special characters.

**Error path**: deliberately send bad data or disconnect a service to verify error handling fires.

### Step 8: Deliver Output

Present the complete workflow specification:
- Overview: trigger, purpose, schedule, services
- Node map with connections
- Node details: config, input shape, output shape per node
- Data transformations between nodes
- Error handling per node
- Credential setup instructions
- Test plan
- Importable n8n workflow JSON (when workflow is simple enough)

If providing workflow JSON, ensure it is valid for import via Settings -> Import Workflow.

## Examples

**Stripe-to-Slack payment alerts**: Webhook trigger receives Stripe `payment_intent.succeeded`. Code node extracts customer email + amount (cents to dollars). IF node checks amount > $100 for VIP path. Slack node posts formatted message to #payments channel. Error branch sends failure alerts to #ops. Result: importable 5-node workflow JSON.

**Daily CRM sync to Google Sheets**: Schedule trigger at 7:03 AM weekdays. HTTP Request node fetches new leads from CRM API with date filter. Set node maps fields (name, email, company, score). Google Sheets node appends rows. Error handler retries API failures 3x, alerts on exhaustion. Result: node spec + cron config + credential setup for both services.

## Common Issues

1. **Expression syntax errors**: n8n expressions use `{{ }}` double-brace syntax, not `${}` JS template literals. Expressions reference `$json`, `$node`, `$input` -- not raw variable names.
2. **OAuth token expiry mid-workflow**: long-running workflows with many API calls can exhaust token TTL. Fix: use n8n's built-in credential refresh, or add a re-auth node before the batch processing step.
3. **Schedule overlap**: a workflow takes 20 minutes but runs every 15 minutes, causing duplicate processing. Fix: add a lock check (e.g., check a flag in Redis/DB) at the start, or increase the interval.

## Anti-Patterns

- Using Code nodes for everything instead of native app nodes (loses retry/auth/credential management)
- Hardcoding API keys in Code nodes instead of using n8n Credentials
- Building one monolithic 30-node workflow instead of splitting into sub-workflows
- No error notification node -- failures silently disappear
- Polling an API every minute when the source offers webhooks
- Skipping idempotency -- assumes events are delivered exactly once (they are not)

## Escalation

- Workflow requires nodes for a service n8n doesn't support natively: use HTTP Request node with manual auth, document the custom integration, or suggest a community node
- Data volume exceeds n8n memory limits (large CSV imports, thousands of items): split into batched sub-workflows using the SplitInBatches node
- User needs guaranteed ordering across events: n8n processes items in order within a single execution but does not guarantee order across executions -- add sequence tracking if ordering matters

## Inputs

- Trigger event type
- Data source and format
- Desired output / destination
- Required integrations
- Frequency / schedule

## Outputs

- Visual node map with connections
- Node configurations with input/output shapes
- Data transformation mappings
- Error handling strategy per node
- Credential setup guide
- Testing plan
- Schedule configuration (if applicable)
- Importable workflow JSON (when feasible)

## Level History

- **Lv.1** -- Base: Node chain design with trigger/process/transform/output mapping, data transformation tables, error handling with retry and fallback paths, credential setup guides, testing approach (node-level + E2E), cron scheduling, importable JSON output format. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Creator-level density rewrite per Anthropic skill guide. Added negative triggers in frontmatter, validation gates between steps, Examples, Common Issues, Anti-Patterns, Escalation sections. Removed tutorial code and ASCII diagrams. (Origin: MemStack v3.2, Mar 2026)
