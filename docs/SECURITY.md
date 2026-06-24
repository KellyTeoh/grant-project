# Security

## Secrets
- OpenAI API key stored in Vercel + Supabase Edge Function env vars only — never in frontend bundle or client-side code.
- Supabase service role key used only in Edge Functions, never exposed to browser.
- SharePoint credentials (future) stored as Supabase Vault secrets.

## Permission Model (v1 → Lock-down)
- **v1**: Permissive RLS policies — all tables readable and writable without login. Safe for internal demo; no sensitive data yet.
- **Lock-down sprint**: Replace with `auth.uid() = user_id` owner policies. Add role column to users: `analyst`, `coordinator`, `approver`, `admin`.
- Approvers can write ApprovalDecisions; analysts can ingest and view; coordinators can build packages; admins manage GrantRules.

## Approved Tools Rule
- Agent may only call the five named tools in AGENTIC_LAYER.md.
- No `run_any`, `eval`, or raw SQL execution from the frontend.
- All tool calls go through typed Edge Function endpoints with input validation.

## Audit Principle
- Every status change on ClaimPackage, every ApprovalDecision, and every exception resolution writes an AuditLog row.
- AuditLog is append-only (no update/delete policy even after lock-down).
- Logs include `before_state` and `after_state` as JSONB for full traceability.
