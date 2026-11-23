INSERT INTO dim_type_bien (id_type, libelle)
SELECT DISTINCT code_type_local::INTEGER, type_local
FROM staging_dvf
WHERE type_local IN ('Maison', 'Appartement');
========================================
INSERT INTO dim_nature_vente (libelle)
SELECT DISTINCT nature_mutation
FROM staging_dvf
WHERE nature_mutation IS NOT NULL;
================================================
INSERT INTO dim_date (id_date, date_complete, jour, mois, trimestre, annee)
SELECT TO_CHAR(d, 'YYYYMMDD')::INTEGER,
       d,
       EXTRACT(DAY FROM d)::INTEGER,
       EXTRACT(MONTH FROM d)::INTEGER,
       EXTRACT(QUARTER FROM d)::INTEGER,
       EXTRACT(YEAR FROM d)::INTEGER
FROM (SELECT DISTINCT date_mutation::DATE AS d FROM staging_dvf) t;
===================================================================
-- 4a. le pays (racine, sans parent)
INSERT INTO dim_zone (code, nom, niveau, id_parent)
VALUES ('FR', 'France', 'pays', NULL);
-- 4b. les départements, rattachés à la France
INSERT INTO dim_zone (code, nom, niveau, id_parent)
SELECT DISTINCT code_departement,
       'Département ' || code_departement,
       'departement',
       (SELECT id_zone FROM dim_zone WHERE niveau = 'pays')
FROM staging_dvf
WHERE code_departement IS NOT NULL;
-- 4c. les communes, rattachées à leur département
INSERT INTO dim_zone (code, nom, niveau, id_parent)
SELECT s.code_commune, MIN(s.nom_commune), 'commune', d.id_zone
FROM staging_dvf s
JOIN dim_zone d ON d.niveau = 'departement' AND d.code = s.code_departement
WHERE s.code_commune IS NOT NULL
GROUP BY s.code_commune, d.id_zone;
========================================================
INSERT INTO fait_vente (id_vente, id_date, id_zone, id_type, id_nature, prix, surface, nb_pieces)
SELECT s.id_mutation,
       TO_CHAR(s.date_mutation::DATE, 'YYYYMMDD')::INTEGER,
       z.id_zone,
       s.code_type_local::INTEGER,
       n.id_nature,
       s.valeur_fonciere::NUMERIC,
       s.surface_reelle_bati::INTEGER,
       s.nombre_pieces_principales::INTEGER
FROM staging_dvf s
JOIN (
    SELECT id_mutation
    FROM staging_dvf
    WHERE type_local IN ('Maison', 'Appartement')
    GROUP BY id_mutation
    HAVING COUNT(*) = 1
) v ON v.id_mutation = s.id_mutation
JOIN dim_zone z ON z.niveau = 'commune' AND z.code = s.code_commune
JOIN dim_nature_vente n ON n.libelle = s.nature_mutation
WHERE s.type_local IN ('Maison', 'Appartement')
  AND s.valeur_fonciere::NUMERIC > 0
  AND s.surface_reelle_bati::INTEGER > 0;