# Data Model

## actuals_reports
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | uploader |
| filename | text | original file name |
| source_path | text | Supabase Storage URL |
| report_date | date | period covered |
| row_count | int | parsed rows |
| status | text | `processing` `ready` `failed` |
| created_at | timestamptz | |

## transactions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| report_id | uuid FK actuals_reports | |
| invoice_number | text | |
| vendor_name | text | |
| cost_center | text | |
| program_code | text | |
| spend_category | text | |
| amount | numeric | |
| transaction_date | date | |
| created_at | timestamptz | |

## invoices
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| invoice_number | text unique | |
| vendor_name | text | |
| total_amount | numeric | |
| transaction_date | date | |
| cost_center | text | |
| program_code | text | |
| created_at | timestamptz | |

## grant_rules
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| grant_name | text | |
| allowed_cost_centers | text[] | |
| allowed_programs | text[] | |
| allowed_categories | text[] | |
| start_date | date | |
| end_date | date | |
| claim_cap | numeric | |
| is_active | boolean | |
| created_at | timestamptz | |

## claim_recommendations
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| invoice_id | uuid FK invoices | |
| grant_rule_id | uuid FK grant_rules | |
| package_id | uuid FK claim_packages | |
| eligibility_verdict | text | `eligible` `ineligible` `exception` — **AI field** |
| eligibility_source | text | `rule_engine` or `ai_review` |
| eligibility_confidence | numeric | 0–1 |
| eligibility_review_status | text | `unreviewed` `confirmed` `overridden` |
| rule_match_detail | jsonb | which rules passed/failed |
| created_at | timestamptz | |

## exceptions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| invoice_id | uuid FK invoices | |
| package_id | uuid FK claim_packages | |
| exception_type | text | `missing_cost_center` `duplicate` `over_cap` `unmatched_program` `date_out_of_range` |
| description | text | **AI field** — narrative |
| description_source | text | `rule_engine` `ai_narrative` |
| description_confidence | numeric | 0–1 |
| description_review_status | text | `unreviewed` `confirmed` |
| resolution | text | reviewer note |
| resolved_at | timestamptz | |
| created_at | timestamptz | |

## claim_packages
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| report_id | uuid FK actuals_reports | |
| grant_rule_id | uuid FK grant_rules | |
| package_name | text | |
| status | text | `pending_review` `approved` `returned` `submitted` |
| total_recommended | numeric | |
| invoice_count | int | |
| exception_count | int | |
| created_at | timestamptz | |

## approval_decisions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| package_id | uuid FK claim_packages | |
| decision | text | `approved` `rejected` `returned` |
| comment | text | |
| decided_at | timestamptz | |
| created_at | timestamptz | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| object_type | text | table name |
| object_id | uuid | row id |
| action | text | e.g. `package_approved` |
| before_state | jsonb | |
| after_state | jsonb | |
| created_at | timestamptz | |

## RLS
All tables: RLS enabled. v1 = permissive open policies (select + all). Lock-down sprint replaces with `auth.uid() = user_id`.
