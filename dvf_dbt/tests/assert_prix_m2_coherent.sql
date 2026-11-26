-- echoue si une vente a un prix ou un prix au m2 incoherent
SELECT *
FROM {{ ref('fct_ventes') }}
WHERE prix <= 0
   OR prix_m2 NOT BETWEEN 500 AND 30000