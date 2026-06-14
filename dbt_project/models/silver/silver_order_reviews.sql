WITH source AS (
    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp
    FROM {{ source('bronze', 'order_reviews') }}
    WHERE review_id IS NOT NULL
        AND order_id IS NOT NULL
        AND review_score BETWEEN 1 AND 5
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY review_creation_date DESC
        ) AS row_num
    FROM source
)

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM deduped
WHERE row_num = 1