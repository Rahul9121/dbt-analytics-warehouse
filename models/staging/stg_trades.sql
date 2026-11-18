with batch1 as (
    select * from {{ source('capital_markets', 'raw_trades') }}
),

batch2 as (
    {% if var('load_batch_2', false) %}
    select * from {{ source('capital_markets', 'raw_trades_batch2') }}
    {% else %}
    select * from {{ source('capital_markets', 'raw_trades') }} where 1 = 0
    {% endif %}
),

unioned as (
    select * from batch1
    union all
    select * from batch2
),

renamed as (
    select
        trade_id,
        cast(trade_ts as timestamp) as trade_ts,
        cast(trade_ts as date) as trade_date,
        account_id,
        instrument_id,
        upper(side) as side,
        cast(quantity as double) as quantity,
        cast(price as double) as price,
        cast(notional as double) as notional,
        upper(trade_currency) as trade_currency,
        upper(venue) as venue,
        lower(trader) as trader,
        upper(order_type) as order_type,
        case when upper(side) = 'BUY' then cast(notional as double)
             else -1 * cast(notional as double)
        end as signed_notional
    from unioned
)

select * from renamed

