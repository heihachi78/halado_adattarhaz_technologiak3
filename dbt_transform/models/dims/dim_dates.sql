SELECT 
    d::DATE AS date_id,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    EXTRACT(DAY FROM d) AS day,
    EXTRACT(QUARTER FROM d) AS quarter,
    ceil((EXTRACT(DAY FROM d)) / 7) AS week_of_month,
    EXTRACT(ISODOW FROM d) AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    TO_CHAR(d, 'Month') AS month_name
FROM GENERATE_SERIES('2000-01-01'::DATE, CURRENT_DATE, '1 day'::INTERVAL) d
