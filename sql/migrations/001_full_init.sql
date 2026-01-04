-- Migration 001 (consolidée) : initialisation du schéma + fusion et migration des données
-- Objectif :
--  - Créer la base (si nécessaire), les tables de référence et le schéma final (idempotent)
--  - Créer ou compléter la table PERSONNEL (fusion d'EMPLOYE/UTILISATEUR)
--  - Sauvegarder les tables sources (utilisateur, employe) dans des backups
--  - Migrer les enregistrements manquants vers PERSONNEL
--  - Mettre à jour les clés étrangères (presence, inscription, contrat, etc.)
--  - Créer les vues et triggers nécessaires
-- Notes :
--  - Exécutez ce script connecté à la base 'sge' (ou laissez la création de la base au bloc ci-dessous).
--  - Ce script est conçu pour être idempotent ; il peut être relancé en toute sécurité.
--  - Pour un dry-run (estimation des actions), exécutez `sql/migrations/001_dryrun_full_init.sql`.

-- --------------------------------------------------
-- 0) (Optionnel) création de la base 'sge' si absente (requiert droits superuser)
-- --------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sge') THEN
        RAISE NOTICE 'La base sge n''existe pas. Veuillez créer la base manuellement (CREATE DATABASE sge) ou exécuter ce script avec un superuser.';
    END IF;
END$$;

-- NOTE : si vous êtes superuser et souhaitez créer la DB depuis le script, ajoutez la logique dblink/dblink_exec.

-- --------------------------------------------------
-- 1) Extensions et tables de référence (idempotent)
-- --------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

-- --------------------------------------------------
-- 2) Tables principales et colonnes complémentaires (idempotent)
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS departement (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS poste (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    departement_id INTEGER,
    FOREIGN KEY (departement_id) REFERENCES departement(id)
);

-- Table PERSONNEL (fusion des concepts employe/utilisateur)
CREATE TABLE IF NOT EXISTS personnel (
    id_personnel SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    numeroTelephone VARCHAR(20),
    telephone VARCHAR(50),
    adresse VARCHAR(255),
    codePostal VARCHAR(10),
    ville VARCHAR(100),
    niveauEtudeEleve VARCHAR(50),
    photo VARCHAR(255),
    dateNaissance DATE,
    dateEmbauche DATE,
    actif BOOLEAN DEFAULT true,
    poste_id INTEGER,
    statut VARCHAR(50),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personnel_poste FOREIGN KEY (poste_id) REFERENCES poste(id)
);

CREATE INDEX IF NOT EXISTS idx_personnel_email ON personnel(email);
CREATE INDEX IF NOT EXISTS idx_personnel_telephone ON personnel(numeroTelephone);
CREATE INDEX IF NOT EXISTS idx_personnel_actif ON personnel(actif);

-- Contrat
CREATE TABLE IF NOT EXISTS contrat (
    id SERIAL PRIMARY KEY,
    id_personnel INTEGER NOT NULL,
    type_contrat VARCHAR(50),
    debut DATE NOT NULL,
    fin DATE,
    salaire NUMERIC(10,2),
    CONSTRAINT fk_contrat_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel)
);
CREATE INDEX IF NOT EXISTS idx_contrat_personnel ON contrat(id_personnel);
CREATE INDEX IF NOT EXISTS idx_contrat_date ON contrat(debut);

-- Personne_poste
CREATE TABLE IF NOT EXISTS personne_poste (
    id_personneposte SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_post INT NOT NULL,
    datePriseService DATE NOT NULL,
    dateFinService DATE,
    statut VARCHAR(50) DEFAULT 'actif',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personne_poste_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personne_poste_poste FOREIGN KEY (id_post) REFERENCES poste(id) ON DELETE CASCADE
);

-- Personne_role
CREATE TABLE IF NOT EXISTS personnel_role (
    id_personnel_role SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_role INT NOT NULL,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP,
    CONSTRAINT fk_personnel_role_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_role_role FOREIGN KEY (id_role) REFERENCES role(id_role) ON DELETE CASCADE,
    UNIQUE (id_personnel, id_role)
);

