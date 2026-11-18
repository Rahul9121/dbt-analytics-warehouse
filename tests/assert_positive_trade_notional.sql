-- Every trade must carry a positive absolute notional.
select
    trade_id,
    notional
from {{ ref('fct_trades') }}
where notional is null
   or notional <= 0

