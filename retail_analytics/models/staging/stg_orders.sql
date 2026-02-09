with src as (
    select *
    from {{ source('cleaned', 'clean_crawler_cleaned') }}
),

typed as (
    select
        cast(order_id as varchar)          as order_id,
        cast(order_date as date)           as order_date,
        cast(ship_mode as varchar)         as ship_mode,
        cast(segment as varchar)           as segment,
        cast(country as varchar)           as country,
        cast(city as varchar)              as city,
        cast(state as varchar)             as state,
        cast(postal_code as varchar)       as postal_code,
        cast(region as varchar)            as region,
        cast(category as varchar)          as category,
        cast(sub_category as varchar)      as sub_category,
        cast(product_id as varchar)        as product_id,
        cast(cost_price as double)         as cost_price,
        cast(list_price as double)         as list_price,
        cast(quantity as integer)          as quantity,
        cast(discount_percent as double)   as discount_percent,

        -- return flag
        case
          when cast(list_price as double) < 0
            or cast(quantity as integer) < 0
          then true else false
        end as is_return,

        -- clean list price for sales rows
        case
          when cast(list_price as double) < 0 then null
          else cast(list_price as double)
        end as list_price_clean

    from src
),

final as (
    select
      *,
      case
        when is_return then null
        else quantity * list_price_clean * (1 - discount_percent/100)
      end as revenue_clean
    from typed
)

select * from final
