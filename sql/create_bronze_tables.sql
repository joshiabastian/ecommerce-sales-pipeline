CREATE TABLE IF NOT EXISTS bronze.orders (
    order_id                        VARCHAR,
    customer_id                     VARCHAR,
    order_status                    VARCHAR,
    order_purchase_timestamp        TIMESTAMP,
    order_approved_at               TIMESTAMP,
    order_delivered_carrier_date    TIMESTAMP,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.order_items (
    order_id                VARCHAR,
    order_item_id           INTEGER,
    product_id              VARCHAR,
    seller_id               VARCHAR,
    shipping_limit_date     TIMESTAMP,
    price                   NUMERIC,
    freight_value           NUMERIC
);

CREATE TABLE IF NOT EXISTS bronze.order_payments (
    order_id                VARCHAR,
    payment_sequential      INTEGER,
    payment_type            VARCHAR,
    payment_installments    INTEGER,
    payment_value           NUMERIC
);

CREATE TABLE IF NOT EXISTS bronze.customers (
    customer_id                 VARCHAR,
    customer_unique_id          VARCHAR,
    customer_zip_code_prefix    VARCHAR,
    customer_city               VARCHAR,
    customer_state              VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.sellers (
    seller_id                   VARCHAR,
    seller_zip_code_prefix      VARCHAR,
    seller_city                 VARCHAR,
    seller_state                VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.products (
    product_id                      VARCHAR,
    product_category_name           VARCHAR,
    product_name_lenght             VARCHAR,
    product_description_lenght      VARCHAR,
    product_photos_qty              VARCHAR,
    product_weight_g                VARCHAR,
    product_length_cm               VARCHAR,
    product_height_cm               VARCHAR,
    product_width_cm                VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.order_reviews (
    review_id                   VARCHAR,
    order_id                    VARCHAR,
    review_score                INTEGER,
    review_comment_title        VARCHAR,
    review_comment_message      VARCHAR,
    review_creation_date        TIMESTAMP,
    review_answer_timestamp     TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.geolocation (
    geolocation_zip_code_prefix VARCHAR,
    geolocation_lat             DOUBLE PRECISION,
    geolocation_lng             DOUBLE PRECISION,
    geolocation_city            VARCHAR,
    geolocation_state           VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze.product_category_translation (
    product_category_name           VARCHAR,
    product_category_name_english   VARCHAR
);