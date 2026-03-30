---
name: refactor-planner
description: "WHAT: Identify code smells, assess risk, build incremental refactoring plan with PR strategy and regression gates. WHEN: 'refactor', 'refactoring plan', 'code cleanup', 'tech debt', 'reduce duplication'. NOT: writing new tests without refactoring (test-writer), database schema changes (migration-planner), new feature design (feature-spec)."
---

# Refactor Planner

## Activation

| Context | Status |
|---------|--------|
| "refactor", "refactoring plan", "code cleanup", "tech debt" | ACTIVE |
| Reduce duplication, simplify, god class, tight coupling | ACTIVE |
| Write tests only (no structural change) | DORMANT -- test-writer |
| Database schema change | DORMANT -- migration-planner |
| Plan new features, not improve existing | DORMANT -- feature-spec |

## Instructions

### Step 1: Scope the refactor

Gather from user: codebase scope (full vs module), language/framework, pain points, current test coverage level, timeline, frozen areas or public API constraints.

**Gate:** Do not proceed without knowing test coverage and constraints. If unknown, state assumptions explicitly.

### Step 2: Classify code smells

Scan targets and classify each into one of these categories:

| Category | Signal | Severity heuristic |
|----------|--------|---------------------|
| Duplication | Same pattern in 3+ places | High -- bugs fixed in one spot, missed elsewhere |
| Complexity | Functions >50 lines or >3 nesting levels | Medium -- hard to test and understand |
| God class | 10+ methods or 500+ lines, multiple responsibilities | High -- changes ripple everywhere |
| Coupling | Circular deps, module importing internals of another | High -- can't change one without breaking another |
| Dead code | Unused functions, unreachable branches | Low -- noise, safe to remove |
| Feature envy | Function uses more data from another module than its own | Medium -- logic in wrong place |
| Shotgun surgery | One change requires edits in 5+ files (check git history) | High -- slow velocity |

Document each target: file/function, smell category, severity (critical/high/medium/low), files affected count, test coverage status, specific evidence.

**Gate:** At least one target identified. If scan finds nothing, report clean and stop.

### Step 3: Assess risk per target

Score each target across four dimensions:

- **Files touched** -- 1 file (low), 2-4 (medium), 5+ (high)
- **Test coverage** -- >80% (low), 40-80% (medium), <40% (high)
- **Dependency count** -- 0-2 dependents (low), 3-5 (medium), 6+ (high)
- **Change frequency** -- rarely changed (low), monthly (medium), weekly (high)

Risk decision rules:
- Any dimension rated high AND coverage <40% --> write tests BEFORE refactoring (hard gate)
- Circular dependency --> break one direction first, verify, then break the other
- Public API change --> deprecate old, add new, migrate callers, remove old (4-PR minimum)
- Database-touching code --> coordinate with migration-planner

**Gate:** Every high-risk target must have a test-first mandate documented.

### Step 4: Prioritize by impact

Score each target 1-3 on: change frequency, bug history, developer pain, business impact. Sum and normalize to 10.

| Tier | Score | Action |
|------|-------|--------|
| P1 | 8-10 | Refactor this sprint -- actively causing problems |
| P2 | 5-7 | Refactor this quarter -- slowing the team |
| P3 | 1-4 | Refactor opportunistically -- improve when nearby |

**Gate:** At least one P1 or P2 target required to justify a dedicated refactoring effort. If all P3, recommend boy-scout-rule approach instead of a plan.

### Step 5: Select strategy per target

| Strategy | When to use | Typical PR size |
|----------|-------------|-----------------|
| Extract function/class | Long function or god class with identifiable sub-tasks | Small-Medium |
| Introduce interface | Tight coupling between modules | Small |
| Consolidate duplicates | Same logic in 3+ places | Medium |
| Strangler fig | Large legacy module -- replace incrementally behind a seam | Small per PR |
| Parallel implementation | Critical path -- can't risk breaking it, run old and new side-by-side | Large total but safe |

PR strategy decision:
- Single PR: isolated change, <3 files, good coverage
- Multi-PR sequence: 5+ files or medium/high risk. Standard sequence: (1) add tests, (2) extract/restructure, (3) migrate callers, (4) remove old code
- Never ship a "refactor mega-PR" -- each PR must be independently shippable