-- Personne_diplome
CREATE TABLE IF NOT EXISTS personnel_diplome (
    id_personnel_diplome SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_diplome INT NOT NULL,
    dateObtention DATE,
    institution VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personnel_diplome_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_diplome_diplome FOREIGN KEY (id_diplome) REFERENCES diplome(id_diplome) ON DELETE RESTRICT
);

-- Evenement
CREATE TABLE IF NOT EXISTS type_evenement_ref (
    id_type_ref SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS evenement (
    id_evenement SERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    heure_debut TIMESTAMP NOT NULL,
    heure_fin TIMESTAMP NOT NULL,
    id_type INTEGER NOT NULL,
    date_evenement DATE,
    lieu VARCHAR(255),
    capacite INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evenement_type FOREIGN KEY (id_type) REFERENCES type_evenement(id_type) ON DELETE RESTRICT
);

ALTER TABLE IF EXISTS evenement
    ADD CONSTRAINT IF NOT EXISTS chk_evenement_time CHECK (heure_fin > heure_debut);

-- Presence et Inscription
CREATE TABLE IF NOT EXISTS presence (
    id_personnel INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    date_scan TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personnel, id_evenement),
    CONSTRAINT fk_presence_personnel FOREIGN KEY (id_personnel) REFERENCES personnel (id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_presence_evenement FOREIGN KEY (id_evenement) REFERENCES evenement (id_evenement) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS inscription (
    id_personnel INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    date_inscription TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_desistement TIMESTAMP,
    statut VARCHAR(50) DEFAULT 'inscrit',
    PRIMARY KEY (id_personnel, id_evenement),
    CONSTRAINT fk_inscription_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_inscription_evenement FOREIGN KEY (id_evenement) REFERENCES evenement (id_evenement) ON DELETE CASCADE
);

-- QR code
CREATE TABLE IF NOT EXISTS qr_code (
    id_qr SERIAL PRIMARY KEY,
    chemin_qr TEXT NOT NULL,
    date_generation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_activation VARCHAR(100) NOT NULL UNIQUE,
    id_evenement INTEGER NOT NULL,
    date_expiration TIMESTAMP,
    CONSTRAINT fk_qr_evenement FOREIGN KEY (id_evenement) REFERENCES evenement (id_evenement) ON DELETE CASCADE
);

-- Checks utilitaires
ALTER TABLE IF EXISTS salle
    ADD CONSTRAINT IF NOT EXISTS chk_salle_capacite CHECK (capacite > 0);

ALTER TABLE IF EXISTS contrat
    ADD CONSTRAINT IF NOT EXISTS chk_contrat_salaire CHECK (salaire >= 0);

-- --------------------------------------------------
-- 3) Backups des tables sources (si elles existent)
-- --------------------------------------------------
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='utilisateur') THEN
        EXECUTE 'CREATE TABLE IF NOT EXISTS utilisateur_backup AS TABLE utilisateur WITH NO DATA';
        EXECUTE 'INSERT INTO utilisateur_backup SELECT * FROM utilisateur WHERE NOT EXISTS (SELECT 1 FROM utilisateur_backup WHERE utilisateur_backup.id_utilisateur = utilisateur.id_utilisateur)';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='employe') THEN
        EXECUTE 'CREATE TABLE IF NOT EXISTS employe_backup AS TABLE employe WITH NO DATA';
        EXECUTE 'INSERT INTO employe_backup SELECT * FROM employe WHERE NOT EXISTS (SELECT 1 FROM employe_backup WHERE employe_backup.id = employe.id)';
    END IF;
END$$;

-- --------------------------------------------------
-- 4) Migration des données (idempotent)
-- --------------------------------------------------
-- 4.1 Migrer les utilisateurs
INSERT INTO personnel (nom, prenom, email, numeroTelephone, telephone, date_creation)
SELECT u.nom, NULL, u.email, u.telephone, u.telephone, CURRENT_TIMESTAMP
FROM utilisateur u
WHERE u.email IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email = u.email);

