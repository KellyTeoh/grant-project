# PRD — Grant Claim Review & Submission System

## Problem
Finance teams manually download actuals reports from SharePoint, filter invoices against grant rules, and hand-build submission templates. This is slow, error-prone, and creates audit gaps.

## Target Users
Finance analysts, program controllers, grant coordinators, and approvers inside one internal team.

## Core Objects
- **ActualsReport** — imported report file with run date and source path
- **Transaction** — individual spend line from the report
- **Invoice** — deduped payable record linked to transactions
- **GrantRule** — eligibility criteria (cost center, program, spend category, date range, cap)
- **ClaimRecommendation** — AI-classified eligibility decision per invoice
- **Exception** — flagged line requiring human review
- **ClaimPackage** — grouped, reviewer-ready submission set
- **ApprovalDecision** — approve / reject / send-back with comment
- **AuditLog** — every meaningful state change

## MVP Must-Haves
- [ ] Ingest actuals report (CSV/XLSX upload standing in for SharePoint)
- [ ] Parse and store all transactions
- [ ] Run grant-rule engine against each transaction; produce eligibility verdict
- [ ] Auto-flag exceptions (missing cost center, duplicate, over-cap, unmatched program)
- [ ] Generate ClaimPackage with recommended invoices + exception list
- [ ] Reviewer dashboard: view package, exceptions, approve/reject/comment
- [ ] Approval locks package and marks it ready for manual submission
- [ ] Audit trail visible per package

## Non-Goals (v1)
SharePoint live sync, auto-submission, ERP integration, ML models, Power BI dashboards, multi-grant optimizer, mobile app, chatbot.

## Success Scenario
An analyst uploads Monday's actuals CSV → the system parses 400 transactions, classifies 312 as eligible, flags 18 exceptions, and produces a ClaimPackage in under 60 seconds. The approver reviews, comments on 3 exceptions, approves the package, and the team exports the populated grant template — without anyone touching Excel for filtering or rule-checking.
