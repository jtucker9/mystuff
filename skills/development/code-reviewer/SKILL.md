---
name: code-reviewer
description: "Structured severity-ranked code review across security, performance, maintainability, and architecture. Activate on 'review code', 'code review', 'check my code', 'review PR', 'review changes', 'audit this'. Do NOT activate for refactoring plans (refactor-planner), test generation (test-writer), dedicated OWASP assessment (owasp-top10), or dependency vulnerability scanning (dependency-audit)."
---

# Code Reviewer

## Activation

| Context | Status |
|---------|--------|
| "review code/PR/changes", "check my code", "audit this", file/dir/PR pointed at for quality feedback | ACTIVE |
| Refactoring plan with migration steps | DORMANT -- refactor-planner |
| Test generation | DORMANT -- test-writer |
| Dedicated OWASP security assessment | DORMANT -- owasp-top10 |
| Dependency vulnerability scanning only | DORMANT -- dependency-audit |

Output on activation: `Code Reviewer -- Analyzing code quality...`

## Instructions

### Step 1: Determine Scope and Gather Inputs

Detect review type: PR (branch diff), file(s), directory, or inline code. Auto-detect language/framework from extensions and imports. Check for linter/formatter configs (`.eslintrc`, `tsconfig.json`, `pyproject.toml`, etc.) to understand enforced standards.

For PRs: `git diff --name-status main...HEAD`, `git diff main...HEAD`, `git log --oneline main...HEAD`, `git diff --stat main...HEAD`.

Optional user-specified overrides (ask only if ambiguous):
- **Focus areas**: `security`, `performance`, `maintainability`, `architecture`, or all (default).
- **Severity threshold**: minimum severity to report. Default `Low`. Use `Medium`+ for 500+ line diffs.

**Gate**: Scope must be resolved and files readable before proceeding.

### Step 2: Run Automated Checks

Run language-appropriate linters and type checkers before manual review. Record all output -- it feeds the final report.

If dependency manifests changed (`package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`), diff the manifest and run vulnerability audit (`npm audit`, `pip audit`, etc.).

If test infrastructure exists, run coverage against changed files only.

**Gate**: Automated check output captured. Linter/type errors catalogued as findings.

### Step 3: Security Review

Examine for vulnerabilities. Map each finding to its OWASP Top 10 (2021) category.

Priority scan order:
1. **Injection (A03)**: String interpolation in SQL/shell/template contexts. `eval()`, `Function()`, `pickle.loads()`, `yaml.load()` on untrusted input.
2. **Broken Access Control (A01)**: Routes missing auth middleware. IDOR -- resource accessed by ID without ownership check. Role checks only on client side. CORS wildcards.
3. **Cryptographic Failures (A02)**: Hardcoded secrets, API keys in source. Secrets in client-side env vars (`NEXT_PUBLIC_*SECRET*`). Weak hashing (MD5/SHA1 for passwords).
4. **Insecure Design (A04)**: No rate limiting on auth endpoints. No account lockout.
5. **Security Misconfiguration (A05)**: Debug mode in production config. Verbose error responses leaking stack traces. Default credentials.
6. **Data Integrity (A08)**: Unsigned CI actions. Deserialization of untrusted data.
7. **SSRF (A10)**: User-supplied URLs fetched server-side without allowlist.

**Gate**: All security findings have OWASP category, severity, and file:line reference.

### Step 4: Performance Review

Scan for these red flags in priority order:

1. **N+1 queries**: ORM calls inside loops. `findMany`/`findAll` without `include`/`join`/`populate`. Any `await` inside a `for` loop iterating query results.
2. **Memory leaks**: `addEventListener`/`.on()`/`.subscribe()`/`setInterval()` without corresponding cleanup. React `useEffect` missing cleanup return.
3. **Unnecessary re-renders** (frontend): Missing or wrong `useEffect` dependency arrays. Object/array literals in JSX props (breaks memoization). Large lists without virtualization. State stored too high in tree.
4. **Algorithmic complexity**: Nested loops on same dataset (O(n^2)). `.includes()`/`.indexOf()` on arrays inside loops (use Set). Sorting inside loops. Recursive functions without memoization or depth limit.
5. **Bundle size**: Barrel imports pulling entire libraries (`from 'lodash'` instead of `'lodash/debounce'`). Heavy components not lazy-loaded.

**Gate**: Each performance finding includes measurable impact description (query count, complexity class, or bundle size delta).

### Step 5: Maintainability Review

Assess:
1. **Coupling/cohesion**: Files 500+ lines with multiple responsibilities. Module importing internals of another module. Circular dependencies.
2. **DRY violations**: 5+ similar lines duplicated across files. Nearly identical functions differing by one parameter. Validation logic duplicated between client and server.
3. **Dead code**: Unused exports, commented-out code blocks (3+ consecutive lines), unreachable branches.
4. **Test coverage gaps**: Changed files without corresponding test files. Tests that call functions without asserting behavior. Missing edge case coverage (empty input, null, boundary values, error paths).
5. **Naming**: Cryptic variables, booleans without predicates (`status` vs `isActive`), misleading names, magic numbers, inconsistent conventions within the same project.

**Gate**: Each finding references specific files/lines, not general advice.

### Step 6: Architecture Review

Only applies when changes touch API boundaries, data models, or cross-module contracts.

