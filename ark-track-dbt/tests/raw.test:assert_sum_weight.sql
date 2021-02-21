-- If this fails: it means sum of weight is less than 99% for a specific date and fund

SELECT date, fund, SUM(weight) AS total_weight
FROM {{ source('raw', 'test') }}
GROUP BY 1, 2
HAVING SUM(weight) < 99 OR SUM(weight) > 101
