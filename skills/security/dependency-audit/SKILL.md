---
name: dependency-audit
description: "Use when the user says 'dependency audit', 'npm audit', 'pip audit', 'cargo audit', 'vulnerable packages', 'supply chain', 'outdated packages', 'SBOM', or needs to scan dependencies for vulnerabilities and upgrade risks. Do NOT use for application-level security (see owasp-top10) or secrets scanning (see secrets-scanner)."
---

# 📦 Dependency Audit — Vulnerability Scanning & Supply Chain Security
*Scan project dependencies for known vulnerabilities, abandoned packages, license risks, and supply chain threats with a prioritized remediation plan.*

## Activation

When this skill activates, output:

`📦 Dependency Audit — Scanning dependencies for vulnerabilities and supply chain risks...`

| Context | Status |
|---------|--------|
| **User says "dependency audit", "npm audit", "vulnerable packages"** | ACTIVE |
| **User mentions "supply chain", "outdated", "CVE"** | ACTIVE |
| **User wants SBOM generation or license compliance** | ACTIVE |
| **User wants application-level security review** | DORMANT — see owasp-top10 |
| **User wants secrets/credential scanning** | DORMANT — see secrets-scanner |
| **User wants HTTP security headers** | DORMANT — see csp-headers |

## Protocol

### Step 1: Identify Package Ecosystem

Detect the project's dependency management:

| File Found | Ecosystem | Audit Tool |
|------------|-----------|------------|
| `package.json` / `package-lock.json` | npm/Node.js | `npm audit`, `npx audit-ci` |
| `yarn.lock` | Yarn | `yarn audit` |
| `pnpm-lock.yaml` | pnpm | `pnpm audit` |
| `requirements.txt` / `Pipfile.lock` | Python/pip | `pip-audit`, `safety check` |
| `poetry.lock` | Python/Poetry | `pip-audit` (on exported requirements) |
| `Cargo.lock` | Rust | `cargo audit` |
| `go.sum` | Go | `govulncheck ./...` |
| `Gemfile.lock` | Ruby | `bundle audit check --update` |
| `composer.lock` | PHP | `composer audit` |
| `pubspec.lock` | Dart/Flutter | `dart pub outdated` |

```bash
# Auto-detect ecosystem
ls package*.json yarn.lock pnpm-lock.yaml requirements*.txt Pipfile* poetry.lock Cargo.lock go.sum Gemfile.lock composer.lock 2>/dev/null
```

### Step 2: Run Vulnerability Scan

**Node.js / npm:**
```bash
# Standard audit (shows all vulnerabilities)
npm audit

# JSON output for parsing
npm audit --json

# Production-only (skip devDependencies)
npm audit --omit=dev

# Fix automatically where possible
npm audit fix

# See what fix would do without applying
npm audit fix --dry-run
```

**Python / pip:**
```bash
# Install pip-audit
pip install pip-audit

# Scan requirements.txt
pip-audit -r requirements.txt

# Scan current environment
pip-audit

# JSON output
pip-audit --format=json -r requirements.txt

# With fix suggestions
pip-audit --fix --dry-run -r requirements.txt
```

**Rust / Cargo:**
```bash
# Install cargo-audit
cargo install cargo-audit

# Run audit
cargo audit

# JSON output
cargo audit --json

# Auto-fix where possible
cargo audit fix
```

**Go:**
```bash
# Built-in vulnerability checker
govulncheck ./...

# Verbose output
govulncheck -show verbose ./...
```

**Ruby:**
```bash
# Install bundler-audit
gem install bundler-audit

# Run audit
bundle audit check --update

# Scan for insecure sources
bundle audit check
```

**Multi-ecosystem scanner (Trivy):**
```bash
# Trivy scans any ecosystem from filesystem
trivy fs --scanners vuln .

# JSON output
trivy fs --scanners vuln --format json -o results.json .

# Filter by severity
trivy fs --scanners vuln --severity HIGH,CRITICAL .
```

### Step 3: Interpret CVSS Scores

**CVSS v3.1 Severity Scale:**

| Score | Severity | Action Required |
|-------|----------|----------------|
| 9.0 - 10.0 | 🔴 Critical | Fix immediately — active exploits likely exist |
| 7.0 - 8.9 | 🟠 High | Fix within 48 hours — high exploitation potential |
| 4.0 - 6.9 | 🟡 Medium | Fix within 1-2 weeks — exploitable under specific conditions |
| 0.1 - 3.9 | 🟢 Low | Fix in next maintenance cycle — minimal risk |

