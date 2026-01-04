-- =====================================================
-- FICHIER : sge.sql
-- PROJET  : Système de Gestion d'Établissement (SGE)
-- SGBD    : PostgreSQL
-- VERSION : CORRIGÉE POUR MIGRATION
-- =====================================================

-- =========================
-- SUPPRESSION DE LA BASE DE DONNÉES
-- =========================
DROP DATABASE IF EXISTS sge;
CREATE DATABASE sge;
\c sge;

-- =========================
-- TABLES DE RÉFÉRENCE
-- =========================

CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE diplome (
    id_diplome SERIAL PRIMARY KEY,
    libelle VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE statut_contrat (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE type_evenement (
    id_type SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- =========================
-- STRUCTURE ORGANISATION
-- =========================

CREATE TABLE departement (
    id_departement SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE poste (
    id_poste SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    departement_id INT NOT NULL,
    niveau_requis VARCHAR(100),
    description TEXT,
    nombre_postes INT DEFAULT 1,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_poste_departement
        FOREIGN KEY (departement_id)
        REFERENCES departement(id_departement)
        ON DELETE CASCADE
);

-- =========================
-- PERSONNEL
-- =========================

CREATE TABLE personnel (
    id_personnel SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telephone VARCHAR(50),
    adresse TEXT,
    niveau_etude_max VARCHAR(100),
    photo TEXT,
    date_naissance DATE,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- HISTORIQUE DES POSTES
-- =========================

CREATE TABLE personne_poste (
    id_personne_poste SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_poste INT NOT NULL,
    date_prise_service DATE NOT NULL,
    date_fin_service DATE,
    statut VARCHAR(50) DEFAULT 'actif',
    CONSTRAINT fk_pp_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,
    CONSTRAINT fk_pp_poste
        FOREIGN KEY (id_poste)
        REFERENCES poste(id_poste)
        ON DELETE CASCADE
);

-- =========================
-- CONTRATS
-- =========================

CREATE TABLE contrat (
    id_contrat SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    type_contrat VARCHAR(50) NOT NULL,
    debut DATE NOT NULL,
    fin DATE,
    salaire NUMERIC(12,2) CHECK (salaire >= 0),
    CONSTRAINT fk_contrat_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
);

-- =========================
-- ROLES DU PERSONNEL
-- =========================

CREATE TABLE personnel_role (
    id_personnel INT NOT NULL,
    id_role INT NOT NULL,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personnel, id_role),
    CONSTRAINT fk_pr_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,
    CONSTRAINT fk_pr_role
        FOREIGN KEY (id_role)
        REFERENCES role(id_role)
        ON DELETE CASCADE
);

-- =========================
-- DIPLÔMES DU PERSONNEL
-- =========================

CREATE TABLE personnel_diplome (
    id_personnel INT NOT NULL,
    id_diplome INT NOT NULL,
    date_obtention DATE,
    institution VARCHAR(150),
    PRIMARY KEY (id_personnel, id_diplome),
    CONSTRAINT fk_pd_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,
    CONSTRAINT fk_pd_diplome
        FOREIGN KEY (id_diplome)
        REFERENCES diplome(id_diplome)
);

-- =========================
-- EVENEMENTS
-- =========================

CREATE TABLE evenement (
    id_evenement SERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    date_evenement DATE NOT NULL,
    heure_debut TIMESTAMP NOT NULL,
    heure_fin TIMESTAMP NOT NULL,
    id_type INT NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_evenement_heure
        CHECK (heure_fin > heure_debut),
    CONSTRAINT fk_evenement_type
        FOREIGN KEY (id_type)
        REFERENCES type_evenement(id_type)
);

-- =========================
-- INSCRIPTIONS
-- =========================

CREATE TABLE inscription (
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personnel, id_evenement),
    CONSTRAINT fk_insc_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,
    CONSTRAINT fk_insc_evenement
        FOREIGN KEY (id_evenement)
        REFERENCES evenement(id_evenement)
        ON DELETE CASCADE
);

-- =========================
-- PRESENCES
-- =========================

CREATE TABLE presence (
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_scan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personnel, id_evenement),
    CONSTRAINT fk_pres_personnel
        FOREIGN KEY (id_personnel)
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE,
    CONSTRAINT fk_pres_evenement
        FOREIGN KEY (id_evenement)
        REFERENCES evenement(id_evenement)
        ON DELETE CASCADE
);

-- =========================
-- QR CODES
-- =========================

CREATE TABLE qr_code (
    id_qr SERIAL PRIMARY KEY,
    chemin_qr TEXT NOT NULL,
    code_activation VARCHAR(100) UNIQUE NOT NULL,
    date_generation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    id_evenement INT NOT NULL,
    CONSTRAINT fk_qr_evenement
        FOREIGN KEY (id_evenement)
        REFERENCES evenement(id_evenement)
        ON DELETE CASCADE
);

-- =========================
-- DONNÉES DE TEST
-- =========================

-- Départements d'abord
INSERT INTO departement (nom) VALUES
('Informatique'),
('Administration');

-- Postes ensuite (FK OK)
INSERT INTO poste (titre, departement_id) VALUES
('Enseignant', 1),
('Secrétaire', 2);

-- Personnel
INSERT INTO personnel (nom, prenom, email, telephone) VALUES
('Doe', 'John', 'john.doe@email.com', '699000111'),
('Smith', 'Anna', 'anna.smith@email.com', '699000222');

-- Personne_poste
INSERT INTO personne_poste (id_personnel, id_poste, date_prise_service)
VALUES (1, 1, '2022-01-10');

-- Contrat (FK OK)
INSERT INTO contrat (id_personnel, type_contrat, debut, salaire)
VALUES (1, 'CDI', '2022-01-10', 350000);

-- Roles
INSERT INTO role (nom) VALUES ('Admin'), ('Utilisateur');
INSERT INTO personnel_role VALUES (1, 1, CURRENT_TIMESTAMP);

