{{ config(materialized='incremental', unique_key='order_line_key') }}

select
  concat(order_id, '-', product_id) as order_line_key,
  order_id,
  order_date,
  product_id,
  category,
  sub_category,
  region,
  city,
  state,
  postal_code,
  ship_mode,
  segment,
  quantity,
  list_price,
  discount_percent,
  revenue_clean
from {{ ref('stg_orders') }}

{% if is_incremental() %}
  where order_date > (select max(order_date) from {{ this }})
{% endif %}
