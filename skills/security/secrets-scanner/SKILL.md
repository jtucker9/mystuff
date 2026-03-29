---
name: secrets-scanner
description: "Use when the user says 'scan for secrets', 'check for leaked keys', 'secrets scanner', 'hardcoded credentials', 'API key leak', 'rotate keys', or needs to detect exposed secrets in source code or git history. Do NOT use for dependency vulnerabilities (see dependency-audit) or RLS auditing (see rls-checker)."
---

# 🔑 Secrets Scanner — Credential Detection & Remediation
*Scan codebases and git history for hardcoded secrets, API keys, tokens, and credentials with automated detection patterns and rotation procedures.*

## Activation

When this skill activates, output:

`🔑 Secrets Scanner — Scanning for hardcoded secrets and credential exposure...`

| Context | Status |
|---------|--------|
| **User says "scan for secrets", "leaked keys", "hardcoded credentials"** | ACTIVE |
| **User mentions "API key leak", "rotate keys", "credential exposure"** | ACTIVE |
| **User wants pre-commit secret detection setup** | ACTIVE |
| **User wants dependency vulnerability scanning** | DORMANT — see dependency-audit |
| **User wants RLS policy auditing** | DORMANT — see rls-checker |
| **User wants HTTP security headers** | DORMANT — see csp-headers |

## Protocol

### Step 1: Gather Inputs

Ask the user for:
- **Scan scope**: Full repo, specific directories, or git history?
- **Cloud providers used**: AWS, GCP, Azure, Vercel, Supabase, etc.
- **Services integrated**: Stripe, Twilio, SendGrid, OpenAI, GitHub, etc.
- **Known secret locations**: Any `.env` files, config files, or vaults in use?
- **CI/CD platform**: GitHub Actions, GitLab CI, etc. (for pipeline secret check)

### Step 2: Run Automated Scanning

**Using grep patterns (no tooling required):**

```bash
# High-confidence patterns — these almost always indicate real secrets
grep -rn --include="*.{js,ts,py,go,rb,java,php,yaml,yml,json,toml,env,cfg,conf,ini}" \
  -E '(AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|sk-[a-zA-Z0-9]{20,}|sk_live_[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|gho_[a-zA-Z0-9]{36}|github_pat_[a-zA-Z0-9_]{22,}|xox[bpsa]-[a-zA-Z0-9-]{10,}|SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}|sq0[a-z]{3}-[a-zA-Z0-9_-]{22,})' .

# Generic secret patterns (higher false positive rate)
grep -rn --include="*.{js,ts,py,go,rb,java,php}" \
  -iE '(password|passwd|pwd|secret|token|api_key|apikey|api-key|access_key|private_key)\s*[:=]\s*["\x27][^\s"'\'']{8,}' .

# Check for .env files committed to repo
find . -name ".env*" -not -path "*/node_modules/*" -not -path "*/.git/*" -type f

# Check for private keys
find . -name "*.pem" -o -name "*.key" -o -name "*.p12" -o -name "*.pfx" -o -name "id_rsa" -o -name "id_ed25519" | grep -v node_modules | grep -v .git
```

**Using TruffleHog (recommended for git history):**
```bash
# Install
# macOS: brew install trufflehog
# Linux: curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh

# Scan current directory
trufflehog filesystem --directory=. --only-verified

# Scan git history (finds secrets that were committed then "deleted")
trufflehog git file://. --only-verified

# Scan specific branch
trufflehog git file://. --branch=main --only-verified

# JSON output for processing
trufflehog filesystem --directory=. --json
```

**Using Gitleaks:**
```bash
# Install
# macOS: brew install gitleaks
# go: go install github.com/zricethezav/gitleaks/v8@latest

# Scan repo
gitleaks detect --source=. --verbose

# Scan git history
gitleaks detect --source=. --log-opts="--all" --verbose

# Generate report
gitleaks detect --source=. --report-format=json --report-path=gitleaks-report.json
```

### Step 3: Secret Pattern Reference

**High-confidence patterns by provider:**

