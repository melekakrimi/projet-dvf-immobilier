-- vue avec les ventes normales seulement
-- on enleve les prix au m2 bizarres (moins de 500 ou plus de 30000)
-- et les surfaces bizarres (moins de 9 m2 ou plus de 1000 m2)
CREATE VIEW v_ventes AS
SELECT f.id_vente,
       d.date_complete,
       d.mois,
       d.trimestre,
       d.annee,
       com.nom   AS commune,
       dep.code  AS departement,
       t.libelle AS type_bien,
       n.libelle AS nature_vente,
       f.prix,
       f.surface,
       f.nb_pieces,
       ROUND(f.prix / f.surface, 0) AS prix_m2
FROM fait_vente f
JOIN dim_date d          ON f.id_date     = d.id_date
JOIN dim_zone com        ON f.id_zone     = com.id_zone
JOIN dim_zone dep        ON com.id_parent = dep.id_zone
JOIN dim_type_bien t     ON f.id_type     = t.id_type
JOIN dim_nature_vente n  ON f.id_nature   = n.id_nature
WHERE f.prix / f.surface BETWEEN 500 AND 30000
  AND f.surface BETWEEN 9 AND 1000;
-- test nombre des ventes dans la vue 
SELECT COUNT(*) FROM v_ventes;
-- verification des valeurs vides 
SELECT COUNT(*) - COUNT(date_complete) AS date_vide,
       COUNT(*) - COUNT(commune)       AS commune_vide,
       COUNT(*) - COUNT(type_bien)     AS type_vide,
       COUNT(*) - COUNT(prix)          AS prix_vide,
       COUNT(*) - COUNT(nb_pieces)     AS pieces_vide
FROM v_ventes;
-- verification que les prix sont a la bonne limite 
SELECT MIN(prix_m2), MAX(prix_m2),
       MIN(surface), MAX(surface),
       MIN(date_complete), MAX(date_complete)
FROM v_ventes;
-- verification des doublons 
SELECT COUNT(*) - COUNT(DISTINCT id_vente) AS doublons FROM v_ventes;
-- prix m² par depart
SELECT departement, ROUND(AVG(prix_m2), 0) AS prix_m2_moyen
FROM v_ventes
GROUP BY departement
ORDER BY prix_m2_moyen DESC
LIMIT 5;