Scope containment rules:
- Never refactor two tightly coupled modules simultaneously
- Complete one refactor before starting the next
- If a refactor reveals more work, add it to the backlog -- do not scope-creep
- Pair refactoring with feature work when possible (boy scout rule)

### Step 6: Define regression gates

Per risk level:
- **Low risk:** existing tests + visual verification
- **Medium risk:** add targeted tests before refactoring, run full suite after
- **High risk:** full characterization tests before, integration tests after, manual QA on critical paths

Every refactor PR must pass: all existing tests green, new tests for previously untested affected code, no behavior change in public APIs (unless intentional), no new circular dependencies, linting/type-checking passes.

### Step 7: Build phased roadmap

Organize into phases with milestones:
- **Phase 1 (Foundation):** low-risk refactors + test backfill to build confidence and coverage
- **Phase 2 (Core):** P1 targets, highest-impact smells
- **Phase 3 (Cleanup):** dead code removal, final consolidation, P2 targets

**Gate:** Each phase has a measurable milestone (e.g., "coverage on critical paths >= 80%", "velocity improvement measurable").

### Step 8: Output the plan

Deliver: targets with severity, risk assessment table, priority ranking (P1/P2/P3), per-target PR sequence, regression plan per step, phased roadmap with milestones, and success metrics.

## Examples

**Example 1 -- Strangler fig for a god class:**
User reports 800-line `OrderService` handling validation, pricing, notifications, and logging. Classify: god class (high). Strategy: strangler fig. PR sequence: (1) tests for current behavior, (2) extract `OrderValidator`, (3) extract `PriceCalculator`, (4) extract `OrderNotifier`, (5) slim `OrderService` to orchestrator. Each PR independently deployable.

**Example 2 -- Consolidate duplication across API handlers:**
User reports identical error-handling blocks in 12 route handlers. Classify: duplication (high), shotgun surgery (high). Strategy: consolidate. PR sequence: (1) extract shared `handleApiError` middleware, (2) migrate 4 handlers per PR (3 PRs), (3) remove old inline blocks. Gate: existing integration tests must pass after each migration PR.

## Common Issues

- **No test coverage, user wants to refactor immediately.** Insist on characterization tests first for any medium/high risk target. For low-risk targets (dead code removal, renaming), tests-first can be relaxed.
- **Scope creep during refactoring.** Each discovered smell goes to backlog, not current PR. Enforce the rule: one refactor per PR sequence.
- **Refactoring changes behavior unintentionally.** This means the regression gate failed. Roll back, add the missing test that would have caught it, then retry.

## Anti-Patterns

- Big-bang rewrite PR that touches 50+ files -- always decompose
- Refactoring without tests on affected code (medium/high risk targets)
- Refactoring code that rarely changes and causes no pain (P3 without justification)
- Mixing feature work and refactoring in the same PR (separate concerns)
- Refactoring two coupled modules in parallel (serialize instead)

## Escalation

- If refactoring requires public API changes with external consumers --> escalate to API versioning strategy
- If test coverage is <20% across the codebase --> recommend a dedicated test-writing sprint (test-writer) before any refactoring
- If refactoring touches database schemas --> hand off to migration-planner for coordinated plan
- If the codebase has no CI --> recommend CI setup first (ci-cd-pipeline) so regression gates are enforceable

## Inputs

- Codebase scope and tech stack
- Known pain points and problem areas
- Current test coverage level
- Available timeline
- Constraints (frozen areas, public APIs, external consumers)

## Outputs

- Classified targets with smell category and severity
- Risk assessment per target (files, coverage, dependencies, change frequency)
- Priority ranking (P1/P2/P3) with scoring rationale
- Per-target refactoring strategy and multi-PR sequence
- Regression test plan per step with gates
- Phased execution roadmap with milestones
- Success metrics: cyclomatic complexity, test coverage %, duplicated lines, PR review time, bug rate in refactored modules (all before/after)

## Level History

- **Lv.1** -- Base: 8-category code smell detection, risk assessment per refactor (files x coverage x dependencies), impact-based prioritization (change frequency x bug history x dev pain), incremental PR strategy (extract -> migrate -> remove), before/after code examples, regression test plan per step, phased execution roadmap with metrics tracking. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed to creator-level density: decision rules only, validation gates between steps, scope containment rules, escalation paths, anti-patterns. Removed verbose code examples and templates in favor of terse strategy references. (Origin: MemStack v3.3, Mar 2026)
