---
name: scan
description: "Use when the user says 'scan project', 'estimate', 'how much to charge', or needs codebase complexity analysis. Do NOT use for code review (use code-reviewer), security audits (use security skills), or performance analysis (use performance-audit)."
---


# Scan -- Analyzing Project Scope
*Analyze a project's complexity and generate pricing recommendations.*

## Activation

When this skill activates, output:

`Scan -- Analyzing project scope...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User asks to scan or analyze a project** | ACTIVE -- full scan |
| **User asks about pricing or estimates** | ACTIVE -- full scan + pricing |
| **User mentions project metrics (LOC, file count)** | ACTIVE -- quick metrics |
| **Discussing project analysis concepts generally** | DORMANT -- do not activate |
| **User is building/coding, not analyzing** | DORMANT -- do not activate |

## Instructions

### Step 1: Scan the Codebase

```bash
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" -o -name "*.css" \) | wc -l
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" \) -exec cat {} + | wc -l
```

Count: pages/routes, API endpoints, database tables, external integrations, auth complexity.

### Step 2: Determine Complexity Tier (Decision Tree)

1. Regulatory compliance (HIPAA, SOC2, PCI-DSS)? -> Enterprise
2. 3+ external integrations or custom infra? -> Complex or Enterprise
3. Real-time features, event-driven, multi-tenant? -> Complex minimum
4. Standard CRUD or marketing site? -> Simple or Moderate
5. File count/LOC as confirming signals: <20 files/<3K LOC = Simple, 20-60/3K-15K = Moderate, 60-150/15K-50K = Complex, 150+/50K+ = Enterprise

### Step 3: Calculate Pricing

**Formula:** `Base = Hourly Rate x Hours x Complexity Multiplier`

| Tier | Multiplier | Hours | Price Range |
|------|-----------|-------|-------------|
| **Simple** | 1x | 20-80 | $2K-$10K |
| **Moderate** | 1.5x | 80-300 | $10K-$50K |
| **Complex** | 2-3x | 200-800 | $50K-$150K |
| **Enterprise** | 3-5x | 500-2000+ | $150K-$500K+ |

**Hourly rates** (default US Senior $150-$250/hr): Mid $100-$150, Senior $150-$250, Specialist $250-$400.

**Factor adjustments** (additive %): timeline pressure +25-50%, specialized tech +20-40%, compliance +30-50%, ongoing maintenance +15-25%/yr, auth complexity +10-20%, payment processing +10-15%, real-time features +15-25%, admin panel +15-25%, per API integration +$2K-$8K each.

### Step 4: Generate Three-Tier Pricing

Present Budget, Standard, and Premium options. Break down hours by component. Include 20% buffer for unknowns.

### Step 5: Value-Based Alternative

When project has measurable business impact, show value-based pricing (10-20% of estimated Year 1 value) alongside cost-based pricing. Best for: revenue-generating projects, automation replacing manual processes. Avoid for: internal tools with fuzzy ROI, exploratory projects.

## Examples

**Full project scan:**
User: "scan AdminStack and estimate pricing" -> Count files/LOC, identify 6 integrations, classify as Complex, estimate 444 hrs, present 3-tier pricing ($150K/$210K/$275K).

**Quick metrics only:**
User: "how big is this codebase?" -> Count files and LOC, report component breakdown. Skip pricing unless asked.

## Common Issues

| Issue | Fix |
|-------|-----|
| Tier and price range mismatch | If calculated total exceeds the tier's range, revisit tier assessment -- it may belong in the next tier |
| Client pushback on pricing | Show the hour breakdown by component so the client sees where time goes |

## Anti-Patterns

- Using file count/LOC as the sole tier determinant -- architecture complexity matters more than size
- Skipping the decision tree and jumping straight to LOC-based classification
- Presenting a single price instead of three tiers -- always give Budget/Standard/Premium
- Forgetting the 20% buffer for unknowns in hour estimates

## Level History

- **Lv.1** -- Base: File/LOC counting with complexity assessment.
- **Lv.2** -- Enhanced: Context guard, activation message, integration pricing.
- **Lv.3** -- Pricing overhaul: Decision-tree tier placement, market-adjusted rates, complexity multipliers, factor adjustments, value-based pricing, calculator workflow.
