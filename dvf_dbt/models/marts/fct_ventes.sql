-- table de faits
-- grain : une ligne = une vente d'un seul logement (maison ou appartement)
SELECT
    v.id_mutation                                        AS vente_id,
    CAST(TO_CHAR(v.date_mutation, 'YYYYMMDD') AS INTEGER) AS date_key,
    v.code_commune                                       AS zone_key,
    v.code_type_local                                    AS type_key,
    n.nature_key,
    v.prix,
    v.surface,
    v.nombre_pieces,
    v.prix_m2
FROM {{ ref('int_ventes_simples') }} v
JOIN {{ ref('dim_nature_vente') }} n
  ON n.nature_vente = v.nature_mutation