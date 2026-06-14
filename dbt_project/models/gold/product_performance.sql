SELECT
    fs.product_id,
    dp.product_category_name_english,
    SUM(fs.total_item_value) AS total_revenue,
    SUM(fs.price) AS total_price_revenue,
    COUNT(fs.order_item_id) AS quantity_sold,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    ROUND(AVG(fs.total_item_value), 2) AS avg_order_value
FROM {{ ref('fact_sales') }} fs
LEFT JOIN {{ ref('dim_product') }} dp
    ON fs.product_id = dp.product_id
GROUP BY
    fs.product_id,
    dp.product_category_name_english
ORDER BY total_revenue DESC