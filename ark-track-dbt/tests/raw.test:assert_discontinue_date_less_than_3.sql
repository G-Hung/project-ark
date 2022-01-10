-- If this fails: date diff b/w current_date and current max_date is larger than 2, aka: we don't have new data for 3+ days, 3 is for weekend

WITH base AS (
    SELECT max(date) as max_date
    FROM {{ source('raw', 'test') }}
)

SELECT *, CURRENT_DATE('America/Los_Angeles')
FROM base
WHERE DATE_DIFF(CURRENT_DATE('America/Los_Angeles'), max_date, DAY) > 2
