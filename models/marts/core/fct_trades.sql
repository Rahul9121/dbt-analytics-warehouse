{{
  config(
    materialized='incremental',
    unique_key='trade_id',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
  )
}}

with trades as (
    select * from {{ ref('stg_trades') }}
    {% if is_incremental() %}
    where trade_ts > (select coalesce(max(trade_ts), cast('1900-01-01' as timestamp)) from {{ this }})
    {% endif %}
),

accounts as (
    select account_key, account_id from {{ ref('dim_account') }}
),

instruments as (
    select instrument_key, instrument_id from {{ ref('dim_instrument') }}
),

dates as (
    select date_key, date_day from {{ ref('dim_date') }}
)

select
    t.trade_id,
    a.account_key,
    i.instrument_key,
    d.date_key,
    t.trade_ts,
    t.trade_date,
    t.account_id,
    t.instrument_id,
    t.side,
    t.quantity,
    t.price,
    t.notional,
    t.signed_notional,
    t.trade_currency,
    t.venue,
    t.trader,
    t.order_type
from trades t
inner join accounts a on t.account_id = a.account_id
inner join instruments i on t.instrument_id = i.instrument_id
left join dates d on t.trade_date = d.date_day

