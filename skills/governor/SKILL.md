---
name: governor
description: "Use when the user says 'new project', 'project init', 'what tier', 'scope', or discusses project maturity, complexity budget, or what's appropriate to build. Do NOT use for pricing/estimates (use Scan), code review, or mid-task development work."
---


# Governor -- Portfolio Governance

*Enforce tier-appropriate complexity. Prevent over-engineering.*

## Activation

When this skill activates, output:

`Governor -- Checking project tier constraints...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User starts a new project ("new project", "init", "scaffold")** | ACTIVE -- assign tier |
| **User asks "what tier", "what's allowed", "scope check"** | ACTIVE -- report constraints |
| **User proposes work that exceeds current tier** | ACTIVE -- flag and advise |
| **User is executing work within tier constraints** | DORMANT -- don't interrupt |
| **User explicitly overrides ("I know, do it anyway")** | DORMANT -- user has authority |

## Instructions

### Step 1: Determine Project Tier

| Tier | Description | Effort |
|------|-------------|--------|
| **Prototype** | Exploring an idea. May be thrown away. | Minimal -- working code only |
| **MVP** | Validated idea, building for first users. | Moderate -- basic quality gates |
| **Production** | Serving real users, needs reliability. | Full -- complete quality stack |

If tier is unclear, default to **Prototype** and escalate only when evidence suggests otherwise.

### Step 2: Apply Tier Constraints

**Prototype -- Move Fast:** Working code only. Hardcoded config, console.log debugging, single-file scripts. No tests, CI/CD, auth, monitoring, or infra-as-code.

**MVP -- Prove It Works:** Add happy-path unit tests, simple error handling, env vars for config, basic input validation, simple auth if multi-user. No integration test suites, multi-environment deploys, performance optimization, or horizontal scaling.

**Production -- Reliability Matters:** Comprehensive tests, CI/CD, error tracking (Sentry or equivalent), input validation at all boundaries, auth + authz, structured logging, API docs. All required.

### Step 3: Report Constraints

```
Governor -- Project: {name}
   Tier: {Prototype | MVP | Production}
   Allowed: {brief list}
   NOT allowed: {brief list}
```

### Step 4: Flag Violations

When user proposes work exceeding the tier:
```
Governor -- Scope check:
   You're proposing {X}, but this is a {Tier} project.
   {X} is a {higher tier} concern. Want to proceed anyway?
```

Always defer to the user if they override.

## Examples

**New project init:**
User: "starting a new tool to parse CSV files" -> Assign Prototype tier. Report: no tests, no auth, hardcode paths. Ship when it works.

**Scope creep flag:**
User: "let me add CI/CD to this prototype" -> Flag: CI/CD is Production-tier. Suggest skipping until there are real users.

## Common Issues

| Issue | Fix |
|-------|-----|
| User keeps overriding every flag | Stop flagging for that session -- they have made a conscious choice |
| Unclear whether project is MVP or Production | Check: are there real external users today? No = MVP. Yes = Production |

## Anti-Patterns

- Writing tests for throwaway prototype code
- Adding auth to single-user tools
- Setting up CI/CD for a prototype (`git push` is your CI)
- Using TypeScript for a quick script -- JavaScript is fine for prototypes
- Adding rate limiting with 0 users
- Creating database migrations for a prototype -- use SQLite + direct schema changes
- Building admin dashboards when a DB GUI tool suffices
- Over-abstracting: 3 similar lines > 1 premature abstraction

## Level History

- **Lv.1** -- Base: 3-tier governance system with phase constraints, anti-patterns, and scope violation flagging. (Origin: MemStack v3.2, Feb 2026)
