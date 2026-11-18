{{ config(materialized='table') }}

with trades as (
    select * from {{ ref('fct_trades') }}
),

accounts as (
    select account_key, desk, region, account_type from {{ ref('dim_account') }}
),

instruments as (
    select instrument_key, asset_class, symbol from {{ ref('dim_instrument') }}
)

select
    t.trade_date,
    a.desk,
    a.region,
    a.account_type,
    i.asset_class,
    count(*) as trade_count,
    sum(t.quantity) as total_quantity,
    sum(t.notional) as gross_notional,
    sum(t.signed_notional) as net_notional,
    sum(case when t.side = 'BUY' then t.notional else 0 end) as buy_notional,
    sum(case when t.side = 'SELL' then t.notional else 0 end) as sell_notional,
    count(distinct t.account_id) as active_accounts,
    count(distinct t.instrument_id) as instruments_traded
from trades t
left join accounts a on t.account_key = a.account_key
left join instruments i on t.instrument_key = i.instrument_key
group by 1, 2, 3, 4, 5

