with source as (
    select * from {{ source('capital_markets', 'raw_account_attributes') }}
),

renamed as (
    select
        account_id,
        upper(risk_rating) as risk_rating,
        upper(tier) as tier,
        pm_name,
        cast(effective_from as date) as effective_from
    from source
)

select * from renamed