-- 4.2 Migrer les employés
INSERT INTO personnel (nom, prenom, email, dateEmbauche, actif, poste_id, statut, date_creation)
SELECT e.nom, e.prenom, e.email, e.date_embauche, (CASE WHEN lower(e.statut) = 'actif' THEN true ELSE false END), e.poste_id, e.statut, CURRENT_TIMESTAMP
FROM employe e
WHERE (e.email IS NOT NULL AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email = e.email))
   OR (e.email IS NULL AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email IS NULL AND p.nom = e.nom AND p.prenom = e.prenom AND COALESCE(p.dateEmbauche::text,'') = COALESCE(e.date_embauche::text,'')));

-- 4.3 Créer mappings temporaires (utile pour opérations suivantes)
CREATE TEMP TABLE IF NOT EXISTS tmp_user_personnel_map ON COMMIT DROP AS
SELECT u.id_utilisateur AS id_utilisateur, p.id_personnel AS id_personnel
FROM utilisateur u
LEFT JOIN personnel p ON (u.email IS NOT NULL AND p.email = u.email);

CREATE TEMP TABLE IF NOT EXISTS tmp_employe_personnel_map ON COMMIT DROP AS
SELECT e.id AS id_employe, p.id_personnel AS id_personnel
FROM employe e
LEFT JOIN personnel p ON ((e.email IS NOT NULL AND p.email = e.email) OR (e.email IS NULL AND p.email IS NULL AND p.nom = e.nom AND p.prenom = e.prenom AND COALESCE(p.dateEmbauche::text,'') = COALESCE(e.date_embauche::text,'')));

-- 4.4 Mettre à jour presence (id_utilisateur -> id_personnel)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_utilisateur') THEN
        -- ajouter colonne id_personnel si absente
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_personnel') THEN
            ALTER TABLE presence ADD COLUMN id_personnel INTEGER;
        END IF;

        -- update via mapping
        UPDATE presence p
        SET id_personnel = m.id_personnel
        FROM tmp_user_personnel_map m
        WHERE p.id_utilisateur = m.id_utilisateur AND p.id_personnel IS NULL;

        -- si id_personnel rempli, supprimer colonne id_utilisateur et recréer PK/FK
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_personnel') THEN
            BEGIN
                ALTER TABLE presence DROP CONSTRAINT IF EXISTS presence_pkey;
            EXCEPTION WHEN OTHERS THEN END;

            ALTER TABLE presence DROP COLUMN IF EXISTS id_utilisateur;
            ALTER TABLE presence ADD CONSTRAINT presence_pkey PRIMARY KEY (id_personnel, id_evenement);
            ALTER TABLE presence ADD CONSTRAINT fk_presence_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE;
        END IF;
    END IF;
END$$;

-- 4.5 Mettre à jour inscription
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='inscription' AND column_name='id_utilisateur') THEN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='inscription' AND column_name='id_personnel') THEN
            ALTER TABLE inscription ADD COLUMN id_personnel INTEGER;
        END IF;

        UPDATE inscription i
        SET id_personnel = m.id_personnel
        FROM tmp_user_personnel_map m
        WHERE i.id_utilisateur = m.id_utilisateur AND i.id_personnel IS NULL;

        BEGIN
            ALTER TABLE inscription DROP CONSTRAINT IF EXISTS inscription_pkey;
        EXCEPTION WHEN OTHERS THEN END;

        ALTER TABLE inscription DROP COLUMN IF EXISTS id_utilisateur;
        ALTER TABLE inscription ADD CONSTRAINT inscription_pkey PRIMARY KEY (id_personnel, id_evenement);
        ALTER TABLE inscription ADD CONSTRAINT fk_inscription_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE;
    END IF;
END$$;

-- 4.6 Mettre à jour contrat (employe_id -> id_personnel)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='contrat' AND column_name='employe_id') THEN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='contrat' AND column_name='id_personnel') THEN
            ALTER TABLE contrat ADD COLUMN id_personnel INTEGER;
        END IF;

        UPDATE contrat c
        SET id_personnel = m.id_personnel
        FROM tmp_employe_personnel_map m
        WHERE c.employe_id = m.id_employe AND c.id_personnel IS NULL;

        ALTER TABLE contrat DROP CONSTRAINT IF EXISTS contrat_pkey;
        ALTER TABLE contrat DROP COLUMN IF EXISTS employe_id;
        ALTER TABLE contrat ADD CONSTRAINT fk_contrat_personnel FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel);
    END IF;
