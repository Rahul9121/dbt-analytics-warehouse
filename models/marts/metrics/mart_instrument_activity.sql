{{ config(materialized='table') }}

select
    i.instrument_id,
    i.symbol,
    i.asset_class,
    i.sector,
    count(*) as trade_count,
    sum(t.notional) as gross_notional,
    avg(t.price) as avg_price,
    min(t.trade_date) as first_trade_date,
    max(t.trade_date) as last_trade_date,
    sum(case when t.side = 'BUY' then t.quantity else 0 end) as buy_qty,
    sum(case when t.side = 'SELL' then t.quantity else 0 end) as sell_qty
from {{ ref('fct_trades') }} t
inner join {{ ref('dim_instrument') }} i on t.instrument_key = i.instrument_key
group by 1, 2, 3, 4

