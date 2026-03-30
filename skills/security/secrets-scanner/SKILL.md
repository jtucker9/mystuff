---
name: secrets-scanner
description: "WHAT: Detect hardcoded secrets, audit env files, guide rotation and prevention. WHEN: 'scan for secrets', 'leaked keys', 'hardcoded credentials', 'API key leak', 'rotate keys', 'credential exposure', pre-commit secret detection setup. NOT: dependency vulnerabilities (dependency-audit), RLS policies (rls-checker), HTTP headers (csp-headers)."
---

# Secrets Scanner -- Credential Detection and Remediation

## Activation

Output: `Secrets Scanner -- Scanning for hardcoded secrets and credential exposure...`

| Context | Status |
|---------|--------|
| "scan for secrets", "leaked keys", "hardcoded credentials" | ACTIVE |
| "API key leak", "rotate keys", "credential exposure" | ACTIVE |
| Pre-commit secret detection setup | ACTIVE |
| Dependency vulnerabilities | DORMANT -- dependency-audit |
| RLS policy auditing | DORMANT -- rls-checker |
| HTTP security headers | DORMANT -- csp-headers |

## Instructions

### Step 1: Scope the Scan

Collect: scan scope (repo, directories, git history), cloud providers in use, integrated services, known secret storage locations (.env, vaults, config), CI/CD platform.

**Gate:** Proceed only when scope and provider list are confirmed. Default to full-repo + history if user says "just scan everything."

### Step 2: Detect Secrets

Run detection across three surfaces in order:

1. **File scan** -- Search working tree for secret patterns across source, config, and env files. Use provider-specific prefixes (high confidence) before generic key/password assignments (higher false positive rate).
2. **Git history** -- Secrets removed from current files persist in commits. Prefer tooling that verifies liveness (TruffleHog `--only-verified`, Gitleaks). Fall back to manual `git log -p -S` searches if tooling unavailable.
3. **Env file audit** -- Verify .gitignore covers .env variants, check if .env was ever committed, confirm .env.example contains only placeholders.

**Gate:** Classify every finding before proceeding. No raw dump of matches.

### Step 3: Classify Findings

**Secret type taxonomy:**

| Type | Examples | Severity |
|------|----------|----------|
| API keys | AWS (`AKIA`), GCP (`AIza`), OpenAI (`sk-`), Anthropic (`sk-ant-`) | CRITICAL if production, HIGH if test |
| Tokens | GitHub PAT (`ghp_`), GitLab (`glpat-`), Slack (`xox`), Bearer tokens | CRITICAL -- direct access |
| Passwords | Database credentials, hardcoded passwords in source | CRITICAL |
| Certificates/Private keys | PEM, PKCS12, SSH private keys, OpenSSH keys | CRITICAL -- non-rotatable without coordination |
| Connection strings | Postgres/MySQL/MongoDB URIs with credentials, Azure connection strings | CRITICAL -- full database access |
| Publishable/test keys | Stripe `pk_test_`, Firebase client config | LOW -- public by design |

Classify each finding as: **Confirmed** (matches known prefix + valid structure), **Probable** (generic pattern, needs manual verification), or **False Positive** (placeholder, test fixture, documentation example).

**Gate:** User confirms classification before rotation begins. Misclassifying a false positive as confirmed wastes rotation effort; misclassifying confirmed as false positive leaves exposure.

### Step 4: Remediate

For every confirmed secret, execute in this order -- no exceptions:

1. **Rotate** -- Generate new credential at the provider. Update all consuming applications and CI/CD secrets.
2. **Revoke** -- Deactivate the old credential. Verify no service disruption after deactivation.
3. **Clean history** -- If secret exists in git history and repo is public (or was ever public), rewrite history with BFG or git-filter-repo. Coordinate force-push with team.
4. **Prevent** -- Ensure the secret category cannot be re-committed (see Step 5).

