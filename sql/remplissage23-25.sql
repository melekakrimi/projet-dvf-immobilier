-- ajout des annees 2023 et 2025 dans le modele
-- ON CONFLICT DO NOTHING : on ignore ce qui existe deja (2024)

-- 1. natures de vente : resultat 0 (les memes 6 natures)
INSERT INTO dim_nature_vente (libelle)
SELECT DISTINCT nature_mutation
FROM staging_dvf
WHERE nature_mutation IS NOT NULL
ON CONFLICT (libelle) DO NOTHING;

-- 2. dates de 2023 et 2025 : 723 dates ajoutees
INSERT INTO dim_date (id_date, date_complete, jour, mois, trimestre, annee)
SELECT TO_CHAR(d, 'YYYYMMDD')::INTEGER, d,
       EXTRACT(DAY FROM d)::INTEGER, EXTRACT(MONTH FROM d)::INTEGER,
       EXTRACT(QUARTER FROM d)::INTEGER, EXTRACT(YEAR FROM d)::INTEGER
FROM (SELECT DISTINCT date_mutation::DATE AS d FROM staging_dvf) t
ON CONFLICT (id_date) DO NOTHING;

-- 3. departements : resultat 0 (les memes departements)
INSERT INTO dim_zone (code, nom, niveau, id_parent)
SELECT DISTINCT code_departement, 'Département ' || code_departement, 'departement',
       (SELECT id_zone FROM dim_zone WHERE niveau = 'pays')
FROM staging_dvf
WHERE code_departement IS NOT NULL
ON CONFLICT (niveau, code) DO NOTHING;

-- 4. communes : 625 nouvelles communes
INSERT INTO dim_zone (code, nom, niveau, id_parent)
SELECT s.code_commune, MIN(s.nom_commune), 'commune', d.id_zone
FROM staging_dvf s
JOIN dim_zone d ON d.niveau = 'departement' AND d.code = s.code_departement
WHERE s.code_commune IS NOT NULL
GROUP BY s.code_commune, d.id_zone
ON CONFLICT (niveau, code) DO NOTHING;

-- 5. ventes de 2023 et 2025 (meme nettoyage que 2024)
-- resultat : 1 523 070 ventes ajoutees en 14 min 22
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
      AND LEFT(id_mutation, 4) IN ('2023', '2025')
    GROUP BY id_mutation
    HAVING COUNT(*) = 1
) v ON v.id_mutation = s.id_mutation
JOIN dim_zone z ON z.niveau = 'commune' AND z.code = s.code_commune
JOIN dim_nature_vente n ON n.libelle = s.nature_mutation
WHERE s.type_local IN ('Maison', 'Appartement')
  AND s.valeur_fonciere::NUMERIC > 0
  AND s.surface_reelle_bati::INTEGER > 0
ON CONFLICT (id_vente) DO NOTHING;