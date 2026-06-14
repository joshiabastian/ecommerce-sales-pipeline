WITH products AS (
    SELECT
        product_id,
        product_category_name,
        CAST(CAST(product_name_lenght AS NUMERIC) AS INTEGER) AS product_name_length,
        CAST(CAST(product_description_lenght AS NUMERIC) AS INTEGER) AS product_description_length,
        CAST(CAST(product_photos_qty AS NUMERIC) AS INTEGER) AS product_photos_qty,
        CAST(product_weight_g AS NUMERIC) AS product_weight_g,
        CAST(product_length_cm AS NUMERIC) AS product_length_cm,
        CAST(product_height_cm AS NUMERIC) AS product_height_cm,
        CAST(product_width_cm AS NUMERIC) AS product_width_cm
    FROM {{ source('bronze', 'products') }}
    WHERE product_id IS NOT NULL
),

translation AS (
    SELECT
        product_category_name,
        product_category_name_english
    FROM {{ source('bronze', 'product_category_translation') }}
)

SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(t.product_category_name_english, 'unknown') AS product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN translation t
    ON p.product_category_name = t.product_category_name