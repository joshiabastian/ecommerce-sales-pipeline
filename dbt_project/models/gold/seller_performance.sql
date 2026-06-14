SELECT
    fs.seller_id,
    ds.seller_city,
    ds.seller_state,
    SUM(fs.total_item_value) AS total_revenue,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    COUNT(fs.order_item_id) AS product_volume,
    COUNT(DISTINCT fs.product_id) AS unique_products_sold
FROM {{ ref('fact_sales') }} fs
LEFT JOIN {{ ref('dim_seller') }} ds
    ON fs.seller_id = ds.seller_id
GROUP BY
    fs.seller_id,
    ds.seller_city,
    ds.seller_state
ORDER BY total_revenue DESC