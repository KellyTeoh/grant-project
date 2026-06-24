# Test Plan

## V1 Success Scenario (manual walkthrough)
1. Open app homepage (no login) → ClaimPackage list renders with seeded demo package.
2. Click **Upload Actuals** → drag in sample CSV (10+ rows) → click **Process**.
3. Verify: transactions list shows parsed rows with correct cost centers and amounts.
4. Verify: new ClaimPackage row appears, status = `pending_review`, invoice_count > 0.
5. Open package detail → eligible invoices table populated, exceptions list shows flagged rows.
6. Click an exception → description text visible (AI narrative or rule message).
7. Click **Approve Package** → enter comment → submit.
8. Verify: package status changes to `approved`; ApprovalDecision row in DB.
9. Verify: audit log panel on package shows the approval event with timestamp.
10. Click **Export CSV** → downloaded file contains approved invoice rows.

## Empty State Tests
- Upload CSV with zero rows matching any grant rule → ClaimPackage created with 0 eligible, all rows in exceptions.
- Open package list with no packages → "No packages yet. Upload an actuals report to begin." message shown.
- Exception list empty → "No exceptions flagged for this package." shown.

## Error State Tests
- Upload a malformed CSV (wrong headers) → error toast: "File format not recognised. Expected columns: invoice_number, vendor_name, cost_center, program_code, spend_category, amount, transaction_date."
- Submit approval with empty comment field (if required) → inline validation error.
- Rule engine runs with no active GrantRules → warning banner: "No active grant rules found. Add a rule before processing."

## Permission Tests (post Sprint 4)
- Analyst role attempts to approve package → button disabled, tooltip: "Approver role required."
- Unauthenticated request to `/api/ingest` → 401 returned.
- Analyst cannot edit GrantRules → edit button not rendered.
