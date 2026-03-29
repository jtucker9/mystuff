---
name: code-reviewer
description: "Use when the user says 'review code', 'code review', 'check my code', 'review PR', 'review changes', or is requesting a structured review of code quality, security, performance, or maintainability. Do NOT use for refactoring plans (see refactor-planner) or test generation (see test-writer)."
---

# 🔍 Code Reviewer — Structured Code Quality Assessment
*Perform a systematic, severity-ranked code review across security, performance, maintainability, and architecture — with actionable findings, file:line references, and fix suggestions.*

## Activation

When this skill activates, output:

`🔍 Code Reviewer — Analyzing code quality...`

| Context | Status |
|---------|--------|
| **User says "review code", "code review", "check my code"** | ACTIVE |
| **User says "review PR", "review changes", "review this diff"** | ACTIVE |
| **User says "what's wrong with this code", "audit this"** | ACTIVE |
| **User points at a file, directory, or PR and asks for quality feedback** | ACTIVE |
| **User wants a refactoring plan with migration steps** | DORMANT — see refactor-planner |
| **User wants tests generated for existing code** | DORMANT — see test-writer |
| **User wants a dedicated security assessment (OWASP)** | DORMANT — see owasp-top10 |
| **User wants dependency vulnerability scanning only** | DORMANT — see dependency-audit |

## Severity Classification

Every finding is assigned one of five severity levels:

| Level | Label | Criteria | Response Time |
|-------|-------|----------|---------------|
| 🔴 | **Critical** | Data loss, security breach, crash in production, auth bypass | Block merge — fix immediately |
| 🟠 | **High** | Significant bugs, race conditions, data corruption risk, injection vectors | Fix before merge |
| 🟡 | **Medium** | Performance regressions, missing validation, weak error handling, logic gaps | Fix this sprint |
| 🟢 | **Low** | Style inconsistencies, minor naming issues, missing docs, suboptimal patterns | Fix when convenient |
| 🔵 | **Info** | Suggestions, praise for good patterns, alternative approaches, FYI notes | No action required |

## Protocol

### Step 1: Gather Inputs

Determine the review scope. Ask the user if any of these are unclear:

- **Scope**: What to review — one of:
  - **PR review**: a pull request number or branch diff (`git diff main...HEAD`)
  - **File review**: one or more specific files
  - **Directory review**: an entire module or directory tree
  - **Clipboard/inline**: code pasted directly into the conversation
- **Language/framework**: Auto-detect from file extensions and imports, confirm with user
- **Review focus areas** (optional — default is all):
  - `security` — injection, auth, secrets, OWASP mapping
  - `performance` — queries, rendering, memory, complexity, bundle size
  - `maintainability` — naming, coupling, DRY, dead code, test coverage
  - `architecture` — separation of concerns, API contracts, breaking changes
- **Severity threshold** (optional — default `Low`): minimum severity to report. Set to `Medium` or `High` for large diffs to reduce noise.
- **Project conventions**: Check for `.eslintrc`, `tsconfig.json`, `.prettierrc`, `pyproject.toml`, `Cargo.toml`, `.editorconfig`, or equivalent config files to understand enforced standards.

**For PR reviews**, gather the full changeset:

```bash
# See all changed files in the PR
git diff --name-status main...HEAD

# Get the full diff
git diff main...HEAD

# Check commit messages for context
git log --oneline main...HEAD

# Count lines changed (scale gauge)
git diff --stat main...HEAD
```

**For file/directory reviews**, read the files and gather context:

```bash
# For a directory, list the structure
find src/components -type f -name "*.tsx" | head -50

# Identify test files that correspond to source files
find . -name "*.test.*" -o -name "*.spec.*" | head -30
```

### Step 2: Automated Checks

Run language-appropriate linting and type checking before manual review. This catches low-hanging fruit and lets the manual review focus on logic and design.

#### JavaScript / TypeScript

