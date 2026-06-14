WITH date_spine AS (
    SELECT
        generate_series(
            '2016-01-01'::date,
            '2020-12-31'::date,
            '1 day'::interval
        )::date AS date_day
)

SELECT
    date_day,
    EXTRACT(YEAR FROM date_day)::INTEGER AS year,
    EXTRACT(QUARTER FROM date_day)::INTEGER AS quarter,
    EXTRACT(MONTH FROM date_day)::INTEGER AS month,
    EXTRACT(DAY FROM date_day)::INTEGER AS day,
    EXTRACT(DOW FROM date_day)::INTEGER AS day_of_week,
    TRIM(TO_CHAR(date_day, 'Day')) AS day_name,
    TRIM(TO_CHAR(date_day, 'Month')) AS month_name,
    CASE
        WHEN EXTRACT(DOW FROM date_day) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM date_spine