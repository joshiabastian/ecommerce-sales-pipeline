SELECT
    dc.customer_state,
    sg.geolocation_lat,
    sg.geolocation_lng,
    sg.geolocation_city,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.total_item_value) AS total_revenue
FROM {{ ref('fact_sales') }} fs
LEFT JOIN {{ ref('dim_customer') }} dc
    ON fs.customer_id = dc.customer_id
LEFT JOIN {{ ref('silver_geolocation') }} sg
    ON dc.customer_zip_code_prefix = sg.geolocation_zip_code_prefix
WHERE fs.order_purchase_timestamp >= '2017-01-01'
    AND fs.order_purchase_timestamp < '2018-09-01'
    AND sg.geolocation_lat IS NOT NULL
    AND sg.geolocation_lng IS NOT NULL
GROUP BY
    dc.customer_state,
    sg.geolocation_lat,
    sg.geolocation_lng,
    sg.geolocation_city