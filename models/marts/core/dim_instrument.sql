{{ config(materialized='table') }}

select
    {{ dbt_utils.generate_surrogate_key(['instrument_id']) }} as instrument_key,
    instrument_id,
    symbol,
    instrument_name,
    asset_class,
    sector,
    currency,
    exchange,
    list_date,
    is_active
from {{ ref('stg_instruments') }}

