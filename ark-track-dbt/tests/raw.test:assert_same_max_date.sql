-- If this fails: the max date are different, aka: some funds are not updated

WITH base AS (
    SELECT fund, max(date) AS max_date
    FROM {{ source('raw', 'test') }}
    GROUP BY 1
)

SELECT COUNT(DISTINCT max_date) AS cnt
FROM base
HAVING COUNT(DISTINCT max_date) > 1
