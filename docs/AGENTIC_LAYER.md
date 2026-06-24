# Agentic Layer

## Risk Levels & Actions

### Low Risk — Auto-execute (no approval needed)
- Parse uploaded CSV and store transactions *(summarize/ingest)*
- Run rule engine and write ClaimRecommendations *(classify)*
- Generate exception descriptions via AI *(draft narrative)*
- Score each invoice (confidence 0–1) *(score)*

### Medium Risk — Auto-draft, human confirms
- Create ClaimPackage from recommendations *(status: pending_review)*
- Mark exception as resolved after reviewer comments *(status update)*

### High Risk — Always requires explicit approval
- Set ClaimPackage status to `approved` *(requires ApprovalDecision record)*
- Export populated grant submission template *(triggers downstream use)*

### Critical — Human-only, never automated
- Delete ClaimPackage or audit records
- Override an already-approved package
- Resubmit a previously submitted claim

## Named Tools (v1)
| Tool | Action | Risk |
|---|---|---|
| `ingest_actuals` | parse CSV → upsert transactions + invoices | low |
| `run_rule_engine` | score invoices → write recommendations + exceptions | low |
| `generate_exception_narrative` | AI plain-English description per exception | low |
| `build_claim_package` | group eligible invoices → create package | medium |
| `submit_approval_decision` | write ApprovalDecision → update package status | high |

## Audit Log Fields
`object_type`, `object_id`, `action`, `user_id`, `before_state (jsonb)`, `after_state (jsonb)`, `created_at`

## v1 vs Later
**v1**: tools 1–5 above, all human-triggered or rule-driven.
**Later**: scheduled SharePoint sync (`sync_sharepoint_report` — medium), email notification on package ready (high).