| Provider | Pattern | Regex |
|----------|---------|-------|
| **AWS Access Key** | `AKIA` + 16 chars | `AKIA[0-9A-Z]{16}` |
| **AWS Secret Key** | 40 char base64 | `[0-9a-zA-Z/+=]{40}` (near AWS context) |
| **GCP API Key** | `AIza` + 35 chars | `AIza[0-9A-Za-z_-]{35}` |
| **GCP Service Account** | JSON with `private_key` | `"private_key":\s*"-----BEGIN` |
| **Azure Storage** | Connection string | `DefaultEndpointsProtocol=https;AccountName=` |
| **GitHub PAT** | `ghp_` prefix | `ghp_[a-zA-Z0-9]{36}` |
| **GitHub OAuth** | `gho_` prefix | `gho_[a-zA-Z0-9]{36}` |
| **GitHub App Token** | `github_pat_` prefix | `github_pat_[a-zA-Z0-9_]{22,}` |
| **GitLab PAT** | `glpat-` prefix | `glpat-[a-zA-Z0-9_-]{20,}` |
| **Slack Token** | `xox` prefix | `xox[bpsa]-[a-zA-Z0-9-]{10,}` |
| **Slack Webhook** | URL pattern | `hooks\.slack\.com/services/T[A-Z0-9]+/B[A-Z0-9]+/[a-zA-Z0-9]+` |
| **Stripe Live Key** | `sk_live_` prefix | `sk_live_[a-zA-Z0-9]{20,}` |
| **Stripe Test Key** | `sk_test_` prefix | `sk_test_[a-zA-Z0-9]{20,}` |
| **Stripe Publishable** | `pk_live_` / `pk_test_` | `pk_(live\|test)_[a-zA-Z0-9]{20,}` |
| **OpenAI API Key** | `sk-` prefix | `sk-[a-zA-Z0-9]{20,}` |
| **Anthropic API Key** | `sk-ant-` prefix | `sk-ant-[a-zA-Z0-9_-]{20,}` |
| **SendGrid** | `SG.` prefix | `SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}` |
| **Twilio** | `SK` + 32 hex | `SK[0-9a-fA-F]{32}` |
| **Twilio Auth Token** | 32 hex chars | `[0-9a-f]{32}` (near Twilio context) |
| **Supabase Service Role** | `eyJ` + JWT | `eyJ[a-zA-Z0-9_-]{100,}` (in SUPABASE context) |
| **Firebase** | Config object | `apiKey.*AIza` |
| **Mailgun** | `key-` prefix | `key-[a-zA-Z0-9]{32}` |
| **Square** | `sq0` prefix | `sq0[a-z]{3}-[a-zA-Z0-9_-]{22,}` |
| **JWT Private Key** | PEM header | `-----BEGIN (RSA\|EC\|PRIVATE) (PRIVATE )?KEY-----` |
| **SSH Private Key** | OpenSSH header | `-----BEGIN OPENSSH PRIVATE KEY-----` |
| **Database URL** | Connection string | `(postgres\|mysql\|mongodb)://[^:]+:[^@]+@` |
| **Generic Bearer Token** | Authorization header | `Authorization:\s*Bearer\s+[a-zA-Z0-9._-]{20,}` |

### Step 4: Scan Git History

Secrets removed from current files may still exist in git history.

```bash
# Search all commits for patterns
git log --all -p | grep -E 'AKIA[0-9A-Z]{16}|sk_live_|sk-[a-zA-Z0-9]{20,}'

# Find which commit introduced a secret
git log --all -p -S 'AKIA' --diff-filter=A

# TruffleHog is better for this — it verifies secrets are still valid
trufflehog git file://. --only-verified --json
```

**If secrets are found in git history:**
```
Secret found in git history — what to do?
├── Is the secret still valid (not rotated)?
│   └── ROTATE IMMEDIATELY (Step 6), then clean history
├── Is the repo public?
│   └── Even if rotated, clean history (attackers may have cloned)
├── Is the repo private, team-only?
│   └── Rotate the secret, history cleanup optional but recommended
└── Cleaning history
    ├── Single file: git filter-branch or BFG Repo Cleaner
    ├── BFG: java -jar bfg.jar --replace-text secrets.txt repo.git
    └── git-filter-repo: git filter-repo --invert-paths --path <file>
    ⚠️ History rewriting requires force-push and team coordination
```

### Step 5: Audit .env and Config Files

```bash
# Check if .env is in .gitignore
grep -q "\.env" .gitignore && echo "✅ .env in .gitignore" || echo "❌ .env NOT in .gitignore"

# Check if .env was ever committed
git log --all --diff-filter=A -- "*.env" "*.env.*"

# Verify .env.example has no real values
if [ -f .env.example ]; then
  grep -nE '=.{8,}' .env.example | grep -viE '(example|placeholder|your_|xxx|changeme|TODO)'
fi
```

**Files that should NEVER be committed:**

| File | Why |
|------|-----|
| `.env`, `.env.local`, `.env.production` | Contains secrets |
| `*.pem`, `*.key`, `*.p12` | Private keys |
| `serviceAccountKey.json` | GCP credentials |
| `credentials.json` | Various cloud credentials |
| `id_rsa`, `id_ed25519` | SSH private keys |
| `.npmrc` with `_authToken` | Registry token |
| `docker-compose.override.yml` | Often contains secrets |
| `wp-config.php` | WordPress database credentials |

**Recommended .gitignore additions:**
```gitignore
# Secrets and credentials
.env
.env.*
!.env.example
*.pem
*.key
*.p12
*.pfx
serviceAccountKey*.json
credentials.json
**/secrets/
```

### Step 6: Secret Rotation Procedures

**When a secret is exposed, rotate it immediately. Do not just delete the file.**

