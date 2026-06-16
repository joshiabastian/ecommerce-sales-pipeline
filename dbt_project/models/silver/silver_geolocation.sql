SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS geolocation_lat,
    AVG(geolocation_lng) AS geolocation_lng,
    LOWER(TRIM(MAX(geolocation_city))) AS geolocation_city,
    UPPER(TRIM(MAX(geolocation_state))) AS geolocation_state
FROM {{ source('bronze', 'geolocation') }}
WHERE geolocation_zip_code_prefix IS NOT NULL
GROUP BY geolocation_zip_code_prefix