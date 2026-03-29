---
name: scan
description: "Use when the user says 'scan project', 'estimate', 'how much to charge', or needs codebase complexity analysis."
---


# Scan — Analyzing Project Scope
*Analyze a project's complexity and generate pricing recommendations.*

## Activation

When this skill activates, output:

`Scan — Analyzing project scope...`

Then execute the protocol below.

## Context Guard

| Context | Status |
|---------|--------|
| **User asks to scan or analyze a project** | ACTIVE — full scan |
| **User asks about pricing or estimates** | ACTIVE — full scan + pricing |
| **User mentions project metrics (LOC, file count)** | ACTIVE — quick metrics |
| **Discussing project analysis concepts generally** | DORMANT — do not activate |
| **User is building/coding, not analyzing** | DORMANT — do not activate |

## Protocol

### Step 1: Scan the Codebase

```bash
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" -o -name "*.css" \) | wc -l
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" \) -exec cat {} + | wc -l
```

### Step 2: Count Key Components

Pages/routes, API endpoints, database tables, external integrations, auth complexity.

### Step 3: Determine Complexity Tier (Decision Tree)

Walk through these questions in order to place the project into a tier:

```
Q1: Does the project involve regulatory compliance (HIPAA, SOC2, PCI-DSS, GDPR-heavy)?
    YES --> Enterprise tier (or Complex with compliance adjustment)

Q2: Are there more than 3 external system integrations or custom infrastructure needs?
    YES --> Complex or Enterprise depending on scale

Q3: Does it require real-time features, event-driven architecture, or multi-tenant design?
    YES --> Complex tier minimum

Q4: Is it a standard CRUD app or marketing site with known patterns?
    YES --> Simple or Moderate depending on size

Q5: File count and LOC as confirming signals (not sole determinants):
    < 20 files, < 3K LOC ........... confirms Simple
    20-60 files, 3K-15K LOC ........ confirms Moderate
    60-150 files, 15K-50K LOC ...... confirms Complex
    150+ files, 50K+ LOC ........... confirms Enterprise
```

### Step 4: Calculate Pricing

Use the pricing model defined below.

### Step 5: Generate Three-Tier Pricing

Present Budget, Standard, and Premium options within the calculated range.

---

## Pricing Model

### Base Rate Calculation

**Formula:** `Base Price = Hourly Rate x Estimated Hours x Complexity Multiplier`

Hourly rate ranges by market and experience:

| Experience Level | US Market | EU Market | Global Remote |
|-----------------|-----------|-----------|---------------|
| Mid-level (3-5 yr) | $100-$150/hr | $75-$125/hr | $50-$100/hr |
| Senior (5-10 yr) | $150-$250/hr | $125-$200/hr | $80-$150/hr |
| Specialist/Architect | $250-$400/hr | $200-$300/hr | $125-$250/hr |

Default assumption when market is unknown: **US Senior ($150-$250/hr)**.

### Complexity Tiers and Multipliers

| Tier | Multiplier | Typical Hours | Realistic Price Range |
|------|-----------|---------------|----------------------|
| **Simple** | 1x | 20-80 hrs | $2,000 - $10,000 |
| **Moderate** | 1.5x | 80-300 hrs | $10,000 - $50,000 |
| **Complex** | 2-3x | 200-800 hrs | $50,000 - $150,000 |
| **Enterprise** | 3-5x | 500-2000+ hrs | $150,000 - $500,000+ |

**What each tier looks like:**

- **Simple:** Landing pages, basic CRUD apps, simple APIs, static sites with a CMS, single-purpose tools. Known patterns, one developer, minimal integrations.
- **Moderate:** Multi-page apps with auth, dashboard + admin panel, payment integration, 2-3 external APIs, moderate business logic. Small team, 2-4 month timeline.
- **Complex:** Multi-service architecture, real-time features, complex data pipelines, custom integrations, role-based access, multi-environment deployment. Dedicated team, 4-8 month timeline.
- **Enterprise:** Multi-tenant SaaS, regulatory compliance, high-availability requirements, complex security model, data migration from legacy systems, multi-region deployment. Cross-functional team, 6-18 month timeline.

### Factor Adjustments

Apply these as additive percentage adjustments to the base price:

| Factor | Adjustment | When to Apply |
|--------|-----------|---------------|
| **Timeline pressure** | +25-50% | Deadline is less than 70% of standard timeline for the tier |
| **Specialized technology** | +20-40% | Blockchain, ML/AI, AR/VR, low-level systems, uncommon stacks |
| **Compliance requirements** | +30-50% | HIPAA, SOC2, PCI-DSS, FedRAMP, accessibility (WCAG AA+) |
| **Ongoing maintenance** | +15-25% of project cost annually | Client expects post-launch support, SLAs, or on-call |
| **Auth complexity** | +10-20% | 2FA, SSO/SAML, OAuth multi-provider, RBAC with complex roles |
| **Payment processing** | +10-15% | Stripe/payment gateway integration, invoicing, subscriptions |
| **Real-time features** | +15-25% | WebSockets, live collaboration, streaming, push notifications |
| **Admin panel** | +15-25% | Back-office dashboard, content management, user management |
| **Mobile responsive** | +10-20% | Full responsive design beyond basic media queries |
| **Per API integration** | +$2K-$8K each | Third-party API with auth, error handling, rate limiting, data mapping |

