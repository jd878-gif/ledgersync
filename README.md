# LedgerSync

Payments reconciliation data platform: captures payment database changes via CDC,
ingests processor settlements and bank statements, and reconciles all three sources
in an Apache Iceberg lakehouse with automated data quality gates.

## Problem Statement

### Context
Companies that accept payments online, such as marketplaces, subscription businesses,
and delivery platforms, do not receive money directly. Every payment passes through
three independent systems, each keeping its own record:

1. **Internal payments database**: what the company believes happened
   (charges, refunds, disputes, fees owed, payouts expected).
2. **Payment processor settlement reports**: what the processor says it collected,
   the fees it deducted, and what it paid out. These reports arrive 1–3 days later,
   in each processor's own format.
3. **Bank statements**: what actually arrived in the company's bank account. A single
   bank deposit typically bundles thousands of individual transactions into one payout.

The business process behind this data is the payment lifecycle:
checkout → authorization → capture → refund / dispute → processor settlement → payout → bank deposit.

### The Problem
These three systems frequently disagree, and nobody sees the disagreement until
someone checks manually. Common mismatches ("breaks") include:

- A refund issued to a customer that never appears in the processor's settlement
- A processor deducting a higher fee than the contracted rate
- A payout the processor reports as sent that never reaches the bank
- A charge captured twice due to a retry bug
- Amount differences caused by currency conversion

Matching records across these systems is hard because they use different identifiers,
formats, time zones, and reporting delays, and because one bank deposit maps to
thousands of underlying transactions (a many-to-one relationship).

### Current State
In many finance teams, reconciliation is performed manually in spreadsheets:
exporting reports from each system, matching rows by hand, and investigating differences.
This process is slow, error-prone, and does not scale as transaction volume grows.

### Business Impact
- **Revenue leakage goes undetected:** overcharged fees, missing payouts, and
  unprocessed refunds are discovered late or never.
- **Month-end close is delayed:** finance teams spend days matching records
  instead of analyzing them.
- **Financial reporting risk increases:** unreconciled balances make the books
  less reliable for audits and leadership decisions.
- **Payment bugs reach customers first:** engineering learns about failures from
  customer complaints instead of from data.
- **Cash visibility is poor:** treasury cannot reliably tell how much money is
  expected versus how much has actually arrived.

### Who Is Affected
| User | Need |
|---|---|
| Reconciliation analysts | A daily, prioritized list of unmatched items to investigate |
| Controllers / accounting | Confidence that the books are complete before closing the period |
| Treasury | Expected vs. actual cash by account and day |
| Payments engineering | Early detection of systematic payment failures |

### Goal
Build a data platform that automatically:

1. Captures every change in the internal payments database in near real time
2. Ingests processor settlement reports and bank statements reliably, even when
   files arrive late, duplicated, corrected, or malformed
3. Reconciles all three sources daily and classifies every mismatch by reason
4. Prevents incorrect data from reaching finance users through automated quality gates
5. Produces a prioritized break queue and reconciliation reporting that finance
   teams can act on

### Success Criteria
- Every internal transaction is either matched or surfaced as a classified break
- Reconciliation results are reproducible: re-running any day produces identical output
- Late or corrected files are handled automatically without manual reprocessing
- Bad data is blocked before publication, never silently delivered

### Scope Note
Real payment and banking data is confidential, so this project simulates a realistic
payments company: transaction patterns are calibrated on public e-commerce data,
processor and bank files follow published industry formats, FX rates come from a real
public source, and known faults are injected with recorded ground truth so that
reconciliation accuracy can be measured.

## Architecture
See [docs/architecture.md](docs/architecture.md). Diagram coming soon.

## Project Status
- [x] Stage 0: Repository setup
- [ ] Stage 1: Synthetic payments company
- [ ] Stage 2: CDC streaming foundation
- [ ] Stage 3: Silver layer
- [ ] Stage 4: Reconciliation engine
- [ ] Stage 5: Data quality (WAP)
- [ ] Stage 6: Gold layer and serving
- [ ] Stage 7: Orchestration
- [ ] Stage 8: AWS deployment
- [ ] Stage 9: Monitoring, CI/CD, performance
- [ ] Stage 10: Documentation

## Quickstart
Coming in Stage 2.
