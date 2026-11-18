-- signed_notional must equal +notional on BUY and -notional on SELL.
select
    trade_id,
    side,
    notional,
    signed_notional
from {{ ref('fct_trades') }}
where (side = 'BUY' and signed_notional <> notional)
   or (side = 'SELL' and signed_notional <> -1 * notional)

