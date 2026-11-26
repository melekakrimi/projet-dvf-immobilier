{{ config(
    materialized='table',
    pre_hook="SET work_mem = '256MB'"
) }}

-- intermediate : une ligne = une vente d'un seul logement (maison ou appartement)
-- filtres metier + exclusion des valeurs aberrantes + calcul du prix au m2

WITH logements AS (
    SELECT
        *,
        -- nombre de logements dans la meme vente (fenetre au lieu d'une auto-jointure)
        COUNT(*) OVER (PARTITION BY id_mutation) AS nb_logements
    FROM {{ ref('stg_dvf__mutations') }}
    WHERE type_local IN ('Maison', 'Appartement')
)

SELECT
    id_mutation,
    date_mutation,
    nature_mutation,
    code_commune,
    nom_commune,
    code_departement,
    code_type_local,
    type_local,
    valeur_fonciere                                 AS prix,
    surface_reelle_bati                             AS surface,
    nombre_pieces,
    ROUND(valeur_fonciere / surface_reelle_bati, 0) AS prix_m2
FROM logements
WHERE nb_logements = 1
  AND valeur_fonciere > 0
  AND surface_reelle_bati BETWEEN 9 AND 1000
  AND valeur_fonciere / surface_reelle_bati BETWEEN 500 AND 30000