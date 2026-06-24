# Architecture

## Stack
- **Frontend**: Next.js 14 (App Router) on Vercel
- **Backend/DB**: Supabase (Postgres + Storage + Edge Functions)
- **AI**: OpenAI GPT-4o via Edge Function (rule explainer + exception narrative)
- **File handling**: Supabase Storage for uploaded CSVs; papaparse in-browser for parsing

## Now vs Later
**Now**: CSV upload → rule engine → ClaimPackage → approval workflow
**Next**: SharePoint OAuth connector, richer rule editor UI, email notifications
**Later**: Direct grant portal export, audit PDF export, multi-grant optimization

## Key Action Flow (Upload → Approved Package)
1. Analyst uploads actuals CSV via UI
2. Browser parses rows; app POSTs batch to `/api/ingest`
3. Edge Function upserts Transactions, dedupes Invoices
4. Rule engine (Postgres function + TS logic) scores each Invoice against active GrantRules → writes ClaimRecommendations
5. Exception detector writes Exception rows for every failed rule
6. ClaimPackage record created, status = `pending_review`
7. Approver opens package dashboard, reads recommendations + exceptions
8. Approver submits ApprovalDecision; package status → `approved` or `returned`
9. AuditLog entry written for every transition

## Layer Plan
1. **Data layer first** — tables, rules, RLS policies, seed data
2. **App logic** — ingest API, rule engine, package builder (no AI needed)
3. **Smart layer** — AI exception narratives, eligibility confidence scores

## Core Without AI
Rule engine is pure coded logic (cost center match, date range, cap checks). AI only adds explanatory text and confidence scores — removing it leaves the workflow fully functional.
