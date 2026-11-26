-- dimension zone en etoile : la hierarchie est aplatie en colonnes
-- une ligne = une commune, avec son departement et son pays
SELECT
    code_commune          AS zone_key,
    MIN(nom_commune)      AS commune,
    MIN(code_departement) AS departement,
    'France'              AS pays
FROM {{ ref('int_ventes_simples') }}
GROUP BY code_commune