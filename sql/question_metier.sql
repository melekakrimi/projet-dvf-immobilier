-- Q1 : prix moyen au m² par département et par année
SELECT  z.departement,
        d.annee,
        ROUND(AVG(f.prix_m2), 0) AS prix_m2_moyen,
        COUNT(*)                 AS nb_ventes
FROM analytics.fct_ventes f
JOIN analytics.dim_zone z ON z.zone_key = f.zone_key
JOIN analytics.dim_date d ON d.date_key = f.date_key
GROUP BY z.departement, d.annee
ORDER BY z.departement, d.annee;

-- Q2 : prix moyen au m² des maisons vs appartements, par année
SELECT  t.type_bien,
        d.annee,
        ROUND(AVG(f.prix_m2), 0) AS prix_m2_moyen,
        COUNT(*)                 AS nb_ventes
FROM analytics.fct_ventes f
JOIN analytics.dim_type_bien t ON t.type_key = f.type_key
JOIN analytics.dim_date d      ON d.date_key = f.date_key
GROUP BY t.type_bien, d.annee
ORDER BY t.type_bien, d.annee;