-- dimension nature de vente, avec une cle de substitution
SELECT
    ROW_NUMBER() OVER (ORDER BY nature_mutation) AS nature_key,
    nature_mutation                              AS nature_vente
FROM (SELECT DISTINCT nature_mutation FROM {{ ref('int_ventes_simples') }}) n