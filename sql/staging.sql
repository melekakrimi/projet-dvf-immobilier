-- ============================================================
-- Projet fil rouge : base et table brute (staging)
-- Source : le site  data.gouv.fr 
-- ==============================================================================

-- Base de données (exécuté une seule fois)
-- CREATE DATABASE immobilier;

-- Table brute : 40 colonnes en TEXT pour importer sans erreur.
-- La conversion des types se fera lors du remplissage des tables finales.
CREATE TABLE staging_dvf (
    id_mutation TEXT, date_mutation TEXT, numero_disposition TEXT,
    nature_mutation TEXT, valeur_fonciere TEXT,
    adresse_numero TEXT, adresse_suffixe TEXT, adresse_nom_voie TEXT,
    adresse_code_voie TEXT, code_postal TEXT, code_commune TEXT,
    nom_commune TEXT, code_departement TEXT,
    ancien_code_commune TEXT, ancien_nom_commune TEXT,
    id_parcelle TEXT, ancien_id_parcelle TEXT, numero_volume TEXT,
    lot1_numero TEXT, lot1_surface_carrez TEXT,
    lot2_numero TEXT, lot2_surface_carrez TEXT,
    lot3_numero TEXT, lot3_surface_carrez TEXT,
    lot4_numero TEXT, lot4_surface_carrez TEXT,
    lot5_numero TEXT, lot5_surface_carrez TEXT,
    nombre_lots TEXT, code_type_local TEXT, type_local TEXT,
    surface_reelle_bati TEXT, nombre_pieces_principales TEXT,
    code_nature_culture TEXT, nature_culture TEXT,
    code_nature_culture_speciale TEXT, nature_culture_speciale TEXT,
    surface_terrain TEXT, longitude TEXT, latitude TEXT
);

-- Import (pgAdmin > Import/Export Data, ou en psql) :
-- \copy staging_dvf FROM 'C:/projet_dvf/dvf_2024.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', ENCODING 'UTF8');

-- Vérification : 3 505 340 lignes
SELECT COUNT(*) FROM staging_dvf;