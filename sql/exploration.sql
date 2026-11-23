-- Projet fil rouge : exploration des données
-- ==============================================================================

-- 1. Répartition par type de bien
-- Résultat : NULL (terrains) 1 461 780 | Dépendance 911 912
--            Maison 548 981 | Appartement 470 995 | Local 111 672
-- Choix : on garde Maison et Appartement (marché résidentiel)
SELECT type_local, COUNT(*) AS nb
FROM staging_dvf
GROUP BY type_local
ORDER BY nb DESC;

-- 2. Répartition par nature de mutation (6 valeurs)
-- Résultat : Vente 3 264 011 | VEFA 172 335 | Echange 48 768
--            Adjudication 10 066 | Terrain à bâtir 7 740 | Expropriation 2 420
SELECT nature_mutation, COUNT(*) AS nb
FROM staging_dvf
GROUP BY nature_mutation
ORDER BY nb DESC;

-- 3. Ventes contenant un seul bien résidentiel (évite le fan-out
--    de valeur_fonciere répétée sur plusieurs lignes)
SELECT COUNT(*) AS nb_ventes_simples
FROM (
    SELECT id_mutation
    FROM staging_dvf
    WHERE type_local IN ('Maison', 'Appartement')
    GROUP BY id_mutation
    HAVING COUNT(*) = 1
) t;