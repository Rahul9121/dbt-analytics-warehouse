{% snapshot snap_account_attributes %}
{{
  config(
    target_schema='snapshots',
    unique_key='account_id',
    strategy='check',
    check_cols=['risk_rating', 'tier', 'pm_name'],
    invalidate_hard_deletes=True
  )
}}

select
    account_id,
    risk_rating,
    tier,
    pm_name,
    effective_from
from {{ ref('stg_account_attributes') }}

{% endsnapshot %}

