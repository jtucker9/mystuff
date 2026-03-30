---
name: financial-model
description: "Build financial projections when user says 'financial model', 'projections', 'revenue forecast', 'unit economics', 'break-even', 'cash flow', or 'runway'. NOT for pricing strategy, invoicing, or MVP scoping."
---

# Financial Model — Business Financial Projections

## Activation

| Context | Status |
|---------|--------|
| "financial model", "projections", "revenue forecast" | ACTIVE |
| Unit economics, break-even, cash flow, runway analysis | ACTIVE |
| MRR, churn, CAC, LTV metrics discussion | ACTIVE |
| Setting prices (not modeling revenue) | DORMANT — pricing-strategy |
| Generating invoices | DORMANT — invoice-generator |
| Scoping an MVP (budget secondary) | DORMANT — mvp-scoper |

## Instructions

### Step 1: Classify business and gather inputs

Ask for: business type, revenue streams, pricing, current metrics (if any), cost structure, growth assumptions, funding status.

**Model type decides everything downstream:**

| Type | Revenue driver | Key formula |
|------|---------------|-------------|
| SaaS/MRR | Subscribers x ARPU | MRR = active customers x ARPU; active = prev + new - churned |
| E-commerce | Orders x AOV | Net revenue = gross - returns - refunds |
| Marketplace | GMV x take rate | Revenue = GMV x commission %; track both sides |
| Service | Clients x retainer OR hours x rate | Capacity-constrained; model utilization rate |

**Gate:** Do not proceed without business type, at least one revenue stream, and either current metrics or assumptions for customer acquisition.

### Step 2: Build 12-month revenue projections

Project monthly: new customers, churned customers, active customers, revenue per customer, total revenue.

**SaaS:** New customers = marketing spend / CAC (or organic growth rate). Churned = previous active x monthly churn rate. Active = previous + new - churned. MRR = active x ARPU. ARR = MRR x 12.

**E-commerce:** Orders/month x AOV = gross revenue. Subtract returns/refunds for net.

**Service:** Billable hours x rate, or active clients x retainer. Cap at capacity.

**Marketplace:** GMV projection x take rate. Model supply and demand sides separately.

**Gate:** Revenue projection must show month-over-month progression. If M12 revenue looks implausible given assumptions, flag and adjust before proceeding.

### Step 3: Build monthly expense projections

Classify every cost as fixed or variable, COGS or OpEx:

| Category | Scaling behavior |
|----------|-----------------|
| People | Step function — add hires at specific months |
| Hosting/infra | Linear with customer count (estimate $/customer/mo) |
| Marketing | Set as % of revenue or fixed budget |
| SaaS tools | Step up at tier thresholds |
| One-time costs | Allocate to specific months (legal, annual subscriptions) |

**COGS** = costs directly tied to delivering the product (hosting, payment processing, support labor). **OpEx** = everything else (marketing, R&D salaries, office, tools).

**Gate:** Total expenses M1 must be realistic relative to funding status. Bootstrapped business projecting $50K/mo payroll in M1 needs correction.

### Step 4: Calculate unit economics

Compute all of:

- **CAC** = total marketing spend / new customers acquired
- **LTV** = ARPU x gross margin x (1 / monthly churn rate)
- **LTV:CAC ratio** — target 3:1+ (healthy), 5:1+ (very healthy); below 3:1 means acquisition too expensive or LTV too low
- **CAC payback period** = CAC / (ARPU x gross margin) — target <=12 months (SaaS), <=3 months (e-commerce)
- **Gross margin** = (revenue - COGS) / revenue x 100 — target >=70% (SaaS), >=40% (e-commerce), >=50% (services)
- **Monthly churn** = lost customers / total at start of month — target <=5% (early stage), <=2% (mature)
- **NRR** = (MRR at end - new MRR) / MRR at start x 100 — target >=100% (expansion offsets churn)

**Gate:** If LTV:CAC < 1:1, the business model is fundamentally broken. Stop and discuss before proceeding to scenarios.

### Step 5: Break-even analysis

Calculate: fixed costs (monthly) / contribution margin per customer = break-even customer count. Contribution margin = revenue per customer - variable cost per customer. Map break-even point to a specific month on the projection timeline.

### Step 6: Scenario modeling (base/bull/bear)

Build three scenarios varying: growth rate, churn rate, CAC, ARPU, marketing spend.

