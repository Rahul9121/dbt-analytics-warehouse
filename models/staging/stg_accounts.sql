with source as (
    select * from {{ source('capital_markets', 'raw_accounts') }}
),

renamed as (
    select
        account_id,
        account_name,
        upper(account_type) as account_type,
        upper(base_currency) as base_currency,
        desk,
        upper(region) as region,
        cast(opened_date as date) as opened_date,
        upper(status) as status
    from source
)

select * from renamed

