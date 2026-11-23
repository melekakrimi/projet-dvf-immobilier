SELECT t.libelle, COUNT(*) AS nb_ventes,
       ROUND(AVG(f.prix / f.surface), 0) AS prix_m2_moyen
FROM fait_vente f
JOIN dim_type_bien t ON f.id_type = t.id_type
GROUP BY t.libelle;

SELECT d.mois, COUNT(*) AS nb_ventes
FROM fait_vente f
JOIN dim_date d ON f.id_date = d.id_date
GROUP BY d.mois
ORDER BY d.mois;

SELECT dep.nom AS departement, COUNT(*) AS nb_ventes
FROM fait_vente f
JOIN dim_zone com ON f.id_zone = com.id_zone
JOIN dim_zone dep ON com.id_parent = dep.id_zone
GROUP BY dep.nom
ORDER BY nb_ventes DESC
LIMIT 10;