**Beyond CVSS — Real-World Risk Assessment:**

CVSS alone doesn't tell the full story. Evaluate each vulnerability with:

```
Is this vulnerability reachable in YOUR code?
├── Yes, in production code paths → Treat as stated CVSS severity
├── Yes, but only in dev/test tooling → Downgrade one level
├── No, the vulnerable function is never called → Downgrade two levels
└── Unknown / can't determine → Treat as stated severity
```

**EPSS (Exploit Prediction Scoring System):**
- Check if a CVE has known exploits: search the CVE ID at nvd.nist.gov
- EPSS > 0.5 = high probability of active exploitation → treat as Critical regardless of CVSS

### Step 4: Analyze Transitive Dependencies

Direct dependencies are only the surface. Most vulnerabilities hide in transitive (indirect) dependencies.

```bash
# npm — see full dependency tree
npm ls --all

# Find which direct dep pulls in a vulnerable transitive dep
npm ls <vulnerable-package>

# Python — show dependency tree
pip install pipdeptree
pipdeptree --reverse --packages <vulnerable-package>

# Rust
cargo tree -i <vulnerable-package>

# Go
go mod graph | grep <vulnerable-package>
```

**Decision tree for transitive vulnerabilities:**
```
Vulnerable package is transitive (indirect)?
├── Can the direct parent be updated to pull a fixed version?
│   └── Yes → Update the direct parent dependency
├── Can you override/force the transitive version?
│   ├── npm: Add "overrides" in package.json
│   ├── yarn: Add "resolutions" in package.json
│   ├── pip: Pin the transitive dep directly in requirements.txt
│   └── cargo: Add [patch] section in Cargo.toml
├── Can you replace the direct parent entirely?
│   └── Yes, if an alternative exists without the vulnerability
└── None of the above?
    └── Document the risk, monitor for fix, add to risk register
```

**npm overrides example:**
```json
{
  "overrides": {
    "vulnerable-pkg": ">=2.0.1"
  }
}
```

**yarn resolutions example:**
```json
{
  "resolutions": {
    "vulnerable-pkg": ">=2.0.1"
  }
}
```

### Step 5: Supply Chain Risk Assessment

Beyond known CVEs, assess supply chain health:

| Risk Factor | How to Check | Red Flag |
|-------------|-------------|----------|
| **Maintainer activity** | GitHub commits, releases | No commits in 12+ months |
| **Download trends** | npm trends, PyPI stats | Sudden spike (typosquatting?) or steady decline |
| **Maintainer count** | GitHub contributors | Single maintainer on critical package |
| **Install scripts** | `npm show <pkg> scripts` | `preinstall` or `postinstall` scripts doing unexpected things |
| **Package size** | `npm pack --dry-run` | Unexpectedly large (bundled binaries?) |
| **Typosquatting** | Manual name review | `lodash` vs `1odash`, `colors` vs `colour` |
| **Dependency count** | `npm ls --all \| wc -l` | 1000+ transitive deps = large attack surface |

**Supply chain attack patterns to watch for:**
1. **Typosquatting**: Packages with names similar to popular ones
2. **Dependency confusion**: Internal package name claimed on public registry
3. **Maintainer account takeover**: Legitimate package hijacked
4. **Star-jacking**: Fake GitHub stars to appear popular
5. **Protestware**: Maintainer intentionally adds malicious code (e.g., `colors` v1.4.1, `node-ipc`)

```bash
# Check for install scripts (npm)
npm show <package> scripts

# Check package size
npm pack <package> --dry-run

# Verify package checksum against registry
npm view <package> dist.integrity
```

### Step 6: License Compliance Scan

```bash
# npm — check all licenses
npx license-checker --summary
npx license-checker --failOn 'GPL-3.0;AGPL-3.0'

# Python
pip install pip-licenses
pip-licenses --format=table

# Comprehensive (any ecosystem)
trivy fs --scanners license .
```

**License compatibility quick reference:**

| License | Commercial Use | Copyleft Risk | Action |
|---------|---------------|---------------|--------|
| MIT, BSD, ISC, Apache-2.0 | ✅ Safe | None | No action needed |
| MPL-2.0 | ✅ Safe | File-level | Keep modified files under MPL |
| LGPL-2.1/3.0 | ⚠️ Depends | Library-level | OK if dynamically linked, risky if statically linked |
| GPL-2.0/3.0 | ❌ Risky | Full project | Entire project must be GPL if distributed |
| AGPL-3.0 | ❌ Risky | Network use | Even SaaS use triggers copyleft |
| Unlicensed / UNLICENSED | ❌ Risky | Unknown | No permission granted — replace immediately |

