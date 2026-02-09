select
  order_date,
  sum(revenue) as revenue_daily,
  count(distinct order_id) as orders,
  sum(quantity) as units
from {{ ref('fact_orders') }}
group by 1