- **Conservative (bear):** Lower growth, higher churn, higher CAC — what if things go slowly?
- **Moderate (base):** Realistic assumptions based on comparable companies
- **Aggressive (bull):** Higher growth, lower churn, lower CAC — what if things go very well?

For each, project M6 and M12 snapshots: active customers, MRR/ARR, monthly burn, cash position, break-even month, runway remaining.

### Step 7: Cash flow and runway

Net cash flow = revenue - expenses (monthly). Cash position = starting cash + cumulative net. Runway = current cash / average monthly burn.

Decision framework for runway:
- **< 6 months:** URGENT — reduce burn or raise funds immediately
- **6-12 months:** START fundraising or find path to profitability
- **> 12 months:** Comfortable — focus on growth

### Step 8: Sensitivity analysis

Identify the 2-3 variables that most impact outcomes (usually churn, CAC, growth rate). Show what happens to break-even month and runway when each variable shifts +/- 25%. This reveals which assumptions the model is most fragile against.

### Step 9: Assemble and present

Combine all sections into a single model output: revenue projections, expense projections, unit economics summary, break-even point, scenario comparison, cash flow with runway, key metrics dashboard (MRR, ARR, growth rate, margins, efficiency ratios), and assumptions/risks list.

**Gate:** Final model must be internally consistent — expenses from Step 3 must feed into unit economics in Step 4, which must feed into scenarios in Step 6.

## Examples

**SaaS pre-launch:** User has $50K starting cash, plans $29/mo SaaS, expects 10% monthly growth, 5% churn. Build full model showing ~M8 break-even on moderate scenario, flag that 5% churn gives only 20-month average lifetime, recommend churn reduction as highest-leverage improvement.

**E-commerce existing:** User runs Shopify store, 500 orders/mo at $45 AOV, 30% margins, wants to model scaling ad spend from $2K to $8K/mo. Show customer acquisition curve, diminishing returns on ad spend, break-even on incremental spend, and runway impact across scenarios.

## Common Issues

- **Confusing MRR with ARR in early months.** MRR is the monthly figure; ARR = MRR x 12. ARR only meaningful once MRR is somewhat stable.
- **Ignoring step-function costs.** Models that scale expenses linearly miss that hiring, tool upgrades, and infrastructure come in steps. One new hire changes the entire burn rate overnight.
- **Assuming constant churn.** Early-stage churn is almost always higher than mature churn. Model improvement over time or the projections will be too pessimistic long-term and too optimistic short-term.

## Anti-Patterns

- Building a 5-year model when the business is pre-revenue (12 months max for pre-revenue)
- Using industry benchmarks as inputs instead of business-specific data
- Modeling revenue without modeling the acquisition channel that produces it
- Presenting a single scenario without range (always show base/bull/bear)
- Including vanity metrics (total signups, page views) in the financial model

## Escalation

- If the user needs investor-grade financial statements (P&L, balance sheet, cash flow statement) with GAAP compliance, recommend a fractional CFO or accountant
- If unit economics are fundamentally broken (LTV:CAC < 1:1), pause modeling and discuss business model pivot
- If the model requires multi-entity consolidation or tax optimization, this exceeds skill scope

## Inputs

- Business type and revenue model
- Pricing and current metrics (if existing)
- Cost structure (people, infrastructure, marketing)
- Growth and churn assumptions
- Starting cash and funding status

## Outputs

- 12-month revenue projection (monthly granularity)
- 12-month expense projection by category (fixed vs variable, COGS vs OpEx)
- Unit economics: CAC, LTV, LTV:CAC, payback period, gross margin, churn, NRR
- Break-even analysis with customer and revenue targets
- 3-scenario comparison (conservative, moderate, aggressive) at M6 and M12
- Cash flow projection with runway calculation and decision framework
- Sensitivity analysis on top 2-3 variables
- Key metrics dashboard

## Level History

- **Lv.1** — Base: 12-month revenue/expense projections (SaaS, e-commerce, service models), unit economics (CAC, LTV, LTV:CAC, payback, margins, churn, NRR), break-even analysis, 3-scenario modeling (conservative/moderate/aggressive), cash flow with runway calculation, key metrics dashboard. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Added model type decision table, marketplace model, cost classification framework (COGS vs OpEx), sensitivity analysis step, validation gates between steps, escalation paths, anti-patterns. Removed template ASCII tables and placeholder formulas. (Origin: MemStack v3.2, Mar 2026)
