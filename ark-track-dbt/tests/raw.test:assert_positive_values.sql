-- If this fails: it means some reocrds in `shares`, `market_value`, `weight` are non-positive

SELECT date, fund, shares, market_value, weight
FROM {{ source('raw', 'test') }}
WHERE shares <= 0 OR market_value <= 0 OR weight <= 0
