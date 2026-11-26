-- Projet fil rouge : creation des tables ( dim + fait) 
-- ==============================================================================
-- type de bien (maison, appartement), id = code du fichier
CREATE TABLE dim_type_bien (
    id_type    INTEGER PRIMARY KEY  ,
    libelle    TEXT UNIQUE NOT NULL 
);
-- nature de la vente (vente, echange...), id automatique
CREATE TABLE dim_nature_vente (
    id_nature  SERIAL PRIMARY KEY,             
    libelle    TEXT UNIQUE NOT NULL
);
-- table des dates pour analyser par mois et trimestre
CREATE TABLE dim_date (
    id_date        INTEGER PRIMARY KEY,        
    date_complete  DATE    UNIQUE NOT NULL,
    jour           INTEGER NOT NULL CHECK (jour BETWEEN 1 AND 31),
    mois           INTEGER NOT NULL CHECK (mois BETWEEN 1 AND 12),
    trimestre      INTEGER NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    annee          INTEGER NOT NULL
);
-- zones avec hierarchie : commune -> departement -> France
CREATE TABLE dim_zone (
    id_zone    SERIAL  PRIMARY KEY,             
    code       TEXT    NOT NULL,
    nom        TEXT    NOT NULL,
    niveau     TEXT    NOT NULL
               CHECK (niveau IN ('pays', 'region', 'departement', 'commune')),
    id_parent  INTEGER REFERENCES dim_zone (id_zone),
    UNIQUE (niveau, code)
);
-- table de faits : une ligne = une vente, avec les 4 cles etrangeres
CREATE TABLE fait_vente (
    id_vente   TEXT PRIMARY KEY,
    id_date    INTEGER NOT NULL REFERENCES dim_date (id_date),
    id_zone    INTEGER NOT NULL REFERENCES dim_zone (id_zone),
    id_type    INTEGER NOT NULL REFERENCES dim_type_bien (id_type),
    id_nature  INTEGER NOT NULL REFERENCES dim_nature_vente (id_nature),
    prix       NUMERIC(12,2) NOT NULL CHECK (prix > 0),
    surface    INTEGER       NOT NULL CHECK (surface > 0),
    nb_pieces  INTEGER       CHECK (nb_pieces >= 0)
);