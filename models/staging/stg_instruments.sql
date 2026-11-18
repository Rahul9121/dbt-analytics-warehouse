with source as (
    select * from {{ source('capital_markets', 'raw_instruments') }}
),

renamed as (
    select
        instrument_id,
        upper(symbol) as symbol,
        instrument_name,
        upper(asset_class) as asset_class,
        sector,
        upper(currency) as currency,
        upper(exchange) as exchange,
        cast(list_date as date) as list_date,
        cast(is_active as boolean) as is_active
    from source
)

select * from renamed

