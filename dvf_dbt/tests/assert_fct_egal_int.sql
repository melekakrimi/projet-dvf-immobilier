-- le fait doit avoir autant de lignes que l'intermediate (pas de perte ni de doublon)
SELECT f.nb, i.nb
FROM (SELECT COUNT(*) AS nb FROM {{ ref('fct_ventes') }}) f,
     (SELECT COUNT(*) AS nb FROM {{ ref('int_ventes_simples') }}) i
WHERE f.nb <> i.nb