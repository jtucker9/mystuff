---
name: test-writer
description: "Generate unit, integration, and component tests with proper mocking and edge case coverage. Activate on 'write tests', 'add tests', 'test coverage', 'unit tests', 'integration tests'. Do NOT use for refactoring plans (see refactor-planner) or code review (see code-reviewer)."
---

# Test Writer

## Activation

| Context | Status |
|---------|--------|
| "write tests", "add tests", "test coverage", "unit tests" | ACTIVE |
| Mocking strategy, edge case identification, test structure | ACTIVE |
| Refactoring plan that includes tests | DORMANT — refactor-planner |
| Code quality review | DORMANT — code-reviewer |

## Instructions

### Step 1: Gather Inputs

Required: target code (files/modules/features), language/framework.
Detect from project: test runner (Jest/Vitest/pytest/Go testing), existing tests, current coverage.
Ask: priority areas (business logic, API routes, UI components) and external dependencies needing mocks.

> Gate: Do not generate tests without knowing the test runner and target code.

### Step 2: Identify Critical Paths

Classify every target by priority:

| Signal | Priority | Coverage target |
|--------|----------|----------------|
| Handles money or sensitive data | Critical | 90%+ |
| Called by 5+ modules | Critical | 90%+ |
| Recently had bugs | Critical | 90%+ |
| Complex branching (3+ conditions) | Important | 85%+ |
| Pure function, clear I/O | Standard | 100% (easy) |
| UI component, user-facing | Standard | 80%+ |

Test critical paths first. Don't waste time on getters/setters or framework boilerplate.

> Gate: Priority list confirmed with user before generating tests.

### Step 3: Select Test Types

Decision tree per code unit:

- **Pure functions, validators, transforms** → Unit tests. Test all branches, boundary values (0, -1, MAX, empty, null), and error states. Arrange-Act-Assert structure. One assertion concept per test.
- **API routes, DB queries, middleware** → Integration tests. Test the full request/response cycle: happy path, validation errors (400), auth failures (401/403), not found (404), conflict (409). Use real test DB when possible; mock only external third-party APIs.
- **React/UI components** → Component tests. Query by role/label/text, never by class or test ID. Use `userEvent` over `fireEvent`. Test user-visible behavior (appears, disappears, calls handler), not implementation details. Mock child components only when they have side effects.
- **Cross-service workflows** → E2E tests (flag as out of scope for this skill unless explicitly requested).

> Gate: Test type selected for each target before writing.

### Step 4: Apply Mocking Rules

When to mock vs use real:

| Dependency | Mock? | Reason |
|-----------|-------|--------|
| Database (own) | Prefer real (test DB) | Mocked DB tests pass when real queries fail |
| Third-party APIs (Stripe, AWS) | Always mock | Can't control, costs money, flaky |
| File system | Mock in unit, real in integration | Speed vs fidelity tradeoff |
| Time/dates | Always mock | Deterministic tests |
| Internal modules | Don't mock | Test the real interaction |
| Environment variables | Inject via setup | Never mock `process.env` directly |

Mock at the boundary, not in the middle. If you're mocking more than 2 things in a unit test, the unit is too coupled — flag for refactoring.

### Step 5: Generate Tests

Naming convention: `describe` block = module/class, nested `describe` = function/method, `it` = `should [behavior] when [condition]`.

For each function, generate tests in this order:
1. Happy path — normal input, expected output
2. Edge cases — null, empty, zero, negative, max value, unicode, whitespace
3. Error states — invalid input throws correct error type
4. Boundary values — off-by-one, type coercion, overflow

Coverage targets by function type:
- Pure functions / validators: 100%
- Business logic: 90%
- Data transforms: 95%
- API routes: all status codes exercised
- Components: render, interaction, error state, loading state

### Step 6: Verify and Report

Run the test suite. Report:
- Tests written (count by type)
- Coverage delta (before → after)
- Uncovered paths flagged but intentionally skipped (with reason)
- Flaky test risks (time-dependent, order-dependent, network-dependent)

> Gate: All generated tests pass before marking complete.

## Examples

**1. Node.js API with Prisma**: Analyze 12 route handlers → prioritize payment and auth routes as Critical, CRUD routes as Standard → generate 8 integration tests (supertest + test DB) for auth/payment, 15 unit tests for validators and transforms, mock Stripe webhook verification only.

**2. React dashboard with forms**: Analyze 6 form components → generate component tests using Testing Library + userEvent for each form (render, submit, validation error, loading state), unit tests for 4 utility functions, mock API client at module boundary.

## Common Issues

- **Tests pass in isolation, fail together**: Shared mutable state between tests — add proper `beforeEach` cleanup or isolate test databases per suite.
- **Mocked tests pass but production breaks**: Over-mocking hides real integration issues — prefer test DB over mocked DB, mock only at third-party boundaries.
- **Flaky async tests**: Missing `await`, race conditions, or network calls leaking through mocks — ensure all async operations are awaited and all external calls are intercepted.

## Anti-Patterns

- Testing implementation details instead of behavior (checking internal state, asserting on private methods)
- One giant test that validates everything — split into focused single-assertion tests
- Mocking the module under test (testing the mock, not the code)
- Copy-pasting test bodies instead of using parameterized/table-driven tests
- No cleanup in `afterEach` — tests leak state and become order-dependent
- Snapshot tests for dynamic content (dates, IDs) — they break on every run
- Testing framework code (does Express routing work? does React render?)

## Escalation

Hand off when: E2E browser testing (Playwright/Cypress), load/performance testing, security-focused fuzzing, visual regression testing, test infrastructure setup (CI matrix, parallelization).

## Inputs
- Target code, language/framework, test runner, current coverage, priority areas

## Outputs
- Test files organized by type (unit/integration/component), coverage report delta, uncovered path inventory

## Level History

- **Lv.1** — Base: Test generation for Node/Python/React with unit/integration/component patterns, mocking strategies, coverage targets. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Removed all code examples and mocking templates. Retained decision trees, priority classification, mocking rules, coverage targets, naming conventions. (Mar 2026)
