-- dimension type de bien : maison, appartement
SELECT DISTINCT
    code_type_local AS type_key,
    type_local      AS type_bien
FROM {{ ref('int_ventes_simples') }}