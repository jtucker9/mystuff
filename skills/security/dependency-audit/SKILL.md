---
name: dependency-audit
description: "Scan dependencies for CVEs, supply chain threats, and license risks. WHEN: 'dependency audit', 'npm audit', 'pip audit', 'cargo audit', 'vulnerable packages', 'supply chain', 'SBOM', 'outdated packages'. NOT WHEN: app-level vulns (owasp-top10), secrets (secrets-scanner), HTTP headers (csp-headers)."
---

# Dependency Audit

Scan project dependencies for known vulnerabilities, abandoned packages, license risks, and supply chain threats. Produce a prioritized remediation plan.

## Activation

| Context | Status |
|---------|--------|
| "dependency audit", "npm audit", "vulnerable packages", "CVE" | ACTIVE |
| "supply chain", "outdated", "SBOM", "license compliance" | ACTIVE |
| Application-level security review | DORMANT -- see owasp-top10 |
| Secrets/credential scanning | DORMANT -- see secrets-scanner |
| HTTP security headers | DORMANT -- see csp-headers |

## Instructions

### Step 1: Detect ecosystem

Identify lock files in the project root. Supported: `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` (Node), `requirements.txt` / `Pipfile.lock` / `poetry.lock` (Python), `Cargo.lock` (Rust), `go.sum` (Go), `Gemfile.lock` (Ruby), `composer.lock` (PHP). Use the ecosystem's native audit tool; fall back to Trivy for multi-ecosystem or unsupported lock files.

**Gate:** At least one lock file found. If none, ask user to specify the project path or confirm the ecosystem.

### Step 2: Run vulnerability scan

Run the ecosystem audit tool in JSON mode. Scan production dependencies by default; include dev dependencies only if the user requests a full audit.

**Gate:** Audit tool exits without errors (non-zero exit from findings is expected; non-zero from tool failure is not). If the tool is missing, install it or fall back to Trivy.

### Step 3: Triage findings by real-world risk

CVSS severity thresholds and response times:

| CVSS | Severity | Response |
|------|----------|----------|
| 9.0-10.0 | Critical | Fix immediately |
| 7.0-8.9 | High | Fix within 48 hours |
| 4.0-6.9 | Medium | Fix within 1-2 weeks |
| 0.1-3.9 | Low | Next maintenance cycle |

CVSS alone is insufficient. Apply the reachability decision tree to each finding:

```
Exploitable (known exploit or EPSS > 0.5)?
+--> Yes --> Treat as Critical regardless of CVSS
+--> No
     Reachable in production code paths?
     +--> Yes --> Use stated CVSS severity
     +--> Dev/test only --> Downgrade one level
     +--> Unreachable (function never called) --> Downgrade two levels
     +--> Unknown --> Use stated severity
```

**Gate:** Every Critical and High finding has a reachability determination before proceeding to remediation.

### Step 4: Trace transitive dependencies

For each finding in a transitive (indirect) dependency, identify the direct parent that pulls it in. This determines remediation path.

**Gate:** Each transitive finding is traced to its direct parent dependency.

### Step 5: Assess supply chain health

Evaluate non-CVE supply chain risk for direct dependencies:

**Red flags:** No commits in 12+ months, single maintainer on critical package, unexpected install scripts, sudden download spikes (typosquatting), unexpectedly large package size (bundled binaries).

**Attack patterns to check:** Typosquatting, dependency confusion (internal name on public registry), maintainer account takeover, protestware.

### Step 6: Check license compliance

License risk levels:

| Risk | Licenses | Action |
|------|----------|--------|
| Safe | MIT, BSD, ISC, Apache-2.0 | None |
| Moderate | MPL-2.0, LGPL | Review linkage model |
| High | GPL-2.0/3.0 | Copyleft infects distributed project |
| Critical | AGPL-3.0 | Copyleft triggers on network/SaaS use |
| Unknown | Unlicensed / no license | No permission granted -- replace |

**Gate:** No Critical/High license risk without explicit user acknowledgment.

### Step 7: Build remediation plan

Remediation priority order (try each in sequence):

1. **Patch/update** -- minor/patch bump available, low breakage risk
2. **Update with migration** -- major bump, breaking changes manageable
3. **Replace** -- swap for maintained alternative without the vulnerability
4. **Mitigate** -- add compensating controls (WAF, input validation) when no fix exists
5. **Accept** -- document risk, set review date, add to risk register (unreachable + no fix)

For transitive vulnerabilities: update the direct parent first; override/resolution as second option; replace the parent as last resort.

### Step 8: Produce report

Output: scan summary (total deps, direct/transitive split, finding counts by severity), Critical/High detail, Medium/Low summary table, supply chain health flags, license compliance status, prioritized remediation plan (P1 immediate / P2 this sprint / P3 monitor). Generate SBOM in CycloneDX format if user requests it.

## Examples

**Example 1 -- Node project, Critical finding in transitive dep:**
Audit finds CVE in `nth-check@1.0.2` (CVSS 7.5), pulled in by `css-select` via `cheerio`. `cheerio` has a newer version that bumps `css-select` to a fixed `nth-check`. Remediation: update `cheerio` (direct dep), not override `nth-check`.

**Example 2 -- Python project, AGPL dependency discovered:**
`pip-licenses` reveals `mongodb-driver` using SSPL (AGPL-like). SaaS product cannot use this without open-sourcing. Remediation: replace with `motor` (Apache-2.0) or confirm licensing exception.

## Common Issues

- **Audit tool reports hundreds of findings:** Filter to production-only first (`--omit=dev`). Apply reachability analysis. Most noise comes from dev tooling.
- **Transitive dep can't be updated:** The direct parent hasn't released a fix. Use override/resolution as a temporary measure; set a calendar reminder to remove it when the parent updates.
- **Force-fix introduced breaking changes:** Never auto-apply major version bumps. Dry-run first, review breaking changes, then update with tests.

## Anti-Patterns

- Running force-fix blindly without dry-run -- introduces breaking major bumps
- Permanently ignoring advisories without a review date
- Treating all CVSS scores equally without reachability context
- Disabling audit in CI to speed up installs -- removes the one check that catches compromised packages
- Scanning only in CI, never locally -- shift left

## Escalation

Hand off to a security engineer when:
- Critical CVE with known active exploits affects production code paths
- Suspected supply chain compromise (unexpected code in package update)
- License compliance issues with legal implications (GPL/AGPL in commercial software)
- Vulnerability assessment requires cryptographic expertise
- Remediation requires coordinated disclosure with maintainer

## Inputs

- Project root with lock file (ecosystem auto-detected)
- Environment context: production vs full (default: production)
- Compliance requirements if applicable

## Outputs

- Vulnerability findings with CVSS, reachability, and remediation path
- Supply chain health flags
- License compliance status
- Prioritized remediation plan (P1/P2/P3)
- SBOM (CycloneDX, on request)

## CI Integration

Run the ecosystem audit tool as a CI step with a severity threshold gate (fail on Critical/High). Recommended audit frequency: every CI run for committed lock files, weekly scheduled scan for drift detection, immediate re-scan after any dependency update.

## Level History

- **Lv.1** -- Base: Multi-ecosystem scanning, CVSS interpretation with reachability analysis, transitive dependency resolution, supply chain risk assessment, license compliance scanning, SBOM generation, prioritized remediation with decision trees. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Creator-density rewrite. Removed CLI examples and YAML templates. Retained decision trees, severity thresholds, license risk matrix, supply chain indicators. Added validation gates between steps, CI integration concept. (Origin: MemStack v3.4, Mar 2026)
