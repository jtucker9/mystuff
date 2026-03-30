---
name: invoice-generator
description: "Generate professional invoices with line items, tax calculations, and payment instructions. WHEN: 'invoice', 'generate invoice', 'bill client', 'billing'. NOT: contracts (contract-template), financial projections (financial-model), client setup (client-onboarding)."
---

# Invoice Generator

## Activation

| Context | Status |
|---------|--------|
| "invoice", "generate invoice", "create invoice", "bill client" | ACTIVE |
| Mentions line items, payment terms, invoice numbers | ACTIVE |
| Wants a contract, not just billing | DORMANT — contract-template |
| Wants financial projections | DORMANT — financial-model |

Output on activation: `Invoice Generator — Generating your invoice...`

## Instructions

### Step 1: Gather Inputs

Collect from user (ask for missing required fields):

**Required:** business info (name, address, email), client info (name, company, address, email), line items (description, qty, unit rate), payment terms, payment method(s).

**Optional:** tax rate + tax ID, discount (% or fixed), currency (default USD), invoice number format, logo URL, notes.

**Gate:** Do not proceed without at least one line item and both business/client names.

### Step 2: Generate Invoice Number

| Format | Pattern | Use Case |
|--------|---------|----------|
| Sequential | INV-001 | Solo freelancer |
| Year-seq | INV-2026-001 | Annual tracking |
| Client-prefix | INV-ACME-001 | Multi-client |
| Date-based | INV-20260301-001 | High volume |
| Project-based | INV-PROJ42-001 | Per-project billing |

Default: `[PREFIX]-[YEAR]-[SEQ]`. New year resets sequence to 001. If user provides last invoice number, increment from it.

**Gate:** Invoice number must be unique and follow chosen format before proceeding.

### Step 3: Calculate Totals

**Calculation order (strict):**
1. Line item amount = quantity x unit rate
2. Subtotal = sum of all line item amounts
3. Discount applied to subtotal (before tax) — percentage or fixed
4. Taxable amount = subtotal - discount
5. Tax = taxable amount x tax rate
6. Total = taxable amount + tax

**Rules:** Round all amounts to 2 decimal places. Display currency symbol consistently. For multi-currency: state currency code explicitly on every monetary value, never mix currencies in one invoice, note exchange rate if converting.

**Gate:** Verify total = subtotal - discount + tax. If mismatch, recalculate before proceeding.

### Step 4: Payment Instructions

Generate details for each selected method:

- **Bank transfer:** Bank name, account name, account number, routing number, SWIFT/BIC (international), reference = invoice number
- **Stripe:** Payment link URL, reference = invoice number
- **PayPal:** Payment email, reference = invoice number
- **Check:** Payee name, mailing address, memo = invoice number

Always include invoice number as payment reference regardless of method.

### Step 5: Due Date and Late Fees

| Terms | Due Date | Default Late Fee |
|-------|----------|-----------------|
| Due on receipt | Invoice date | 1.5%/month after 7 days grace |
| Net 15 | +15 days | 1.5%/month after due date |
| Net 30 | +30 days | 1.5%/month after due date |
| Net 60 | +60 days | 1.0%/month after due date |
| Custom | Specific date | Custom terms |

**Late fee calculation:** Monthly rate applied to outstanding balance. Partial months prorated. Annual rate = monthly x 12. Include clause text: "A late fee of [X]% per month ([Y]% annually) will be applied to balances unpaid after the due date."

**Gate:** Due date must be on or after invoice date.

### Step 6: Assemble and Output

Produce three deliverables:

1. **Formatted invoice** — Header (business info, invoice number, dates, terms), bill-to block, line item table, totals breakdown, payment instructions, notes/terms
2. **Structured JSON** — Complete invoice data with all fields for programmatic use or PDF generation. Required keys: `invoice_number`, `date`, `due_date`, `terms`, `currency`, `from`, `to`, `line_items[]` (each with description/quantity/unit/rate/amount), `subtotal`, `discount`, `tax`, `total`, `payment_methods`, `late_fee`
3. **Email template** — Subject line with invoice number and due date, amount due, payment summary, one-paragraph body

### Step 7: Invoice Status

Track and label invoice state when relevant:

| Status | Meaning |
|--------|---------|
| Draft | Created, not yet sent |
| Sent | Delivered to client |
| Viewed | Client opened (if trackable) |
| Paid | Payment received |
| Overdue | Past due date, unpaid |
| Void | Cancelled |

Default new invoices to "Draft". Suggest status update workflow if user asks about tracking.

## Examples

**Freelance web dev invoice:** 3 line items (design 10hrs x $150, development 40hrs x $150, hosting setup 1x $200), 10% discount, 8.25% tax, Net 30, bank transfer + Stripe. Total after discount and tax = $7,927.13. Invoice INV-2026-003.

**Monthly retainer invoice:** 1 line item (March 2026 retainer 1x $3,000), no discount, no tax (B2B exempt), Net 15, PayPal only. Invoice INV-ACME-012. Include "Tax exempt — B2B services" note.

## Common Issues

- **Tax on discounted vs full amount:** Always tax the discounted subtotal, never the pre-discount subtotal. Pre-discount taxation overcharges the client.
- **Multi-currency confusion:** One invoice = one currency. If client pays in different currency, note conversion rate and which party absorbs exchange variance.
- **Missing payment reference:** Every payment method must include invoice number as reference. Without it, payments cannot be matched to invoices.

## Anti-Patterns

- Generating invoices without confirming line items first (garbage in, garbage out)
- Applying tax before discount (changes the total, may violate local tax rules)
- Using ambiguous date formats — always use YYYY-MM-DD in data, localized format in display
- Mixing multiple currencies in a single invoice
- Omitting late fee terms (leaves no recourse for overdue payments)

## Escalation

- Tax jurisdiction questions (VAT, GST, sales tax rules) — recommend consulting an accountant
- Legal enforceability of late fees — varies by jurisdiction, recommend legal review
- Invoice disputes or collections — outside scope, recommend accounts receivable process
- Recurring/subscription invoicing — suggest dedicated billing platform (Stripe Billing, FreshBooks)

## Inputs

- Business info: name, address, email, phone, tax ID (optional)
- Client info: name, company, address, email
- Line items: description, quantity, unit, rate per item
- Payment terms: Net 15/30/60, due on receipt, or custom date
- Payment methods: bank transfer, Stripe, PayPal, check
- Tax rate and discount (optional)
- Currency and invoice number format (optional)

## Outputs

- Unique invoice number in chosen format
- Calculated totals: subtotal, discount, tax, total (verified)
- Payment instructions for each selected method
- Due date with late fee terms
- Formatted invoice layout
- Structured JSON for programmatic use
- Email delivery template
- Invoice status label

## Level History

- **Lv.1** — Base: Configurable invoice numbering (5 formats), line item calculation with discount and tax, multi-method payment instructions (bank/Stripe/PayPal/check), due date calculation with late fee terms, professional layout template, structured JSON output, email delivery template. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Added validation gates between steps, invoice status tracking, multi-currency rules, anti-patterns, escalation paths. Removed verbose templates in favor of decision rules. (Origin: MemStack v3.3, Mar 2026)
