-- If this fails: (date, fund, company) pair is not unique

SELECT date, fund, company
FROM {{ source('raw', 'test') }}
-- Seemingly for cash, they split to multiple rows and make the pair not unique
-- Hardcode to remove them, we only concern the real companies, not cash
WHERE company NOT IN ('HONG KONG DOLLAR', 'JAPANESE YEN', 'U.S. DOLLAR')
GROUP BY 1, 2, 3
HAVING COUNT(1) > 1
