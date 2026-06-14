WITH payments_agg AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value,
        STRING_AGG(DISTINCT payment_type, ', ') AS payment_types
    FROM {{ ref('silver_payments') }}
    GROUP BY order_id
)

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    oi.price,
    oi.freight_value,
    oi.total_item_value,
    p.total_payment_value,
    p.payment_types
FROM {{ ref('silver_order_items') }} oi
LEFT JOIN {{ ref('silver_orders') }} o
    ON oi.order_id = o.order_id
LEFT JOIN payments_agg p
    ON oi.order_id = p.order_id