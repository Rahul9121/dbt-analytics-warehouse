{% docs __overview__ %}
# dbt Analytics Warehouse

A small dimensional warehouse for capital-markets style trade data. Built with **dbt** on **DuckDB**.

## What you will find

- **Sources / seeds** — synthetic accounts, instruments, trades, and account risk attributes
- **Staging** — light renaming and typing (`stg_*`)
- **Core marts** — `dim_account`, `dim_instrument`, `dim_date`, incremental `fct_trades`
- **Snapshot** — `snap_account_attributes` (SCD type 2 on risk rating / tier)
- **Metrics marts** — daily volume and instrument activity
- **Tests** — unique, not_null, relationships, accepted_values, plus two singular tests

## How data flows

Seeds land in a `raw` schema. Staging views clean them. Dimensions and the trade fact live in `marts`. Metrics models roll the fact up for reporting. A second trade batch and an updated attributes file demonstrate incremental loads and SCD2.

## Scope

This project was developed and CI-tested on DuckDB only. The same dbt models can point at Snowflake or another warehouse by swapping the profile adapter; that path is not exercised here.

{% enddocs %}