1. **Breaking changes**: Renamed/removed API fields, changed response shapes, altered function signatures without defaults, DB column type changes, removed exports. Each breaking change needs a migration path (alias + deprecation, API versioning, two-step migration).
2. **API contract integrity**: Types/interfaces match implementation. OpenAPI specs updated. DB migrations are reversible (has `down`).
3. **Separation of concerns**: Business logic in controllers/views (extract to service). Data fetching in presentational components (lift to container/hook). DB queries in route handlers (extract to repository).
4. **Backward compatibility**: If breaking changes exist, suggest the smallest backward-compatible alternative first (add new field alongside old, deprecate).

**Gate**: All breaking changes flagged with specific migration recommendation.

### Step 7: Compile Findings Report

Classify every finding by severity:

| Level | Label | Criteria | Response |
|-------|-------|----------|----------|
| Critical | Data loss, security breach, crash in prod, auth bypass | Block merge -- fix immediately |
| High | Significant bugs, race conditions, data corruption risk, injection vectors | Fix before merge |
| Medium | Performance regressions, missing validation, weak error handling, logic gaps | Fix this sprint |
| Low | Style inconsistencies, naming, missing docs, suboptimal patterns | Fix when convenient |
| Info | Praise for good patterns, alternative approaches, FYI notes | No action required |

**Report structure**:
1. Scope summary (review type, files reviewed, lines changed, languages).
2. Findings count by severity.
3. Verdict: `BLOCK` (any Critical) / `APPROVE WITH COMMENTS` (High or Medium exist) / `APPROVE`.
4. Findings table: `# | Severity | Category | File:Line | Finding | Suggestion`.
5. Detailed write-up for each Critical and High finding: description, current code snippet, suggested fix, impact.
6. Positive observations section -- good patterns reinforce good habits.

For PR reviews, also produce a GitHub-ready comment (severity-grouped, pasteable).

## Examples

**Example 1**: User says "review this PR" on a 12-file Next.js changeset.
Detected scope: PR diff against main. Auto-detected TypeScript/React. Ran `eslint`, `tsc --noEmit`. Manual review found 1 Critical (unauthed DELETE route), 2 Medium (useEffect missing cleanup, unbounded SELECT). Verdict: BLOCK. Report included OWASP A01 mapping and fix for auth middleware.

**Example 2**: User says "check my code" pointing at `src/services/billing.py`.
Single-file Python review. Ran `ruff`, `mypy`. Found 1 High (subprocess with `shell=True` on user input -- A03 Injection), 1 Low (bare `except:`). Verdict: APPROVE WITH COMMENTS. Suggested `subprocess.run([...], shell=False)` with argument list.

## Common Issues

- **Linter not installed**: Skip automated checks, note in report that manual-only review was performed. Do not block on tooling.
- **PR against non-main base**: Ask user for correct base branch before diffing. Wrong base = wrong diff = wrong review.
- **Monorepo with multiple languages**: Run language-specific checks per directory. Do not apply Python linters to TypeScript files.

## Anti-Patterns

- Approving without reading the code (rubber stamp). Every finding, even Info, proves the code was read.
- Stylistic nitpicking on 500+ line PRs. Focus on Critical/High/Medium; save Low/Info for small PRs.
- Reviewing only the diff without reading surrounding code. A 3-line change can break a 300-line function.
- Suggesting full rewrites instead of incremental fixes. Rewrites belong in refactor-planner.
- Ignoring test file changes. Test code is production code.
- Conflating opinion with defect. "I would do it differently" is not a finding. Findings must be objective: bug, vulnerability, measurable perf issue, or convention violation.
- Skipping PR description, linked issue, and commit messages. Context explains intent; intent guides the review.

## Escalation

- **Security**: Cryptographic implementations, auth protocol design, or compliance (PCI-DSS, HIPAA, SOC 2) -- escalate to security engineer.
- **Performance**: Requires load testing, production-scale profiling, or query plan analysis -- escalate to performance engineer/DBA.
- **Architecture**: Multi-service changes, altered data flow between bounded contexts, new infrastructure dependencies -- escalate to principal/staff engineer.
- **Domain logic**: Business rules ambiguous or reviewer lacks domain context -- escalate to product owner/domain expert.

## Inputs

- Code to review: PR number, branch diff, file paths, directory, or inline code.
- Language/framework: auto-detected or user-specified.
- Focus areas: security, performance, maintainability, architecture, or all (default).
- Severity threshold: minimum severity to report (default: Low).
- Project conventions: linter configs, style guides, architectural patterns (auto-detected from repo).

## Outputs

- Severity-ranked findings table with file:line references.
- Detailed write-up for each Critical/High finding (current code, fix, impact).
- OWASP category on all security findings.
- Positive observations section.
- Verdict: BLOCK / APPROVE WITH COMMENTS / APPROVE.
- GitHub PR comment (pasteable) when reviewing a PR.

## Level History

- **Lv.1** -- Base: 7-step review protocol, 5-tier severity classification, OWASP-mapped security review, performance red flags (N+1, re-renders, memory leaks, complexity, bundle size), maintainability (naming, coupling, DRY, dead code, coverage gaps), architecture (breaking changes, API contracts, backward compatibility), anti-patterns, escalation matrix, report format. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Removed tutorial code, language-specific checklists, and example review comments. Added validation gates between steps, terse examples, common issues. Creator-level density rewrite. (Origin: MemStack v3.4, Mar 2026)
