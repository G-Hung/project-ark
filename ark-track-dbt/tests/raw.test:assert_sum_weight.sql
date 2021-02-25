-- If this fails: it means sum of weight is less than 99% for a specific date and fund

-- warning instead, it is possible the sum < 99, eg on 24 Feb 2021
{{
    config(
        severity='warn'
    )
}}

SELECT date, fund, SUM(weight) AS total_weight
FROM {{ source('raw', 'test') }}
GROUP BY 1, 2
HAVING SUM(weight) < 99 OR SUM(weight) > 101
