-- If this fails: (date, fund, company) pair is not unique

SELECT date, fund, company
FROM {{ source('raw', 'test') }}
GROUP BY 1, 2, 3
HAVING COUNT(1) > 1
