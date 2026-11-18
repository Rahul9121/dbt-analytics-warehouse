{{ config(materialized='table') }}

with accounts as (
    select * from {{ ref('stg_accounts') }}
),

attrs as (
    select * from {{ ref('stg_account_attributes') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['a.account_id']) }} as account_key,
    a.account_id,
    a.account_name,
    a.account_type,
    a.base_currency,
    a.desk,
    a.region,
    a.opened_date,
    a.status,
    coalesce(t.risk_rating, 'UNKNOWN') as risk_rating,
    coalesce(t.tier, 'UNASSIGNED') as tier,
    t.pm_name,
    a.status = 'ACTIVE' as is_active
from accounts a
left join attrs t on a.account_id = t.account_id

