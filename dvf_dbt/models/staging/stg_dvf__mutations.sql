-- staging : une ligne = un bien d'une mutation (comme la source)
-- on garde les colonnes utiles, on type et on nettoie
-- pas de jointure, pas de filtre

SELECT
    id_mutation,
    date_mutation::DATE                     AS date_mutation,
    TRIM(nature_mutation)                   AS nature_mutation,
    valeur_fonciere::NUMERIC                AS valeur_fonciere,
    code_postal,
    code_commune,
    TRIM(nom_commune)                       AS nom_commune,
    code_departement,
    code_type_local::INTEGER                AS code_type_local,
    TRIM(type_local)                        AS type_local,
    surface_reelle_bati::NUMERIC            AS surface_reelle_bati,
    nombre_pieces_principales::INTEGER      AS nombre_pieces,
    longitude::NUMERIC                      AS longitude,
    latitude::NUMERIC                       AS latitude
FROM {{ source('dvf', 'staging_dvf') }}