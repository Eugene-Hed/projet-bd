-- Migration: 001_init_sge.sql
-- Ensures database 'sge' exists and creates reference/status tables and important constraints only if missing.

-- Create database if it does not exist (requires superuser privileges)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sge') THEN
        PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE sge');
    END IF;
END$$;

-- Note: the above uses dblink_exec; ensure the 'dblink' extension is available and this script is run by a superuser.
-- Alternatively, run: CREATE DATABASE sge; manually when required.

\connect sge

-- Create reference tables if they don't exist
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE TABLE IF NOT EXISTS role (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    type_role VARCHAR(50) DEFAULT 'general',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS diplome (
    id_diplome SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS type_evenement (
    id_type SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS statut_annonce (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS statut_candidature (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS statut_contrat (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add columns to existing tables when needed (safe, IF NOT EXISTS)
ALTER TABLE IF EXISTS poste
    ADD COLUMN IF NOT EXISTS fonction VARCHAR(100),
    ADD COLUMN IF NOT EXISTS departement_name VARCHAR(100),
    ADD COLUMN IF NOT EXISTS specialite VARCHAR(100),
    ADD COLUMN IF NOT EXISTS niveauRequis VARCHAR(100),
    ADD COLUMN IF NOT EXISTS description TEXT,
    ADD COLUMN IF NOT EXISTS nombrePostesDisponibles INT DEFAULT 1,
    ADD COLUMN IF NOT EXISTS dureeContratPrevu VARCHAR(100),
    ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_role_nom ON role(nom);
CREATE INDEX IF NOT EXISTS idx_diplome_libelle ON diplome(libelle);
CREATE INDEX IF NOT EXISTS idx_type_evenement_nom ON type_evenement(nom);

-- Checks and constraints
ALTER TABLE IF EXISTS evenement
    ADD CONSTRAINT IF NOT EXISTS chk_evenement_time CHECK (heure_fin > heure_debut);

ALTER TABLE IF EXISTS salle
    ADD CONSTRAINT IF NOT EXISTS chk_salle_capacite CHECK (capacite > 0);

ALTER TABLE IF EXISTS contrat
    ADD CONSTRAINT IF NOT EXISTS chk_contrat_salaire CHECK (salaire >= 0);

-- Seed essential status rows (idempotent)
INSERT INTO statut_annonce (libelle, description)
    SELECT 'Actif', 'Annonce active et en recherche'
    WHERE NOT EXISTS (SELECT 1 FROM statut_annonce WHERE libelle = 'Actif');

INSERT INTO statut_candidature (libelle, description)
    SELECT 'En attente', 'En attente de traitement'
    WHERE NOT EXISTS (SELECT 1 FROM statut_candidature WHERE libelle = 'En attente');

INSERT INTO statut_contrat (libelle, description)
    SELECT 'Actif', 'Contrat actif'
    WHERE NOT EXISTS (SELECT 1 FROM statut_contrat WHERE libelle = 'Actif');

-- View for event presence (Postgres version)
CREATE OR REPLACE VIEW v_evenement_presences AS
SELECT 
    e.id_evenement,
    e.titre,
    e.date_evenement,
    e.heure_debut,
    e.heure_fin,
    te.nom AS type_evenement,
    COUNT(DISTINCT i.id_utilisateur) AS inscrits,
    COUNT(DISTINCT pr.id_utilisateur) AS presents,
    ROUND(100.0 * COUNT(DISTINCT pr.id_utilisateur) / NULLIF(COUNT(DISTINCT i.id_utilisateur), 0), 2) AS taux_presence
FROM evenement e
LEFT JOIN type_even te ON e.id_type = te.id_type
LEFT JOIN inscription i ON e.id_evenement = i.id_evenement
LEFT JOIN presence pr ON e.id_evenement = pr.id_evenement
GROUP BY e.id_evenement, e.titre, e.date_evenement, e.heure_debut, e.heure_fin, te.nom;

-- Trigger function to update modification timestamps (safe addition)
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger to 'evenement' if 'date_modification' column exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='evenement' AND column_name='date_modification') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_evenement_timestamp') THEN
            CREATE TRIGGER trigger_evenement_timestamp
            BEFORE UPDATE ON evenement
            FOR EACH ROW
            EXECUTE FUNCTION update_timestamp();
        END IF;
    END IF;
END$$;

-- Create v_personnel_detail only when PERSONNEL exists (to avoid errors on mixed schemas)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_class WHERE relname = 'personnel') THEN
        EXECUTE $$
            CREATE OR REPLACE VIEW v_personnel_detail AS
            SELECT 
                p.id_personnel,
                CONCAT(p.nom, ' ', p.prenom) AS nom_complet,
                p.email,
                p.numeroTelephone,
                po.fonction AS poste_actuel,
                string_agg(DISTINCT r.nom, ', ') AS roles,
                c.typeContrat,
                c.montantSalaire,
                c.dateDebut
            FROM personnel p
            LEFT JOIN personne_poste pp ON p.id_personnel = pp.id_personnel AND pp.statut = 'actif'
            LEFT JOIN poste po ON pp.id_post = po.id
            LEFT JOIN personnel_role pr ON p.id_personnel = pr.id_personnel
            LEFT JOIN role r ON pr.id_role = r.id_role
            LEFT JOIN contrat c ON p.id_personnel = c.id_personnel AND c.id_statut = 1
            GROUP BY p.id_personnel, p.nom, p.prenom, p.email, p.numeroTelephone, po.fonction, c.typeContrat, c.montantSalaire, c.dateDebut;
        $$;
    END IF;
END$$;
