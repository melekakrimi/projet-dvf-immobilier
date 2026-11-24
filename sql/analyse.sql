-- evolution du nombre de ventes d'un mois a l'autre
WITH ventes_mois AS (
    SELECT mois, COUNT(*) AS nb_ventes
    FROM v_ventes
    GROUP BY mois
)
SELECT mois,
       nb_ventes,
       LAG(nb_ventes) OVER (ORDER BY mois) AS ventes_mois_prec,
       ROUND((nb_ventes - LAG(nb_ventes) OVER (ORDER BY mois)) * 100.0
             / LAG(nb_ventes) OVER (ORDER BY mois), 1) AS evolution_pct
FROM ventes_mois
ORDER BY mois;

-- classement des departements selon le prix moyen au m2
-- et decoupage en 4 groupes (des plus chers aux moins chers)
WITH prix_dep AS (
    SELECT departement,
           COUNT(*) AS nb_ventes,
           ROUND(AVG(prix_m2), 0) AS prix_m2_moyen
    FROM v_ventes
    GROUP BY departement
)
SELECT departement,
       nb_ventes,
       prix_m2_moyen,
       RANK() OVER (ORDER BY prix_m2_moyen DESC) AS rang,
       NTILE(4) OVER (ORDER BY prix_m2_moyen DESC) AS groupe
FROM prix_dep
ORDER BY rang;