```bash
# Lint with project config (respect existing rules)
npx eslint --no-error-on-unmatched-pattern --format compact <files-or-dirs> 2>&1 | tail -30

# Type check (TypeScript only)
npx tsc --noEmit --pretty 2>&1 | tail -30

# Check for unused dependencies
npx depcheck --skip-missing 2>&1 | head -20
```

#### Python

```bash
# Lint + type check
python -m ruff check <files-or-dirs> 2>&1 | tail -30
python -m mypy <files-or-dirs> --ignore-missing-imports 2>&1 | tail -30

# Import sorting
python -m isort --check-only --diff <files-or-dirs> 2>&1 | head -20
```

#### Go

```bash
go vet ./... 2>&1 | tail -20
staticcheck ./... 2>&1 | tail -20
```

#### Rust

```bash
cargo clippy --all-targets -- -W clippy::all 2>&1 | tail -30
```

#### Test coverage delta (if CI available)

```bash
# Node
npx jest --coverage --changedSince=main --coverageReporters=text-summary 2>&1 | tail -10

# Python
python -m pytest --co -q <changed-files> 2>&1 | head -20
```

#### Dependency changes

If `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, or equivalent changed:

```bash
# Node: check what changed
git diff main...HEAD -- package.json | head -40

# Check for known vulnerabilities in new deps
npm audit --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Vulnerabilities: {d.get(\"metadata\",{}).get(\"vulnerabilities\",{})}')" 2>/dev/null
```

**Record all automated findings.** They feed into the final report alongside manual findings.

### Step 3: Security Review

Examine the code for security vulnerabilities. Map findings to OWASP Top 10 categories where applicable.

#### 3a: Injection Vulnerabilities

```bash
# SQL injection — string interpolation in queries
grep -rn 'query.*`\|execute.*f"\|execute.*%' --include="*.py" --include="*.js" --include="*.ts" <scope>

# Command injection
grep -rn 'exec(\|execSync\|child_process\|os\.system\|subprocess\.call\|popen' --include="*.py" --include="*.js" --include="*.ts" <scope>

# XSS via dangerouslySetInnerHTML or v-html
grep -rn 'dangerouslySetInnerHTML\|v-html\|innerHTML\s*=' --include="*.tsx" --include="*.jsx" --include="*.vue" <scope>
```

**Example finding:**
```javascript
// ❌ VULNERABLE — SQL injection via template literal
const user = await db.query(`SELECT * FROM users WHERE id = '${req.params.id}'`);

// ✅ FIXED — parameterized query
const user = await db.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
```

#### 3b: Authentication and Authorization Bypasses

```bash
# Endpoints missing auth middleware
grep -rn 'router\.\(get\|post\|put\|delete\|patch\)' --include="*.ts" --include="*.js" <scope> | grep -v 'auth\|protect\|guard\|middleware\|session'

# Direct object references without ownership checks
grep -rn 'params\.id\|params\.userId' --include="*.ts" --include="*.js" <scope> | grep -v 'req\.user\|session\|auth\.uid'
```

Look for:
- Routes that skip authentication middleware
- IDOR vulnerabilities (accessing resources by ID without ownership check)
- Role checks performed only on the client side
- JWT tokens accepted without signature verification
- Admin endpoints exposed without role verification

#### 3c: Secret Exposure

```bash
# Hardcoded secrets, API keys, tokens
grep -rn 'API_KEY\|SECRET_KEY\|password\s*=\s*["\x27]\|token\s*=\s*["\x27]' --include="*.ts" --include="*.js" --include="*.py" <scope> | grep -v '\.env\|process\.env\|os\.environ\|config\.'

# Secrets in client-side code
grep -rn 'NEXT_PUBLIC_.*SECRET\|VITE_.*KEY\|REACT_APP_.*TOKEN' --include="*.ts" --include="*.tsx" --include="*.js" <scope>
```

#### 3d: Unsafe Deserialization

```bash
# Dangerous deserialization
grep -rn 'pickle\.load\|yaml\.load(\|eval(\|Function(\|unserialize(' --include="*.py" --include="*.js" --include="*.ts" --include="*.php" <scope>
```

**Example finding:**
```python
# ❌ VULNERABLE — arbitrary code execution via pickle
data = pickle.loads(request.body)

# ✅ FIXED — use JSON or safe deserialization
data = json.loads(request.body)
```

#### 3e: OWASP Mapping

For each security finding, note the OWASP Top 10 (2021) category:

| Code | Category | Common Triggers |
|------|----------|-----------------|
| A01 | Broken Access Control | Missing auth middleware, IDOR, CORS misconfiguration |
| A02 | Cryptographic Failures | Weak hashing, plaintext secrets, missing HTTPS |
| A03 | Injection | SQL/command/template injection via string concat |
| A04 | Insecure Design | No rate limiting, no account lockout |
| A05 | Security Misconfiguration | Debug mode in prod, verbose errors, default creds |
| A07 | Auth Failures | Weak passwords accepted, no session expiry |
| A08 | Data Integrity | eval(), pickle, unsigned CI actions |
| A10 | SSRF | User-supplied URLs fetched server-side |

### Step 4: Performance Review

#### 4a: N+1 Queries

```bash
# ORM queries inside loops
grep -rn -A3 'for.*\(await\|\.find\|\.query\|\.get\|\.fetch\)' --include="*.ts" --include="*.js" --include="*.py" <scope>

# Prisma/Sequelize/TypeORM without includes/joins
grep -rn 'findMany\|findAll' --include="*.ts" --include="*.js" <scope> | grep -v 'include\|join\|relations\|populate'
```

**Example finding:**
```typescript
// ❌ N+1 — one query per user in the loop
const posts = await prisma.post.findMany();
for (const post of posts) {
  const author = await prisma.user.findUnique({ where: { id: post.authorId } });
  // 1 + N queries
}

// ✅ FIXED — eager loading
const posts = await prisma.post.findMany({
  include: { author: true },
  // 1 query with JOIN
});
```

#### 4b: Unnecessary Re-renders (React/Vue/Svelte)

```bash
# Missing dependency arrays in useEffect
grep -rn 'useEffect.*(\s*()' --include="*.tsx" --include="*.jsx" <scope>

# New objects/arrays created in render (break referential equality)
grep -rn 'style=\{\{' --include="*.tsx" --include="*.jsx" <scope>

# Missing React.memo on expensive list item components
grep -rn 'export default function\|export const' --include="*.tsx" <scope> | grep -i 'item\|card\|row'
```

Look for:
- `useEffect` with missing or incorrect dependency arrays
- Object/array literals created inside render (causes re-renders of memoized children)
- Large lists rendered without virtualization (react-window, @tanstack/virtual)
- State stored too high in the component tree (causes cascading re-renders)
- Missing `useMemo`/`useCallback` for expensive computations or callback props

#### 4c: Memory Leaks

```bash
# Event listeners without cleanup
grep -rn 'addEventListener\|\.on(' --include="*.ts" --include="*.js" <scope> | grep -v 'removeEventListener\|\.off(\|cleanup\|dispose'

# Subscriptions without unsubscribe
grep -rn '\.subscribe(' --include="*.ts" --include="*.js" <scope> | grep -v 'unsubscribe\|cleanup\|dispose\|return'

# setInterval without clearInterval
grep -rn 'setInterval(' --include="*.ts" --include="*.js" <scope> | grep -v 'clearInterval\|cleanup\|dispose'
```

**Example finding:**
```typescript
// ❌ MEMORY LEAK — interval never cleared
useEffect(() => {
  setInterval(() => fetchData(), 5000);
}, []);

// ✅ FIXED — cleanup on unmount
useEffect(() => {
  const id = setInterval(() => fetchData(), 5000);
  return () => clearInterval(id);
}, []);
```

#### 4d: Algorithmic Complexity

Look for:
- Nested loops over the same or related datasets (O(n^2) or worse)
- Array methods chained without early termination (`.filter().map().find()` when `.find()` alone suffices)
- Repeated `.includes()` or `.indexOf()` on arrays (should be a `Set`)
- Sorting inside loops
- Recursive functions without memoization or depth limits

**Example finding:**
```javascript
// ❌ O(n*m) — linear search repeated for each item
const matches = users.filter(u => ids.includes(u.id));

// ✅ O(n+m) — Set lookup is O(1)
const idSet = new Set(ids);
const matches = users.filter(u => idSet.has(u.id));
```

#### 4e: Bundle Size Impact

If the review involves frontend code with new dependencies:

```bash
# Check package sizes (requires npx)
npx bundlephobia-cli <package-name> 2>/dev/null

# Look for barrel imports pulling in entire libraries
grep -rn "from ['\"]lodash['\"]" --include="*.ts" --include="*.tsx" <scope>
# Should be: import debounce from 'lodash/debounce'

# Dynamic imports missing for heavy components
grep -rn "import.*Modal\|import.*Chart\|import.*Editor\|import.*Map" --include="*.tsx" --include="*.ts" <scope> | grep -v 'lazy\|dynamic\|import('
```

### Step 5: Maintainability Review

#### 5a: Naming and Readability

| Issue | Example | Fix |
|-------|---------|-----|
| **Cryptic variable names** | `const d = getData()` | `const dashboardMetrics = getData()` |
| **Boolean without predicate** | `const status = true` | `const isActive = true` |
| **Misleading names** | `getUserData()` returns HTML | Rename to `renderUserProfile()` |
| **Inconsistent conventions** | `getUserById` + `fetch_all_users` | Pick one: camelCase or snake_case |
| **Magic numbers** | `if (retries > 3)` | `const MAX_RETRIES = 3` |
| **Negated booleans** | `if (!isNotDisabled)` | `if (isEnabled)` |

#### 5b: Coupling and Cohesion

Look for:
- **High coupling**: Module A imports internals of Module B (not its public API). Changes to B break A.
- **Low cohesion**: A single file/class handles unrelated concerns (e.g., user auth + email sending + PDF generation).
- **Circular dependencies**: Module A imports from B, B imports from A.
- **God objects/files**: Files exceeding 500+ lines with multiple responsibilities.

```bash
# Find large files (potential god objects)
find <scope> -name "*.ts" -o -name "*.js" -o -name "*.py" | xargs wc -l | sort -rn | head -15

# Circular dependency detection (Node)
npx madge --circular --extensions ts,js <scope> 2>/dev/null | head -20
```

#### 5c: DRY Violations

Look for:
- Copy-pasted blocks of 5+ similar lines across files
- Nearly identical functions that differ by one parameter
- Duplicated validation logic (client and server not sharing schemas)
- Repeated error handling patterns that should be middleware

```bash
# Find duplicate code blocks (requires jscpd)
npx jscpd --min-lines 5 --min-tokens 50 --reporters consoleFull <scope> 2>/dev/null | tail -30
```

#### 5d: Dead Code

```bash
# Unused exports (TypeScript)
npx ts-prune <scope> 2>/dev/null | grep -v '(used in module)' | head -20

# Unused imports (caught by most linters, but verify)
grep -rn '^import' --include="*.ts" --include="*.tsx" <scope> | head -40

# Commented-out code blocks (3+ consecutive commented lines)
grep -rn -B1 -A1 '^[[:space:]]*//' --include="*.ts" --include="*.js" <scope> | head -30
```

#### 5e: Test Coverage Gaps

For each changed file, check if corresponding tests exist:

```bash
# For src/services/auth.ts, look for:
# - src/services/auth.test.ts
# - src/services/__tests__/auth.ts
# - tests/services/auth.test.ts
# - test/auth.spec.ts

find . -name "*.test.*" -o -name "*.spec.*" | sort
```

Assess coverage quality, not just presence:
- Are edge cases tested (empty input, null, boundary values)?
- Are error paths tested (network failures, validation errors)?
- Are tests actually asserting behavior (not just calling functions)?
- Do tests verify behavior or implementation details?

### Step 6: Architecture Review

#### 6a: Separation of Concerns

Check that the code follows the project's architectural patterns:

| Pattern | Violation | Fix |
|---------|-----------|-----|
| **MVC / MVVM** | Business logic in the controller/view | Extract to service layer |
| **Clean Architecture** | Domain entities importing infrastructure | Invert the dependency |
| **Component model** | Data fetching inside presentational components | Lift to container or use hooks |
| **API routes** | Database queries directly in route handlers | Extract to repository/service |

#### 6b: API Contract Changes

If the PR changes API endpoints, request/response shapes, or database schemas:

```bash
# Check for changed API routes
git diff main...HEAD -- "*/routes/*" "*/api/*" "**/controller*" "*/handlers/*"

# Check for changed types/interfaces
git diff main...HEAD -- "*/types/*" "*/interfaces/*" "*/models/*" "**/schema*"

# Check for changed DB migrations
git diff main...HEAD -- "*/migrations/*" "**/migrate*"
```

Verify:
- Are the changes backward-compatible?
- Is API versioning in place if breaking changes are introduced?
- Are TypeScript types / OpenAPI specs updated to match implementation?
- Are database migrations reversible (has a `down` migration)?

#### 6c: Breaking Changes

Flag anything that changes public-facing behavior:

| Change Type | Breaking? | Mitigation |
|-------------|-----------|------------|
| Renamed API field | Yes | Add alias, deprecate old name |
| Removed endpoint | Yes | Version the API, keep old endpoint |
| Changed response shape | Yes | Add new field alongside old, deprecate |
| Changed function signature | Depends | Default parameters preserve compat |
| Changed DB column type | Yes | Two-step migration: add new → migrate → remove old |
| Removed exported function | Yes | Export under old name with deprecation warning |

#### 6d: Backward Compatibility

If breaking changes are found, recommend a migration path:

```typescript
// ❌ BREAKING — removed the old field
interface UserResponse {
  fullName: string;  // was: name
}

// ✅ BACKWARD COMPATIBLE — deprecated alias
interface UserResponse {
  fullName: string;
  /** @deprecated Use fullName instead. Will be removed in v3.0 */
  name: string;
}
```

### Step 7: Findings Report

Compile all findings into a severity-ranked report.

#### Report Format

```
━━━ CODE REVIEW REPORT ━━━━━━━━━━━━━━━━━━━━

── SCOPE ─────────────────────────────────
Review type: [PR #N / File / Directory]
Files reviewed: [N]
Lines changed: [+X / -Y]
Languages: [TypeScript, Python, ...]

── SUMMARY ───────────────────────────────
Total findings: [N]
  🔴 Critical: [X]
  🟠 High: [Y]
  🟡 Medium: [Z]
  🟢 Low: [W]
  🔵 Info: [V]

Verdict: [BLOCK — critical issues found / APPROVE WITH COMMENTS / APPROVE]

── FINDINGS ──────────────────────────────
```

#### Findings Table

| # | Severity | Category | File:Line | Finding | Suggestion |
|---|----------|----------|-----------|---------|------------|
| 1 | 🔴 Critical | Security | `src/api/users.ts:42` | SQL injection via template literal | Use parameterized query |
| 2 | 🟠 High | Performance | `src/hooks/useData.ts:18` | N+1 query inside useEffect loop | Use `include` for eager loading |
| 3 | 🟡 Medium | Maintainability | `src/utils/helpers.ts:95` | 30-line function duplicated in 3 files | Extract shared utility |
| 4 | 🟢 Low | Style | `src/components/Card.tsx:12` | Prop `data` should be more descriptive | Rename to `dashboardMetrics` |
| 5 | 🔵 Info | Architecture | `src/services/auth.ts:1` | Clean separation of auth logic | Good pattern — keep it |

#### Detailed Findings

For each finding, provide:

```markdown
### Finding #1: SQL injection via string interpolation

**Severity:** 🔴 Critical
**Category:** Security (OWASP A03: Injection)
**Location:** `src/api/users.ts:42`

**Description:**
User input from `req.params.id` is interpolated directly into a SQL query string,
allowing an attacker to execute arbitrary SQL.

**Current code:**
```typescript
const user = await db.query(`SELECT * FROM users WHERE id = '${req.params.id}'`);
```

**Suggested fix:**
```typescript
const user = await db.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
```

**Impact:** An attacker can read, modify, or delete any data in the database.
```

#### Praise Section

Always include positive observations. Recognizing good patterns reinforces them:

```
── GOOD PATTERNS OBSERVED ────────────────
✅ Consistent error handling middleware across all API routes
✅ Input validation with Zod schemas at API boundary
✅ Comprehensive test coverage for auth flows (92%)
✅ Clean separation between data access and business logic
✅ Proper use of database transactions for multi-step operations
```

#### GitHub PR Comment Format

When reviewing a GitHub PR, format findings as PR review comments:

```markdown
## 🔍 Code Review

**Verdict: APPROVE WITH COMMENTS** (0 critical, 2 high, 3 medium, 1 low)

### 🔴 Critical
None

### 🟠 High
1. **N+1 query in user loader** (`src/loaders/users.ts:34`)
   The `getPostsByUser` call inside the loop generates O(n) queries. Use DataLoader or eager loading.

2. **Missing auth check on DELETE endpoint** (`src/routes/items.ts:87`)
   The `DELETE /api/items/:id` route has no `authenticate` middleware, allowing unauthenticated deletion.

### 🟡 Medium
1. **useEffect missing cleanup** (`src/hooks/useWebSocket.ts:12`)
   WebSocket connection is opened but never closed on unmount. Add cleanup function.

2. **Unbounded query results** (`src/api/search.ts:23`)
   `SELECT *` with no `LIMIT` — could return millions of rows. Add pagination.

3. **Error swallowed silently** (`src/services/payment.ts:56`)
   `catch (e) {}` hides payment processing errors. Log and re-throw or handle explicitly.

### 🟢 Low
1. **Magic number** (`src/utils/retry.ts:8`)
   `if (attempts > 3)` — extract to `const MAX_RETRY_ATTEMPTS = 3`.

### ✅ Good patterns
- Clean use of repository pattern in `src/repositories/`
- Comprehensive Zod validation on all API inputs
- Meaningful commit messages that explain *why*
```

## Review Checklists by Language

### TypeScript / JavaScript

| Area | Check |
|------|-------|
| Types | No `any` unless justified with comment. Prefer `unknown` for truly unknown types. |
| Null safety | Optional chaining (`?.`) used consistently. No unchecked `.property` on nullable values. |
| Async | All promises awaited or explicitly fire-and-forget with `void`. No floating promises. |
| Error handling | `try/catch` around async operations. Errors logged with context, not swallowed. |
| Imports | No circular imports. Barrel files don't re-export everything. Tree-shaking friendly. |
| React hooks | Dependency arrays correct. Custom hooks follow `use` prefix. Cleanup in effects. |
| API boundaries | Request/response validated with Zod/Joi/yup. Never trust client input. |

### Python

| Area | Check |
|------|-------|
| Type hints | Functions have parameter and return type annotations. `mypy` passes. |
| Exception handling | Bare `except:` avoided. Specific exceptions caught. Context preserved in re-raises. |
| Resource management | Files, connections, locks use `with` statements (context managers). |
| Imports | No wildcard imports (`from x import *`). Imports at top of file. |
| Async | `async def` functions actually use `await`. No sync I/O in async context. |
| Data validation | Pydantic models or dataclasses for structured data. No raw `dict` APIs. |
| Security | `subprocess` uses argument lists (no `shell=True`). No `eval()` or `pickle.loads()` on user data. |

### Go

| Area | Check |
|------|-------|
| Error handling | Every error checked (`if err != nil`). No ignored return values. |
| Goroutines | Goroutines have termination conditions. No goroutine leaks. Channels closed by sender. |
| Interfaces | Interfaces accepted, structs returned. Small interfaces (1-3 methods). |
| Context | `context.Context` passed through call chains. Timeouts set on external calls. |
| Concurrency | Shared state protected by mutex or channels. No data races (`go test -race`). |
| Resource cleanup | `defer` used for cleanup. Deferred calls checked for error return. |

### Rust

| Area | Check |
|------|-------|
| Ownership | No unnecessary `.clone()`. Borrows preferred over moves where logical. |
| Error handling | `?` operator used. Custom error types with `thiserror`. No `.unwrap()` in library code. |
| Unsafe | Every `unsafe` block has a `// SAFETY:` comment explaining invariants. Minimized scope. |
| Concurrency | `Send` + `Sync` bounds correct. No data races. `Arc<Mutex<T>>` used appropriately. |
| Lifetimes | Explicit lifetimes only where required. Elision used where possible. |

## Anti-Patterns

- **Rubber stamp reviews**: Approving without reading the code. Every finding, even Info-level, means the code was actually read.
- **Stylistic nitpicking on large PRs**: When the PR is 500+ lines, focus on Critical/High/Medium. Save Low/Info for small PRs where they matter more.
- **Reviewing only the diff, not the context**: A 3-line change can break a 300-line function. Always read surrounding code to understand the impact.
- **Suggesting rewrites instead of incremental fixes**: Unless the code is fundamentally broken, suggest the smallest change that fixes the issue. Rewrites belong in refactor-planner.
- **Ignoring test changes**: Test code is production code. Review it for correctness, meaningful assertions, and coverage of edge cases.
- **Conflating opinion with defect**: "I would have done it differently" is not a finding. Findings must be objective: a bug, a vulnerability, a measurable performance issue, or a violation of project conventions.
- **Drive-by review without context**: Not reading the PR description, linked issue, or commit messages before reviewing. Context explains intent — intent guides the review.

## Escalation

Hand off to a specialist when:
- **Security**: Findings involve cryptographic implementations, authentication protocol design, or compliance requirements (PCI-DSS, HIPAA, SOC 2). Escalate to a security engineer.
- **Performance**: Findings require load testing, profiling under production-scale data, or database query plan analysis. Escalate to a performance engineer or DBA.
- **Architecture**: Changes affect multiple services in a distributed system, alter data flow between bounded contexts, or introduce new infrastructure dependencies. Escalate to a principal/staff engineer.
- **Domain logic**: Business rules are ambiguous or the reviewer lacks domain context to assess correctness. Escalate to the product owner or domain expert.
- **Legal/compliance**: Code handles regulated data (health records, financial transactions, PII under GDPR). Escalate to compliance team.

## Inputs

- Code to review (PR number, branch diff, file paths, directory, or inline code)
- Language and framework (auto-detected or user-specified)
- Review focus areas (security, performance, maintainability, architecture — or all)
- Severity threshold (minimum severity to report — default: Low)
- Project conventions (linter configs, style guides, architectural patterns)

## Outputs

- Severity-ranked findings table with file:line references
- Detailed write-up for each Critical and High finding with current code, suggested fix, and impact
- OWASP category mapping for security findings
- Praise section highlighting good patterns
- Verdict: BLOCK / APPROVE WITH COMMENTS / APPROVE
- GitHub PR comment (ready to paste) when reviewing a PR
- Language-specific checklist results

## Level History

- **Lv.1** — Base: Full 7-step review protocol (gather inputs, automated checks, security, performance, maintainability, architecture, findings report). 5-tier severity classification with response times. Security review covers injection, auth bypass, secret exposure, unsafe deserialization, OWASP mapping. Performance review covers N+1 queries, re-renders, memory leaks, algorithmic complexity, bundle size. Maintainability covers naming, coupling, DRY, dead code, test coverage gaps. Architecture covers separation of concerns, API contracts, breaking changes, backward compatibility. Language-specific checklists for TypeScript, Python, Go, Rust. Anti-patterns, escalation matrix, GitHub PR comment format. (Origin: MemStack v3.3, Mar 2026)
