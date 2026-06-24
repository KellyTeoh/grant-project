create table if not exists actuals_reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  filename text,
  source_path text,
  report_date date,
  row_count int,
  status text default 'ready',
  created_at timestamptz not null default now()
);
alter table actuals_reports enable row level security;
drop policy if exists "actuals_reports_v1_read" on actuals_reports;
create policy "actuals_reports_v1_read" on actuals_reports for select using (true);
drop policy if exists "actuals_reports_v1_write" on actuals_reports;
create policy "actuals_reports_v1_write" on actuals_reports for all using (true) with check (true);

create table if not exists grant_rules (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  grant_name text,
  allowed_cost_centers text[],
  allowed_programs text[],
  allowed_categories text[],
  start_date date,
  end_date date,
  claim_cap numeric,
  is_active boolean default true,
  created_at timestamptz not null default now()
);
alter table grant_rules enable row level security;
drop policy if exists "grant_rules_v1_read" on grant_rules;
create policy "grant_rules_v1_read" on grant_rules for select using (true);
drop policy if exists "grant_rules_v1_write" on grant_rules;
create policy "grant_rules_v1_write" on grant_rules for all using (true) with check (true);

create table if not exists invoices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  invoice_number text unique,
  vendor_name text,
  total_amount numeric,
  transaction_date date,
  cost_center text,
  program_code text,
  created_at timestamptz not null default now()
);
alter table invoices enable row level security;
drop policy if exists "invoices_v1_read" on invoices;
create policy "invoices_v1_read" on invoices for select using (true);
drop policy if exists "invoices_v1_write" on invoices;
create policy "invoices_v1_write" on invoices for all using (true) with check (true);

create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  report_id uuid,
  invoice_number text,
  vendor_name text,
  cost_center text,
  program_code text,
  spend_category text,
  amount numeric,
  transaction_date date,
  created_at timestamptz not null default now()
);
alter table transactions enable row level security;
drop policy if exists "transactions_v1_read" on transactions;
create policy "transactions_v1_read" on transactions for select using (true);
drop policy if exists "transactions_v1_write" on transactions;
create policy "transactions_v1_write" on transactions for all using (true) with check (true);

create table if not exists claim_packages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  report_id uuid,
  grant_rule_id uuid,
  package_name text,
  status text default 'pending_review',
  total_recommended numeric,
  invoice_count int,
  exception_count int,
  created_at timestamptz not null default now()
);
alter table claim_packages enable row level security;
drop policy if exists "claim_packages_v1_read" on claim_packages;
create policy "claim_packages_v1_read" on claim_packages for select using (true);
drop policy if exists "claim_packages_v1_write" on claim_packages;
create policy "claim_packages_v1_write" on claim_packages for all using (true) with check (true);

create table if not exists claim_recommendations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  invoice_id uuid,
  grant_rule_id uuid,
  package_id uuid,
  eligibility_verdict text,
  eligibility_source text default 'rule_engine',
  eligibility_confidence numeric,
  eligibility_review_status text default 'unreviewed',
  rule_match_detail jsonb,
  created_at timestamptz not null default now()
);
alter table claim_recommendations enable row level security;
drop policy if exists "claim_recommendations_v1_read" on claim_recommendations;
create policy "claim_recommendations_v1_read" on claim_recommendations for select using (true);
drop policy if exists "claim_recommendations_v1_write" on claim_recommendations;
create policy "claim_recommendations_v1_write" on claim_recommendations for all using (true) with check (true);

create table if not exists exceptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  invoice_id uuid,
  package_id uuid,
  exception_type text,
  description text,
  description_source text default 'rule_engine',
  description_confidence numeric,
  description_review_status text default 'unreviewed',
  resolution text,
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);
alter table exceptions enable row level security;
drop policy if exists "exceptions_v1_read" on exceptions;
create policy "exceptions_v1_read" on exceptions for select using (true);
drop policy if exists "exceptions_v1_write" on exceptions;
create policy "exceptions_v1_write" on exceptions for all using (true) with check (true);

create table if not exists approval_decisions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  package_id uuid,
  decision text,
  comment text,
  decided_at timestamptz default now(),
  created_at timestamptz not null default now()
);
alter table approval_decisions enable row level security;
drop policy if exists "approval_decisions_v1_read" on approval_decisions;
create policy "approval_decisions_v1_read" on approval_decisions for select using (true);
drop policy if exists "approval_decisions_v1_write" on approval_decisions;
create policy "approval_decisions_v1_write" on approval_decisions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  object_type text,
  object_id uuid,
  action text,
  before_state jsonb,
  after_state jsonb,
  created_at timestamptz not null default now()
);
alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into grant_rules (id, grant_name, allowed_cost_centers, allowed_programs, allowed_categories, start_date, end_date, claim_cap, is_active) values
  (gen_random_uuid(), 'Federal Environment Grant 2024', array['CC-1042','CC-1043','CC-1099'], array['PROG-ENV-01','PROG-ENV-02'], array['equipment','consulting','travel'], '2024-01-01', '2024-12-31', 250000, true),
  (gen_random_uuid(), 'State Infrastructure Fund Q1', array['CC-2010','CC-2011'], array['PROG-INFRA-01'], array['materials','labour','equipment'], '2024-01-01', '2024-03-31', 80000, true)
on conflict do nothing;

insert into actuals_reports (id, filename, source_path, report_date, row_count, status) values
  (gen_random_uuid(), 'actuals_2024_03_11.csv', '/demo/actuals_2024_03_11.csv', '2024-03-11', 24, 'ready'),
  (gen_random_uuid(), 'actuals_2024_03_04.csv', '/demo/actuals_2024_03_04.csv', '2024-03-04', 18, 'ready')
on conflict do nothing;

insert into invoices (id, invoice_number, vendor_name, total_amount, transaction_date, cost_center, program_code) values
  (gen_random_uuid(), 'INV-20240311-001', 'Apex Environmental Ltd', 12400.00, '2024-03-11', 'CC-1042', 'PROG-ENV-01'),
  (gen_random_uuid(), 'INV-20240311-002', 'Greenfield Consulting', 8750.00, '2024-03-11', 'CC-1043', 'PROG-ENV-02'),
  (gen_random_uuid(), 'INV-20240311-003', 'Metro Civil Works', 31200.00, '2024-03-11', 'CC-2010', 'PROG-INFRA-01'),
  (gen_random_uuid(), 'INV-20240311-004', 'Unknown Vendor Co', 5400.00, '2024-03-11', 'CC-9999', 'PROG-UNKNOWN'),
  (gen_random_uuid(), 'INV-20240304-001', 'Apex Environmental Ltd', 9100.00, '2024-03-04', 'CC-1042', 'PROG-ENV-01'),
  (gen_random_uuid(), 'INV-20240304-002', 'BlueSky Travel Agency', 3200.00, '2024-03-04', 'CC-1099', 'PROG-ENV-02')
on conflict (invoice_number) do nothing;

insert into claim_packages (id, package_name, status, total_recommended, invoice_count, exception_count) values
  (gen_random_uuid(), 'Federal Environment Grant 2024 — Week 11', 'pending_review', 34250.00, 3, 1),
  (gen_random_uuid(), 'State Infrastructure Fund — Week 10', 'approved', 31200.00, 1, 0)
on conflict do nothing;