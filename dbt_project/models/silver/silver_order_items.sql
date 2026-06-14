WITH source AS (
    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    FROM {{ source('bronze', 'order_items') }}
    WHERE order_id IS NOT NULL
        AND product_id IS NOT NULL
        AND seller_id IS NOT NULL
)

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    (price + freight_value) AS total_item_value
FROM source
WHERE price >= 0
    AND freight_value >= 0