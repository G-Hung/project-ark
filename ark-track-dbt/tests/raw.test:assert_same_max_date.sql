-- If this fails: the max date are different, ie: some funds are not updated

WITH base AS (
    SELECT fund, max(date) AS max_date
    FROM {{ source('raw', 'test') }}
    -- CTRU is closed
    -- ref: https://www.prnewswire.com/news-releases/ark-investment-management-llc-announces-it-will-close-the-ark-transparency-etf-the-fund-ticker-ctru-301589562.html
    WHERE fund != 'CTRU'
    GROUP BY 1
)

SELECT COUNT(DISTINCT max_date) AS cnt
FROM base
HAVING COUNT(DISTINCT max_date) > 1
