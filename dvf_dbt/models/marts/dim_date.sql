-- dimension date : un jour par ligne, de 2023 a 2025
SELECT
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER) AS date_key,
    CAST(d AS DATE)                         AS date_jour,
    EXTRACT(DAY FROM d)::INTEGER            AS jour,
    EXTRACT(MONTH FROM d)::INTEGER          AS mois,
    EXTRACT(QUARTER FROM d)::INTEGER        AS trimestre,
    EXTRACT(YEAR FROM d)::INTEGER           AS annee,
    EXTRACT(ISODOW FROM d) IN (6, 7)        AS est_weekend
FROM generate_series(DATE '2023-01-01', DATE '2025-12-31', INTERVAL '1 day') AS d