END$$;

-- 4.7 Migrer utilisateur_role -> personnel_role
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'utilisateur_role') THEN
        INSERT INTO personnel_role (id_personnel, id_role, date_attribution)
        SELECT COALESCE(m.id_personnel, per.id_personnel), ur.id_role, ur.date_attribution
        FROM utilisateur_role ur
        LEFT JOIN tmp_user_personnel_map m ON ur.id_utilisateur = m.id_utilisateur
        LEFT JOIN personnel per ON (m.id_personnel IS NULL AND per.email IS NOT NULL AND per.email = (SELECT u.email FROM utilisateur u WHERE u.id_utilisateur = ur.id_utilisateur LIMIT 1))
        WHERE NOT EXISTS (
            SELECT 1 FROM personnel_role pr WHERE pr.id_personnel = COALESCE(m.id_personnel, per.id_personnel) AND pr.id_role = ur.id_role
        );
    END IF;
END$$;

-- --------------------------------------------------
-- 5) Vues et triggers (idempotent)
-- --------------------------------------------------
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE VIEW v_evenement_presences AS
SELECT 
    e.id_evenement,
    e.titre,
    e.date_evenement,
    e.heure_debut,
    e.heure_fin,
    te.nom AS type_evenement,
    COUNT(DISTINCT i.id_personnel) AS inscrits,
    COUNT(DISTINCT pr.id_personnel) AS presents,
    ROUND(100.0 * COUNT(DISTINCT pr.id_personnel) / NULLIF(COUNT(DISTINCT i.id_personnel), 0), 2) AS taux_presence
FROM evenement e
LEFT JOIN type_evenement te ON e.id_type = te.id_type
LEFT JOIN inscription i ON e.id_evenement = i.id_evenement
LEFT JOIN presence pr ON e.id_evenement = pr.id_evenement
GROUP BY e.id_evenement, e.titre, e.date_evenement, e.heure_debut, e.heure_fin, te.nom;

CREATE OR REPLACE VIEW v_personnel_detail AS
SELECT 
    p.id_personnel,
    CONCAT(p.nom, ' ', p.prenom) AS nom_complet,
    p.email,
    p.numeroTelephone,
    po.titre AS poste_actuel,
    string_agg(DISTINCT r.nom, ', ') AS roles,
    c.type_contrat,
    c.salaire AS montantSalaire,
    c.debut AS dateDebut
FROM personnel p
LEFT JOIN personne_poste pp ON p.id_personnel = pp.id_personnel AND pp.statut = 'actif'
LEFT JOIN poste po ON pp.id_post = po.id
LEFT JOIN personnel_role pr ON p.id_personnel = pr.id_personnel
LEFT JOIN role r ON pr.id_role = r.id_role
LEFT JOIN contrat c ON p.id_personnel = c.id_personnel
GROUP BY p.id_personnel, p.nom, p.prenom, p.email, p.numeroTelephone, po.titre, c.type_contrat, c.salaire, c.debut;

-- --------------------------------------------------
-- 6) Seeds minimaux (idempotent)
-- --------------------------------------------------
INSERT INTO statut_annonce (libelle, description)
    SELECT 'Actif', 'Annonce active et en recherche'
    WHERE NOT EXISTS (SELECT 1 FROM statut_annonce WHERE libelle = 'Actif');

INSERT INTO statut_candidature (libelle, description)
    SELECT 'En attente', 'En attente de traitement'
    WHERE NOT EXISTS (SELECT 1 FROM statut_candidature WHERE libelle = 'En attente');

INSERT INTO statut_contrat (libelle, description)
    SELECT 'Actif', 'Contrat actif'
    WHERE NOT EXISTS (SELECT 1 FROM statut_contrat WHERE libelle = 'Actif');

COMMIT;

-- Fin de la migration 001 (consolidée)