### Pricing Calculator Workflow

Follow this step-by-step to produce a quote:

```
1. DETERMINE TIER
   Run the decision tree from Step 3 above.

2. ESTIMATE HOURS
   Break the project into components. Estimate hours per component.
   Add 20% buffer for unknowns.
   Example:
     Auth system ............. 30 hrs
     Core CRUD + API ........ 60 hrs
     Admin panel ............ 40 hrs
     Payment integration .... 25 hrs
     Frontend/UI ............ 50 hrs
     Testing + QA ........... 30 hrs
     Deployment + DevOps .... 15 hrs
     Buffer (20%) ........... 50 hrs
     TOTAL .................. 300 hrs

3. SELECT HOURLY RATE
   Based on market, experience, and specialization needed.
   Example: US Senior = $175/hr

4. CALCULATE BASE
   300 hrs x $175/hr = $52,500

5. APPLY COMPLEXITY MULTIPLIER
   Moderate tier = 1.5x
   $52,500 x 1.5 = $78,750

6. APPLY FACTOR ADJUSTMENTS
   Timeline pressure (tight deadline): +30% = +$23,625
   Payment processing: +12% = +$9,450

7. CALCULATE TOTAL
   $78,750 + $23,625 + $9,450 = $111,825

8. BUILD THREE TIERS
   Budget:   ~$85,000  — Core features, standard delivery, basic styling
   Standard: ~$112,000 — Full features, polish, admin panel, responsive
   Premium:  ~$140,000 — Full + custom integrations + 3-month post-launch support

9. SANITY CHECK
   Does the total fall within the expected range for the tier?
   Moderate = $10K-$50K, Complex = $50K-$150K
   $112K sits in Complex range — if the scan said Moderate, revisit
   the tier assessment. Adjust or explain the overlap.
```

### Value-Based Pricing (Alternative)

When the project has clear, measurable business impact, consider value-based pricing instead of (or alongside) cost-based pricing:

- **Typical range:** 10-20% of the estimated business value the project creates in Year 1
- **When to use:** The client can articulate revenue impact, cost savings, or strategic value
- **Example:** A tool that saves $500K/yr in manual work could be priced at $50K-$100K regardless of hours
- **How to present it:** Show both the cost-based and value-based price. If value-based is higher, use it as justification for premium pricing. If lower, it signals the project may not be worth building.

**Value-based is strongest when:**
- Revenue directly attributable to the project (e-commerce, SaaS)
- Clear cost reduction (automation replacing manual processes)
- Competitive advantage with quantifiable market impact

**Avoid value-based when:**
- Internal tools with fuzzy ROI
- Client cannot articulate business value
- Exploratory or R&D projects

---

## Inputs
- Project directory path
- New build vs maintenance estimate

## Outputs
- Project analysis: file counts, LOC, endpoints, tables
- Complexity tier assessment with decision-tree reasoning
- Three-tier pricing recommendation with calculation breakdown

## Example Usage

**User:** "scan AdminStack and estimate pricing"

```
Scan — Analyzing project scope...

FILES: 127 | LOC: ~28,000 | Pages: 27 | API Routes: 34 | Tables: 20
Integrations: Supabase, Stripe, Square, SendGrid, Railway, Hetzner

DECISION TREE:
  Compliance? No
  3+ integrations? Yes (6 integrations) --> Complex minimum
  Real-time features? No
  File/LOC confirms: 60-150 files, 15K-50K LOC --> Complex

TIER: Complex (multiplier: 2x)

HOUR ESTIMATE:
  Auth + RBAC ............. 35 hrs
  Core CRUD + API ......... 80 hrs
  Admin panel ............. 45 hrs
  Payment (Stripe+Square) . 40 hrs
  Email (SendGrid) ........ 15 hrs
  Frontend/UI (27 pages) .. 90 hrs
  Infrastructure .......... 25 hrs
  Testing + QA ............ 40 hrs
  Buffer (20%) ............ 74 hrs
  TOTAL ................... 444 hrs

BASE: 444 hrs x $185/hr = $82,140
COMPLEXITY: x 2.0 = $164,280
ADJUSTMENTS:
  Payment processing (+12%): +$19,714
  6 API integrations (6 x $4K): +$24,000

CALCULATED TOTAL: ~$208,000

THREE-TIER PRICING:
  Budget:   $150,000 — Core features, 4 key integrations, basic admin
  Standard: $210,000 — All features, all integrations, full admin, responsive
  Premium:  $275,000 — Full build + 6-month support + priority SLA
```

## Level History

- **Lv.1** — Base: File/LOC counting with complexity assessment.
- **Lv.2** — Enhanced: Added YAML frontmatter, context guard, activation message, integration pricing.
- **Lv.3** — Pricing overhaul: Decision-tree tier placement, base rate calculation with market-adjusted hourly rates, complexity multipliers, factor adjustments, value-based pricing option, pricing calculator workflow.