### Step 7: Generate SBOM (Software Bill of Materials)

```bash
# npm — CycloneDX format (industry standard)
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python
pip install cyclonedx-bom
cyclonedx-py environment -o sbom.json

# Trivy — any ecosystem
trivy fs --format cyclonedx -o sbom.json .

# SPDX format (alternative standard)
trivy fs --format spdx-json -o sbom-spdx.json .
```

### Step 8: Build Remediation Plan

For each vulnerability found, document:

```
VULN: CVE-YYYY-NNNNN
  Package: <name>@<version>
  Severity: [Critical/High/Medium/Low] (CVSS X.X)
  Direct/Transitive: [Direct | Transitive via <parent>]
  Reachable: [Yes/No/Unknown]
  Fix Available: [Yes → <version> | No]
  Remediation: [Update/Override/Replace/Accept Risk]
  Effort: [Minutes/Hours/Days]
  Priority: [P1/P2/P3]
```

**Remediation decision tree:**
```
Fix available?
├── Yes, minor/patch version bump
│   └── P1: Update immediately (low risk)
├── Yes, major version bump
│   ├── Breaking changes manageable? → P1: Schedule migration
│   └── Breaking changes extensive? → P2: Plan migration, document risk
├── No fix available
│   ├── Alternative package exists? → P2: Plan migration to alternative
│   ├── Vulnerability reachable? → P2: Add compensating controls (WAF rules, input validation)
│   └── Vulnerability not reachable? → P3: Monitor, accept risk with documentation
└── Package abandoned
    └── P1: Find replacement immediately — unmaintained deps accumulate vulnerabilities
```

### Step 9: Output

```
━━━ DEPENDENCY AUDIT REPORT ━━━━━━━━━━━━━━

── SCAN SUMMARY ──────────────────────────
Ecosystem: [npm/pip/cargo/go/etc.]
Total dependencies: [N] (direct: [X], transitive: [Y])
Vulnerabilities found: [N] (Critical: X, High: Y, Medium: Z, Low: W)

── CRITICAL & HIGH ───────────────────────
[detailed findings for Critical and High]

── MEDIUM & LOW ──────────────────────────
[summary table for Medium and Low]

── SUPPLY CHAIN HEALTH ───────────────────
[abandoned packages, single-maintainer risks, install scripts]

── LICENSE COMPLIANCE ────────────────────
[license summary, any copyleft risks]

── REMEDIATION PLAN ──────────────────────
P1 (Immediate): [list with commands]
P2 (This sprint): [list with migration notes]
P3 (Monitor): [list with risk acceptance]

── SBOM ──────────────────────────────────
Generated: sbom.json (CycloneDX format)
```

## Anti-Patterns

- **Running `npm audit fix --force` blindly**: Force-fixing can introduce breaking major version bumps. Always use `--dry-run` first.
- **Ignoring transitive vulnerabilities**: "It's not my direct dependency" doesn't mean it's not your problem. Your users are still affected.
- **Suppressing audit warnings permanently**: If you add an advisory to an ignore list, set a review date. Don't forget about it.
- **Only scanning in CI, never locally**: Developers should scan before committing, not just in the pipeline. Shift left.
- **Treating all CVSS scores equally**: A Critical vuln in an unused code path matters less than a Medium vuln in your authentication flow. Context matters.
- **Using `--no-audit` to make installs faster**: This disables the one check that might catch a compromised package.

## Escalation

Hand off to a security engineer when:
- A Critical CVE has known active exploits and affects your production code paths
- You suspect a supply chain compromise (unexpected code in a package update)
- License compliance issues could have legal implications (GPL in commercial software)
- The vulnerability requires understanding of cryptographic primitives to assess
- Remediation requires coordinated disclosure with the package maintainer

## Inputs
- Project root directory with lock file
- Package ecosystem (auto-detected)
- Environment context (production vs development)
- Compliance requirements (if any)

## Outputs
- Vulnerability scan results with CVSS scores and reachability analysis
- Supply chain health assessment
- License compliance report
- SBOM in CycloneDX or SPDX format
- Prioritized remediation plan with specific commands
- Risk register for accepted vulnerabilities

## Level History

- **Lv.1** — Base: Multi-ecosystem scanning (npm/pip/cargo/go/ruby/php), CVSS interpretation with reachability analysis, transitive dependency resolution, supply chain risk assessment, license compliance scanning, SBOM generation, prioritized remediation with decision trees. (Origin: MemStack v3.3, Mar 2026)
