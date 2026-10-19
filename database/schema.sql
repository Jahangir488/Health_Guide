-- Proposed schema for a future clinician-reviewed content database.
-- Do not add patient records until privacy, security, retention, and consent
-- requirements have been designed and reviewed.

create table if not exists content_sources (
  id bigserial primary key,
  title text not null,
  publisher text not null,
  source_url text not null,
  country_code char(2),
  accessed_on date not null,
  notes text
);

create table if not exists content_reviews (
  id bigserial primary key,
  content_type text not null check (content_type in ('symptom', 'condition', 'medicine', 'interaction', 'safety_rule')),
  content_key text not null,
  version integer not null default 1,
  reviewer_role text not null,
  reviewed_on date,
  approval_status text not null default 'draft' check (approval_status in ('draft', 'in_review', 'approved', 'retired')),
  source_id bigint references content_sources(id),
  review_notes text,
  unique(content_type, content_key, version)
);

create table if not exists medicines (
  id bigserial primary key,
  generic_name text not null,
  local_names jsonb not null default '{}'::jsonb,
  general_uses text not null,
  contraindications text,
  warnings text,
  interaction_summary text,
  source_id bigint references content_sources(id),
  review_id bigint references content_reviews(id),
  is_published boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists symptoms (
  id text primary key,
  name_en text not null,
  name_bn text,
  description text,
  review_id bigint references content_reviews(id),
  is_published boolean not null default false
);

create table if not exists safety_rules (
  id bigserial primary key,
  rule_key text unique not null,
  symptom_ids text[] not null,
  urgency text not null check (urgency in ('emergency', 'urgent', 'routine')),
  action_en text not null,
  action_bn text,
  review_id bigint references content_reviews(id),
  is_enabled boolean not null default false
);