**Gate:** Each confirmed secret must have rotation evidence (new key tested, old key revoked) before marking resolved.

### Step 5: Establish Prevention

Three layers, each independent:

1. **.gitignore** -- Cover .env variants, key files (.pem, .key, .p12), credential JSONs, secrets directories.
2. **Pre-commit hooks** -- Block commits containing high-confidence secret patterns. Use Gitleaks hook or custom pattern matching on staged diffs.
3. **CI pipeline** -- Add secret scanning to push/PR workflows as a blocking check.

**Gate:** At least two of three layers must be in place before closing the scan.

### Step 6: Report

Structure output as: Scan Scope (path, file count, history coverage) > Findings by classification (confirmed, probable, false positive with reasoning) > Env Audit (.gitignore coverage, history exposure, example file safety) > Rotation Status (per-secret provider steps and completion) > Prevention Status (which layers are active) > Risk Summary (secrets requiring rotation count, history cleanup needed, prevention coverage).

## Examples

**Example 1 -- Standard repo scan:** User says "scan this repo for secrets." Scope: full repo + git history. Run file scan, find AWS key in `config/deploy.js` and Stripe test key in `src/utils.ts`. Classify AWS key as CRITICAL/Confirmed, Stripe test key as LOW/Confirmed. Rotate AWS key, note Stripe test key for cleanup but no emergency. Set up pre-commit hook. Report.

**Example 2 -- Post-incident rotation:** User says "we leaked our database password, help me rotate." Skip scanning. Go directly to Step 4: rotate the database password, update all connection strings, revoke old password, check git history for the credential, clean if present. Then Step 5: verify .env is gitignored, add pre-commit hook if missing.

## Common Issues

- **Secret in history but not in working tree** -- User deletes the file and thinks they are safe. The secret is still extractable from any git clone. Must rotate the credential regardless; history cleanup is secondary to rotation.
- **False positive flood from generic patterns** -- Generic `password=` or `token=` patterns match config templates and documentation. Always verify structure and context before classifying. Provider-specific prefixes are far more reliable.
- **Force-push coordination failure** -- History rewriting invalidates every clone. All team members must re-clone or reset. Communicate before force-pushing and never rewrite shared history without team acknowledgment.

## Anti-Patterns

- Deleting the file without rotating the secret -- if it was committed, it is in history and must be changed at the provider.
- Using `--no-verify` to bypass pre-commit hooks that caught a real secret.
- Committing `.env.example` with real values instead of placeholders.
- Assuming private repos are safe -- they can be cloned by team members, leaked via credential compromise, or accidentally made public.
- Relying solely on `.gitignore` without pre-commit hooks -- `git add -f` bypasses gitignore entirely.

## Escalation

Hand off to security incident response when:
- Production secrets confirmed leaked in a public repository.
- Exposure window exceeds 24 hours before detection.
- Evidence of unauthorized access using leaked credentials.
- Customer data potentially accessed via leaked database credentials.
- Secrets from an unrecognized provider appear (possible supply chain compromise).

## Inputs

- Repository path and scan scope (working tree, specific dirs, git history)
- Cloud providers and integrated services
- Known secret storage locations
- CI/CD platform

## Outputs

- Classified findings: confirmed, probable, false positive
- Provider-specific rotation status per confirmed secret
- Env file and .gitignore audit
- Prevention layer status (gitignore, pre-commit, CI)
- History cleanup guidance if applicable

## Level History

- **Lv.1** -- Base: Multi-method scanning, 30+ provider-specific patterns, git history scanning, .env auditing, rotation procedures for major providers, pre-commit and CI prevention setup. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Decision-rule rewrite. Removed inline regex, grep commands, tool install instructions, .gitignore templates, rotation step-by-steps, hook config files. Preserved taxonomy, classification, remediation protocol, prevention strategy, false positive handling. (Origin: MemStack v3.4, Mar 2026)
