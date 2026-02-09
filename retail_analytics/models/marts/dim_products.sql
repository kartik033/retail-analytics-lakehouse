select distinct
  product_id,
  category,
  sub_category
from {{ ref('stg_orders') }}
where product_id is not null
