{{ config(materialized='table') }}

with bounds as (
    select
        cast('2024-01-01' as date) as start_date,
        cast('2024-03-31' as date) as end_date
),

spine as (
    select
        cast(start_date + interval (gs.i) day as date) as date_day
    from bounds
    cross join generate_series(0, datediff('day', start_date, end_date)) as gs(i)
)

select
    cast(strftime(date_day, '%Y%m%d') as integer) as date_key,
    date_day,
    extract(year from date_day) as year_num,
    extract(quarter from date_day) as quarter_num,
    extract(month from date_day) as month_num,
    strftime(date_day, '%Y-%m') as year_month,
    extract(day from date_day) as day_of_month,
    extract(dow from date_day) as day_of_week,
    strftime(date_day, '%A') as day_name,
    case when extract(dow from date_day) in (0, 6) then true else false end as is_weekend
from spine

