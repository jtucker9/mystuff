---
name: compress
description: "Use when the user says 'headroom', 'compression', 'token savings', 'proxy status', or asks about context window usage. Do NOT use for general performance questions, API rate limits, or Anthropic billing inquiries."
---


# Compress -- Headroom Proxy Manager
*Monitor and manage Headroom context compression for CC sessions.*

## Activation

When this skill activates, output:

`Compress -- Checking Headroom status...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "headroom", "compression stats", "check proxy"** | ACTIVE -- run status check |
| **User asks about token savings or context window** | ACTIVE -- run session report |
| **Proxy errors or API connection failures appear** | ACTIVE -- run health diagnostics |
| **General discussion about CC features** | DORMANT -- do not activate |
| **User is actively coding (no proxy issues)** | DORMANT -- do not activate |

## Prerequisites

- **Headroom installed:** `pip install headroom-ai[code]` (the `[code]` extra enables tree-sitter AST compression)
- **Proxy running:** `headroom proxy --llmlingua-device cpu` (defaults to `localhost:8787`)
- **CC configured:** `ANTHROPIC_BASE_URL=http://127.0.0.1:8787`

## Instructions

### 1. Status Check

```bash
curl -s http://127.0.0.1:8787/stats | python -m json.tool
```

Report: proxy up/down, requests processed, compression ratio, tokens saved, estimated cost savings.

### 2. Health Diagnostics

If proxy is unreachable:

1. Check if process is running: `ps aux | grep headroom`
2. Check port binding: `netstat -ano | findstr 8787`
3. Verify `ANTHROPIC_BASE_URL` is set: `echo $ANTHROPIC_BASE_URL`
4. Restart: `headroom proxy --llmlingua-device cpu` in a separate terminal

### 3. Session Report

Report: requests this session, tokens before/after compression, compression ratio (target: 30-40%), estimated dollar savings (at $15/MTok input, $75/MTok output for Opus).

### 4. Configuration Reference

| Setting | Value | Notes |
|---------|-------|-------|
| Proxy URL | `http://127.0.0.1:8787` | Default port |
| Repo | `github.com/chopratejas/headroom` | Apache 2.0 |
| Python | 3.14 compatible | Tested Feb 2026 |

## Examples

**Status check:**
User: "check headroom" -> Run `curl -s http://127.0.0.1:8787/stats`, report compression ratio and tokens saved.

**Troubleshoot dead proxy:**
User: "API errors, headroom down?" -> Check process, port, env var. Restart if needed. Report fix.

## Common Issues

| Issue | Fix |
|-------|-----|
| 0% compression / 0.00x ratio | Install `headroom-ai[code]` (not just `headroom-ai`), restart proxy |
| Cost figures don't match Anthropic Console | Headroom estimates at list prices, ignoring server-side prompt caching discounts |

## Anti-Patterns

- Activating when user asks about Anthropic API billing or rate limits -- that is not proxy-related
- Restarting the proxy without checking if it is actually down first
- Running health diagnostics when the user just wants stats -- check stats first
- Recommending GPU flags on machines without NVIDIA GPUs -- always use `--llmlingua-device cpu`

## Level History

- **Lv.1** -- Base: Health check and stats reporting for Headroom proxy. (Origin: MemStack v3.0, Feb 2026)
- **Lv.2** -- Fixed: Added `[code]` extra for tree-sitter AST compression, updated startup flags (`--llmlingua-device cpu`), added troubleshooting. Compression 0% -> 46%. (Feb 24, 2026)
