-- =====================================================
-- FICHIER : sge.sql
-- PROJET  : Système de Gestion d'Établissement (SGE)
-- BASE    : PostgreSQL
-- =====================================================

-- 1) Suppression de la base si elle existe déjà
DROP DATABASE IF EXISTS sge;

-- 2) Création de la base de données
CREATE DATABASE sge;

-- 3) Connexion à la base de données
\c sge;

-- =====================================================
-- TABLE : DEPARTEMENT
-- =====================================================
CREATE TABLE departement (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

-- =====================================================
-- TABLE : POSTE
-- =====================================================
CREATE TABLE poste (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    departement_id INTEGER NOT NULL,
    FOREIGN KEY (departement_id) REFERENCES departement(id)
);

-- =====================================================
-- TABLE : EMPLOYE
-- =====================================================
CREATE TABLE employe (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    date_embauche DATE NOT NULL,
    statut VARCHAR(50),
    poste_id INTEGER,
    FOREIGN KEY (poste_id) REFERENCES poste(id)
);

-- =====================================================
-- TABLE : CONTRAT
-- =====================================================
CREATE TABLE contrat (
    id SERIAL PRIMARY KEY,
    employe_id INTEGER NOT NULL,
    type VARCHAR(50),
    debut DATE NOT NULL,
    fin DATE,
    salaire NUMERIC(10,2),
    FOREIGN KEY (employe_id) REFERENCES employe(id)
);

-- =====================================================
-- TABLE : ETUDIANT
-- =====================================================
CREATE TABLE etudiant (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    date_naissance DATE
);

-- =====================================================
-- TABLE : SALLE
-- =====================================================
CREATE TABLE salle (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    capacite INTEGER NOT NULL
);

-- =====================================================
-- TABLE : EQUIPEMENT
-- =====================================================
CREATE TABLE equipement (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    etat VARCHAR(50),
    salle_id INTEGER,
    FOREIGN KEY (salle_id) REFERENCES salle(id)
);

-- =====================================================
-- DONNEES DE TEST
-- =====================================================

INSERT INTO departement (nom) VALUES
('Informatique'),
('Mathématiques'),
('Administration');

INSERT INTO poste (titre, departement_id) VALUES
('Directeur', 3),
('Enseignant', 1),
('Secrétaire', 3);

INSERT INTO employe (nom, prenom, email, date_embauche, statut, poste_id) VALUES
('Doe', 'John', 'john.doe@email.com', '2022-01-10', 'Actif', 2),
('Smith', 'Anna', 'anna.smith@email.com', '2023-03-05', 'Actif', 3);

INSERT INTO contrat (employe_id, type, debut, fin, salaire) VALUES
(1, 'CDI', '2022-01-10', NULL, 350000.00),
(2, 'CDD', '2023-03-05', '2024-03-05', 200000.00);

INSERT INTO etudiant (nom, prenom, email, date_naissance) VALUES
('Nguyen', 'Paul', 'paul.nguyen@email.com', '2004-06-12'),
('Kouassi', 'Marie', 'marie.k@email.com', '2003-11-02');

INSERT INTO salle (code, capacite) VALUES
('A101', 40),
('B202', 60);

INSERT INTO equipement (nom, type, etat, salle_id) VALUES
('Projecteur', 'Vidéo', 'Fonctionnel', 1),
('Ordinateur', 'Informatique', 'Fonctionnel', 2);

-- =====================================================
-- FIN DU FICHIER
-- =====================================================
