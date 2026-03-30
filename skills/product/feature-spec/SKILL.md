---
name: feature-spec
description: "Use when the user says 'feature spec', 'spec this feature', 'write a spec', 'functional spec', 'technical spec', or needs a detailed specification for a single feature an engineer can implement without ambiguity. Do NOT use for full product PRDs (see prd-writer), user story backlogs (see user-story-generator), or high-level roadmap planning (see roadmap-builder)."
---

# Feature Spec -- Detailed Feature Specification

*Write an unambiguous spec for a single feature covering flows, edge cases, APIs, and acceptance criteria.*

## Activation

When this skill activates, output:

`Feature Spec -- Writing your feature specification...`

| Context | Status |
|---------|--------|
| **User says "feature spec", "spec this feature", "write a spec"** | ACTIVE |
| **User needs a detailed specification for ONE feature** | ACTIVE |
| **User mentions functional requirements + edge cases + acceptance criteria** | ACTIVE |
| **User wants a full product PRD (multiple features)** | DORMANT -- see prd-writer |
| **User wants user stories only (no technical detail)** | DORMANT -- see user-story-generator |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Feature name**: What is this feature called?
- **Parent product**: What product does this belong to?
- **User story**: "As a [user], I want [action] so that [benefit]"
- **Priority**: Must Have / Should Have / Could Have
- **Context**: Any existing specs, designs, or constraints

**Gate**: Do not proceed until feature name, user story, and priority are provided.

### Step 2: Functional Requirements

Write an overview paragraph, then a requirements table:

| ID | Requirement | Details |
|----|-------------|---------|
| FR-01 | [name] | [precise behavior -- "shall", "must", "when X then Y"] |

Rules: each requirement independently testable; no "appropriate" or "user-friendly"; include defaults and boundaries.

### Step 3: Non-Functional Requirements

Cover four areas in bullet form:
- **Performance**: response time targets, throughput, data volume limits
- **Security**: auth, encryption, input validation, rate limiting
- **Accessibility**: WCAG level, keyboard nav, screen reader, contrast
- **Compatibility**: browser matrix, mobile, API versioning

**Gate**: If any NFR is unknown, mark it "[TBD -- needs stakeholder input]" rather than omitting.

### Step 4: User Flow

Map step-by-step: User [action] -> System [response] -> UI [what user sees]. Include entry points, happy path, alternative paths, exit points.

### Step 5: Edge Cases and Error States

| Scenario | Trigger | Expected Behavior | Error Message |
|----------|---------|-------------------|---------------|
| Empty input | Blank form submit | Inline validation | "This field is required" |
| Duplicate | Existing item | Block creation | "[Item] already exists" |
| Network failure | Connection lost | Retry with backoff | "Connection lost. Retrying..." |
| Permission denied | Unauthorized | Redirect | "You don't have access" |
| Concurrent edit | Two users edit | Last-write-wins or merge | "Updated. Reload?" |

Add rows for each feature-specific edge case.

### Step 6: API Requirements (if applicable)

For each endpoint define: method, path, purpose, auth, rate limit, request body with types/constraints, success response, error responses (400/401/404/429).

**Gate**: Every field in the request body must specify type, required/optional, and constraints.

### Step 7: Database Changes

Define new tables (columns, types, constraints), schema changes to existing tables, indexes with justification, and migration/rollback notes.

### Step 8: Acceptance Criteria

Write Given/When/Then for every happy path, edge case, error state, and NFR target:

```
AC-01: Given [precondition], When [action], Then [result]
```

**Gate**: Verify checklist -- happy path covered, each edge case has AC, error states have AC, performance targets have AC.

### Step 9: Assemble Output

Present complete spec with sections: User Story, Functional Requirements, Non-Functional Requirements, User Flow, Edge Cases, API Requirements, Database Changes, Acceptance Criteria.

## Examples

**Example 1 -- API feature**:
User: "Spec the bulk CSV import for our contacts module"
Output: FR table with upload limits (50MB, 100k rows), validation rules per column, async processing flow, progress polling endpoint, error report download endpoint, 6 edge cases, 8 acceptance criteria.

**Example 2 -- UI feature**:
User: "Spec the inline editing for the task board"
Output: FR table covering click-to-edit, escape-to-cancel, blur-to-save, optimistic UI update, conflict detection flow, 5 edge cases (concurrent edit, network loss, empty value, max length, special characters), no API section needed.

## Common Issues

- **Vague requirements slip through**: Replace any "should be fast" with a measurable target ("< 200ms p95"). If the user cannot specify, mark as "[TBD]" and flag in open questions.
- **Missing error states**: Walk through the flow asking "what if this fails?" at each step. Every system call needs a failure path.
- **Scope creep into PRD territory**: If the user starts describing multiple features, stop and recommend prd-writer. One feature per spec.

## Anti-Patterns

- Writing requirements that cannot be independently tested
- Using subjective language ("intuitive", "user-friendly", "fast")
- Omitting database migration rollback strategy
- Defining API endpoints without error response schemas
- Skipping accessibility requirements for UI features
- Combining multiple features into one spec document

## Level History

- **Lv.1** -- Base: Complete feature specification with functional/non-functional requirements, user flow mapping, edge case matrix, API endpoint definitions, database schema changes, Given/When/Then acceptance criteria. Zero-ambiguity engineering handoff format. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 267 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
