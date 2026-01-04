/* =====================================================
   BASE DE DONNÉES : GESTION RH
   SGBD : PostgreSQL
   ===================================================== */

/* -----------------------------
   Création de la base
   (à exécuter en superuser)
----------------------------- */
-- CREATE DATABASE gestion_rh;
-- \c gestion_rh;

/* -----------------------------
   TYPES ENUM
----------------------------- */
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'statut_annonce') THEN
        CREATE TYPE statut_annonce AS ENUM ('ouverte', 'fermée');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'statut_candidature') THEN
        CREATE TYPE statut_candidature AS ENUM ('en attente', 'acceptée', 'rejetée');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'statut_contrat') THEN
        CREATE TYPE statut_contrat AS ENUM ('actif', 'terminé', 'suspendu');
    END IF;
END$$;

/* -----------------------------
   TABLE : PERSONNEL
----------------------------- */
CREATE TABLE IF NOT EXISTS personnel (
    id_personnel SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    niveau_etude_maximum VARCHAR(100),
    statut_matrimonial VARCHAR(50),
    numero_telephone VARCHAR(20),
    email VARCHAR(100),
    adresse TEXT,
    photo TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* -----------------------------
   TABLE : POSTE
----------------------------- */
CREATE TABLE IF NOT EXISTS poste (
    id_poste SERIAL PRIMARY KEY,
    fonction VARCHAR(100) NOT NULL,
    niveau_etude_requis VARCHAR(100),
    description_taches TEXT,
    service VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* -----------------------------
   TABLE : PERSONNE_POSTE
----------------------------- */
CREATE TABLE IF NOT EXISTS personne_poste (
    id_personne_poste SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_poste INT NOT NULL,
    date_prise_service DATE NOT NULL,
    date_fin_service DATE,

    CONSTRAINT fk_pp_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,

    CONSTRAINT fk_pp_poste
        FOREIGN KEY (id_poste)
        REFERENCES poste(id_poste)
        ON DELETE CASCADE
);

/* -----------------------------
   TABLE : ANNONCE
----------------------------- */
CREATE TABLE IF NOT EXISTS annonce (
    id_annonce SERIAL PRIMARY KEY,
    id_poste INT NOT NULL,
    date_publication DATE NOT NULL,
    delai_depot_candidature DATE NOT NULL,
    description TEXT,
    statut statut_annonce DEFAULT 'ouverte',

    CONSTRAINT fk_annonce_poste
        FOREIGN KEY (id_poste)
        REFERENCES poste(id_poste)
        ON DELETE CASCADE
);

/* -----------------------------
   TABLE : CANDIDAT
----------------------------- */
CREATE TABLE IF NOT EXISTS candidat (
    id_candidat SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telephone VARCHAR(20),
    niveau_etude VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* -----------------------------
   TABLE : CANDIDATURE
----------------------------- */
CREATE TABLE IF NOT EXISTS candidature (
    id_candidature SERIAL PRIMARY KEY,
    id_annonce INT NOT NULL,
    id_candidat INT NOT NULL,
    cv TEXT,
    lettre_motivation TEXT,
    date_candidature DATE NOT NULL,
    statut statut_candidature DEFAULT 'en attente',

    CONSTRAINT fk_candidature_annonce
        FOREIGN KEY (id_annonce)
        REFERENCES annonce(id_annonce)
        ON DELETE CASCADE,

    CONSTRAINT fk_candidature_candidat
        FOREIGN KEY (id_candidat)
        REFERENCES candidat(id_candidat)
        ON DELETE CASCADE
);

/* -----------------------------
   TABLE : CONTRAT
----------------------------- */
CREATE TABLE IF NOT EXISTS contrat (
    id_contrat SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    type_contrat VARCHAR(50),
    duree INT,
    montant_salaire NUMERIC(10,2),
    type_remuneration VARCHAR(50),
    date_debut DATE NOT NULL,
    date_fin DATE,
    statut statut_contrat DEFAULT 'actif',

    CONSTRAINT fk_contrat_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
);

