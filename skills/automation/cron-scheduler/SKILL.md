---
name: cron-scheduler
description: "Design production-grade scheduled jobs with overlap prevention, failure handling, and structured logging. WHEN: 'cron job', 'scheduled task', 'run every', 'periodic task', recurring background jobs. NOT: n8n workflows (n8n-workflow-builder), event-driven webhooks (webhook-designer), one-off scripts."
---

# Cron Scheduler -- Scheduled Job Design

## Activation

| Context | Status |
|---------|--------|
| "cron job", "scheduled task", "run every", recurring background process | ACTIVE |
| Cron expressions, scheduling frequency questions | ACTIVE |
| n8n workflow with schedule trigger | DORMANT -- n8n-workflow-builder |
| Event-driven webhook (not time-based) | DORMANT -- webhook-designer |
| One-off script execution | DORMANT -- not a scheduling problem |

Output: `Cron Scheduler -- Designing your scheduled job...`

## Instructions

### Step 1: Gather Requirements

Collect before designing:
- **Task**: What does the job do?
- **Frequency**: How often? (sub-minute not supported by standard cron)
- **Platform**: Railway / Netlify / VPS crontab / n8n / in-process (node-cron)
- **Duration**: Expected runtime (determines lock TTL)
- **Dependencies**: Database, external APIs, file system
- **Failure severity**: Critical (alert immediately) / Important (alert after 2x interval) / Low (log only)

**Gate**: All six answered before proceeding. If user is uncertain about platform, recommend Railway for serverless jobs, VPS crontab for long-running or filesystem-dependent jobs.

### Step 2: Choose Scheduling Strategy

Decision tree -- pick the first match:

| Condition | Strategy | Rationale |
|-----------|----------|-----------|
| Triggered by external event, not time | Event-driven (webhook) | Cron is wrong tool -- hand off |
| Needs exactly-once with ordering guarantees | Job queue (BullMQ, pg-boss) | Cron can't guarantee delivery order |
| Runs < 30s, stateless, no overlap risk | Platform cron (Railway/Netlify) | Simplest -- platform manages lifecycle |
| Runs > 30s, needs lock, multi-instance | Cron + database lock | Overlap prevention required |
| Complex dependency chain (A then B then C) | Orchestrator (n8n, Temporal) | Cron can't express dependencies |

**Gate**: Strategy chosen. If event-driven or queue, redirect to appropriate skill and stop.

### Step 3: Write Cron Expression

Syntax: `minute hour day-of-month month day-of-week`

Key rules:
- Fields: minute (0-59), hour (0-23), day (1-31), month (1-12), weekday (0-7, both 0 and 7 = Sunday)
- `*/N` = every N units; `N-M` = range; `N,M` = list
- Offset high-frequency jobs to avoid peak minutes (use `:07` not `:00`)
- Always specify timezone -- cron defaults to server local time, which breaks on DST transitions and multi-region deploys
- For jobs > 5 min runtime, ensure interval > 2x max expected duration

**Timezone rule**: Store and schedule in UTC. Convert for display only. If the job must run at a local business hour (e.g., "9 AM Chicago"), use the platform's timezone setting or `node-cron`'s `timezone` option -- never do manual UTC offset math.

**Gate**: Expression written, human-readable description confirmed with user, timezone specified.

### Step 4: Design Overlap Prevention

Choose lock mechanism based on deployment:

| Deployment | Lock Strategy |
|------------|---------------|
| Single instance (one server/container) | File lock or in-memory flag |
| Multi-instance (replicas, autoscaling) | Database row lock with TTL |
| Serverless (Railway cron, Netlify) | Database lock (no shared memory) |

Database lock approach:
- `INSERT ... ON CONFLICT DO UPDATE WHERE expires_at < NOW()` -- atomic acquire
- TTL = 2x max expected job duration (prevents permanent deadlock on crash)
- Release lock in both success and error paths (finally block)
- If lock is held, log `job_skipped` with reason `lock_held` and exit cleanly -- do not queue or retry

**Gate**: Lock strategy chosen. If multi-instance, database lock table schema defined.

### Step 5: Define Failure Handling

Three failure categories with distinct responses:

1. **Transient** (API timeout, rate limit): Retry up to 3x with exponential backoff (1s, 4s, 16s). If all retries fail, log and alert based on severity.
2. **Permanent** (bad data, schema mismatch): Abort immediately, alert, require human intervention. Do not retry.
3. **Crash** (process killed, OOM): Lock TTL expires automatically. Next scheduled run retries from last checkpoint.

Checkpoint pattern for long jobs: Save progress every N items to a `cron_checkpoints` table. On restart, resume from last checkpoint. Clear checkpoint on successful completion.

