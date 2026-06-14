SELECT
    DATE(order_purchase_timestamp) AS order_date,
    SUM(total_item_value) AS daily_revenue,
    COUNT(DISTINCT order_id) AS daily_orders,
    COUNT(DISTINCT customer_id) AS daily_customers
FROM {{ ref('fact_sales') }}
GROUP BY DATE(order_purchase_timestamp)
ORDER BY order_date