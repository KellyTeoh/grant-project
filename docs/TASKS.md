# Tasks & Sprints

## Sprint 1 — Data Foundation + Ingest Engine ✦ core engine
**Goal**: DB live, CSV upload parses real transactions, rule engine runs, ClaimPackage visible without login.
- [ ] Write and apply migration SQL (all tables, RLS v1, seed data)
- [ ] Build CSV upload UI (drag-and-drop, papaparse)
- [ ] `/api/ingest` Edge Function: parse → upsert transactions + invoices
- [ ] Rule engine function: score each invoice against active GrantRules → write ClaimRecommendations + Exceptions
- [ ] Auto-create ClaimPackage on ingest completion (status: `pending_review`)
- [ ] Transactions list page (filterable by cost center, program, verdict)
- [ ] Seed 2 GrantRules, 1 ActualsReport, 20 Transactions, 1 ClaimPackage

**Definition of Done**: Upload a CSV → transactions appear in DB → recommendations written → ClaimPackage row exists → list page renders without login.

---

## Sprint 2 — Reviewer Dashboard + Approval Workflow ✦ v1 functional milestone
**Goal**: Approver can open a package, review exceptions, and approve or return it.
- [ ] ClaimPackage list page (status badges, totals)
- [ ] Package detail page: eligible invoices table, exceptions list, summary stats
- [ ] Exception detail view with type + description
- [ ] Approve / Return / Comment form → writes ApprovalDecision → updates package status
- [ ] Audit trail panel on package detail
- [ ] Empty state and error state on all pages
- [ ] AI exception narrative (calls `generate_exception_narrative` Edge Function, stores result)

**Definition of Done**: Full scenario works — upload CSV, package generated, approver reviews exceptions, submits approval, status updates, audit log entry written. ✦ v1 functional

---

## Sprint 3 — Grant Rule Manager + Package Export
**Goal**: Team can manage grant rules in-app and export the approved claim package.
- [ ] GrantRule CRUD UI (add/edit/deactivate rules)
- [ ] Export approved package as CSV (invoice list + amounts + verdicts)
- [ ] Duplicate detection UI (highlight duplicate invoice_numbers across packages)
- [ ] Package summary AI narrative (total eligible, risk notes)
- [ ] Basic search/filter on transactions page

**Definition of Done**: New grant rule saved, ingest re-run uses it, approved package exportable as CSV.

---

## Sprint 4 — Lock It Down (Auth + Per-User RLS)
**Goal**: Real users log in; data is owner-scoped; roles enforced.
- [ ] Supabase Auth (email/password)
- [ ] Login/signup pages (redirect after auth)
- [ ] Populate `user_id` on all writes
- [ ] Replace v1 open RLS policies with `auth.uid() = user_id` owner policies
- [ ] Role column on users: analyst / coordinator / approver / admin
- [ ] Gate ApprovalDecision writes to `approver` role
- [ ] Gate GrantRule writes to `admin` role

**Definition of Done**: Anonymous access blocked; each user sees only their data; approval action rejected for non-approver role.

---

## Sprint 5 — SharePoint Connector + Notifications (Next)
**Goal**: Eliminate manual CSV download; notify team on new package.
- [ ] SharePoint OAuth connector (scheduled Edge Function)
- [ ] Auto-ingest latest actuals on schedule
- [ ] Email notification to approvers when package status = `pending_review`
- [ ] Ingest history log page

---

## Gantt (Sprint → Feature)
```
Sprint 1 | DB + ingest + rule engine + seeded list page
Sprint 2 | Reviewer dashboard + approval + audit trail       ← v1 functional
Sprint 3 | Rule manager + export + duplicate detection
Sprint 4 | Auth + RLS lock-down + roles
Sprint 5 | SharePoint sync + email notifications
```