**Gate**: Failure types mapped to responses. Checkpoint interval chosen if job processes > 100 items.

### Step 6: Specify Logging and Monitoring

Structured JSON logging -- every entry must include: `event`, `job`, `runId` (UUID), `timestamp` (ISO 8601), `duration_ms`, `items_processed`, `error`.

Log events: `job_started`, `job_skipped` (lock held), `job_completed`, `job_failed`.

Monitoring: Track last-run time and status per job. Alert if a job hasn't run in 2x its expected interval (missed run detection). Aggregate repeated failures into one alert -- don't spam on recurring errors.

### Step 7: Deploy

Platform-specific deployment -- provide config for the chosen platform only:
- **Railway**: Cron schedule in dashboard (Service > Settings > Cron). Railway starts container, runs job, shuts down.
- **Netlify**: Scheduled Function with `export const config: Config = { schedule: '<expression>' }`.
- **VPS crontab**: `crontab -e`, redirect stdout/stderr to log file, use absolute paths.
- **node-cron** (in-process): `cron.schedule(expression, handler, { timezone })`. Only for always-running servers.

**Gate**: Deployment config provided, user confirms platform access.

### Step 8: Deliver Specification

Output a specification block containing: schedule (expression + readable + timezone), job phases (lock > gather > process > report > cleanup), failure handling table, lock mechanism, logging format, deployment config, and alert rules.

## Examples

**Example 1 -- Daily cleanup job**: User wants to purge expired sessions nightly. Strategy: platform cron (single instance, fast, stateless). Expression: `0 3 * * *` UTC. No lock needed (single instance, runs < 10s). Failure: transient retry 3x, then alert. Deploy: Railway cron.

**Example 2 -- Multi-instance sync job**: User wants to sync inventory from external API every 15 minutes across 3 replicas. Strategy: cron + database lock (multi-instance overlap risk). Expression: `*/15 * * * *`. Lock TTL: 20 min. Checkpoint every 50 items. Failure: transient retry for API, permanent abort for schema errors. Alert: Slack on failure, email if missed 2 consecutive runs.

## Common Issues

1. **Job overlaps itself**: Runs take longer than the interval. Fix: add database lock, increase interval, or optimize job. Never reduce lock TTL below max runtime.
2. **DST double-fire or skip**: Cron using local timezone fires twice or skips during DST transition. Fix: schedule in UTC, convert for display only.
3. **Stale lock blocks all runs**: Job crashed without releasing lock, TTL set too high. Fix: set TTL to 2x max expected duration, not infinity. Add manual unlock endpoint for emergencies.

## Anti-Patterns

- **Sub-minute polling via cron**: Cron's minimum granularity is 1 minute. For sub-minute, use a persistent process with `setInterval` or a message queue.
- **Chaining cron jobs by timing** (Job B at :05 hoping Job A finishes by then): Use explicit dependency (Job A triggers Job B on completion) or an orchestrator.
- **Catch-all error swallowing**: `catch(e) {}` hides failures. Always log, always decide: retry or abort.
- **Hardcoded UTC offsets**: `0 14 * * *` to mean "9 AM EST" breaks on DST. Use timezone-aware scheduling.

## Escalation

- Job requires sub-second precision or exactly-once delivery: Recommend job queue (BullMQ, pg-boss, SQS).
- Complex multi-job DAG with conditional branches: Recommend workflow orchestrator (Temporal, n8n).
- Job must survive infrastructure failures (multi-region, disaster recovery): Recommend managed scheduler (AWS EventBridge, Cloud Scheduler).

## Inputs

- Task description and purpose
- Frequency / schedule
- Runtime platform
- Expected duration
- Dependencies (database, APIs, filesystem)
- Failure severity (critical / important / low)

## Outputs

- Cron expression with human-readable explanation and timezone
- Scheduling strategy rationale (cron vs queue vs event-driven)
- Overlap prevention mechanism (lock strategy + TTL)
- Failure handling rules (transient/permanent/crash)
- Structured logging format (JSON with required fields)
- Platform-specific deployment config
- Alert rules based on severity

## Level History

- **Lv.1** -- Base: Cron expression builder, phased job structure, checkpoint-based error recovery, database lock for overlap prevention, health check endpoint, run-tracking table, structured JSON logging, multi-platform deployment (Railway, Netlify, crontab, n8n, node-cron), failure alerting. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Creator-level density rewrite. Replaced inline code blocks with decision rules and strategy tables. Added scheduling strategy decision tree (cron vs queue vs event-driven), validation gates between steps, escalation paths, anti-patterns section. Preserved all operational knowledge: cron syntax rules, overlap prevention, failure categories, timezone handling, checkpoint pattern, structured logging requirements. (Origin: MemStack v3.2, Mar 2026)
