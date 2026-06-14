SELECT
    order_id,
    payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    payment_installments,
    payment_value
FROM {{ source('bronze', 'order_payments') }}
WHERE order_id IS NOT NULL
    AND payment_value >= 0