# Intelligence Layer

## Messy Inputs
- CSV actuals with inconsistent cost center codes, blank program fields, duplicate invoice numbers, mixed date formats
- Free-text vendor names that don't map cleanly to grant categories

## Auto-Structure Schema (per Transaction)
```json
{
  "invoice_number": "INV-20240312-0041",
  "normalized_cost_center": "CC-1042",
  "normalized_program": "PROG-ENV-02",
  "spend_category": "equipment",
  "amount": 4820.00,
  "transaction_date": "2024-03-12",
  "flags": ["duplicate_candidate"],
  "eligibility_verdict": "eligible",
  "eligibility_confidence": 0.94,
  "eligibility_source": "rule_engine"
}
```

## Events to Track
- Report uploaded
- Transaction parsed and stored
- Rule engine run completed
- Exception flagged
- ClaimPackage generated
- Recommendation reviewed/overridden
- Package approved/returned

## Scoring Rules (Rule-Based v1)
| Check | Pass Condition | Weight |
|---|---|---|
| Cost center match | In grant's allowed list | Required |
| Program code match | In grant's allowed list | Required |
| Date in range | Between start_date and end_date | Required |
| Spend category | In allowed categories | Required |
| Amount under cap | Cumulative ≤ claim_cap | Required |
| No duplicate | invoice_number not already claimed | Required |

All required checks must pass → `eligible`. Any fail → `exception` or `ineligible`.

## AI Role (v1)
- Generate plain-English exception description (stored with source + confidence)
- Summarize ClaimPackage for approver (total eligible, top exceptions, risk notes)

## Later
- Confidence scoring using historical approval patterns
- Vendor name fuzzy-matching to grant categories
- Anomaly detection on spend spikes