| Provider | Rotation Steps |
|----------|---------------|
| **AWS** | IAM Console → Users → Security Credentials → Create new key → Update apps → Deactivate old key → Delete after 24h |
| **GCP** | Console → APIs & Services → Credentials → Create new key → Restrict key → Delete old key |
| **GitHub PAT** | Settings → Developer Settings → Personal Access Tokens → Generate new → Revoke old |
| **Stripe** | Dashboard → Developers → API Keys → Roll key (creates new, old works for 24h) |
| **OpenAI** | Platform → API Keys → Create new → Delete old |
| **Anthropic** | Console → API Keys → Create new → Delete old |
| **SendGrid** | Settings → API Keys → Create new → Delete old |
| **Supabase** | Project Settings → API → Generate new JWT secret (requires migration) |
| **Database** | Change password: `ALTER USER name WITH PASSWORD 'new_password';` → Update all connection strings |
| **SSH Key** | Generate new: `ssh-keygen -t ed25519` → Add to authorized_keys → Remove old |

**Post-rotation checklist:**
- [ ] New secret generated and tested
- [ ] All applications updated with new secret
- [ ] CI/CD pipeline secrets updated
- [ ] Old secret deactivated/deleted
- [ ] Verify no service disruption
- [ ] Document the rotation in incident log

### Step 7: Set Up Prevention

**Pre-commit hook with Gitleaks:**
```bash
# Install gitleaks pre-commit hook
# In .pre-commit-config.yaml:
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
EOF

# Install pre-commit
pip install pre-commit
pre-commit install
```

**GitHub Actions secret scanning:**
```yaml
# .github/workflows/secrets-scan.yml
name: Secrets Scan
on: [push, pull_request]
jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Custom pre-commit hook (no dependencies):**
```bash
#!/bin/bash
# .git/hooks/pre-commit

# High-confidence secret patterns
PATTERNS='AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|sk-[a-zA-Z0-9]{20,}|sk_live_|ghp_[a-zA-Z0-9]{36}|xox[bpsa]-|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|SG\.[a-zA-Z0-9_-]{22}\.'

# Check staged files only
MATCHES=$(git diff --cached --diff-filter=ACMR -U0 | grep -E "$PATTERNS" | head -5)

if [ -n "$MATCHES" ]; then
  echo "❌ Potential secrets detected in staged changes:"
  echo "$MATCHES"
  echo ""
  echo "If these are false positives, commit with: git commit --no-verify"
  echo "Otherwise, remove the secrets and try again."
  exit 1
fi
```

### Step 8: Output

```
━━━ SECRETS SCAN REPORT ━━━━━━━━━━━━━━━━━

── SCAN SCOPE ────────────────────────────
Directory: [path]
Files scanned: [N]
Git history: [scanned / not scanned]

── FINDINGS ──────────────────────────────

🔴 CONFIRMED SECRETS (Immediate Action Required)
[list with file, line, type, provider, masked value]

🟡 PROBABLE SECRETS (Verify Manually)
[list with file, line, pattern match, context]

🟢 FALSE POSITIVES (No Action)
[list with reasoning]

── .ENV AUDIT ────────────────────────────
.gitignore coverage: [✅/❌]
.env committed in history: [Yes/No]
.env.example safe: [✅/❌]

── ROTATION REQUIRED ─────────────────────
[provider-specific rotation steps for each confirmed secret]

── PREVENTION SETUP ──────────────────────
[pre-commit hook configuration]
[CI pipeline configuration]

── RISK SUMMARY ──────────────────────────
Secrets requiring rotation: [N]
History cleanup needed: [Yes/No]
Prevention in place: [Yes/No]
```

## Anti-Patterns

- **Deleting the file without rotating the secret**: If it was committed, it's in git history. The secret itself must be changed, not just the file removed.
- **Using `--no-verify` to bypass pre-commit hooks**: If the hook caught something, investigate it. Bypassing defeats the purpose.
- **Committing `.env.example` with real values**: Example files should have placeholder values only (`YOUR_API_KEY_HERE`).
- **Storing secrets in code comments**: `// API key: sk-abc123` is just as exposed as a variable assignment.
- **Hardcoding test/dev secrets**: Even test keys can be used for abuse. Use environment variables for everything.
- **Relying solely on `.gitignore`**: Files can be force-added with `git add -f`. Pre-commit hooks are a stronger safeguard.
- **Assuming private repos are safe**: Private repos can be cloned by any team member, compromised via stolen credentials, or accidentally made public.

## Escalation

Hand off to a security incident response team when:
- Production secrets are confirmed leaked in a public repository
- Secrets have been exposed for more than 24 hours before detection
- Evidence of unauthorized access using leaked credentials
- Customer data may have been accessed via leaked database credentials
- You discover secrets from a provider you don't recognize (possible compromise)

## Inputs
- Repository path and scope
- Cloud providers and services in use
- Known secret storage locations
- Git history scan preference

## Outputs
- Categorized findings (confirmed, probable, false positive)
- Provider-specific rotation procedures
- .env and config file audit
- Pre-commit hook configuration
- CI/CD pipeline secret scanning setup
- Git history cleanup guidance (if needed)

## Level History

- **Lv.1** — Base: Multi-method scanning (grep patterns, TruffleHog, Gitleaks), 30+ provider-specific regex patterns, git history scanning, .env auditing, rotation procedures for 10 major providers, pre-commit and CI prevention setup, supply chain secret exposure assessment. (Origin: MemStack v3.3, Mar 2026)
