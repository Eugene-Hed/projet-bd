-- ============================================================================
-- BASE DE DONNÉES FUSIONNÉE : Gestion du Recrutement + Événements/Présence
-- SGBD : MySQL 5.7+ / MariaDB 10.3+
-- Fusion de : établissement.sql + presence.sql
-- ============================================================================

-- CREATE DATABASE IF NOT EXISTS etablissement_presence_fusionne;
-- USE etablissement_presence_fusionne;

-- ============================================================================
-- SECTION 1 : TABLES DE RÉFÉRENCE / STATUTS
-- ============================================================================

-- TABLE : ROLE (Rôles utilisateur - fusionné)
CREATE TABLE ROLE (
    id_role INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    type_role VARCHAR(50) DEFAULT 'general', -- 'recrutement', 'evenement', 'general'
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nom (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : DIPLOME
CREATE TABLE DIPLOME (
    id_diplome INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : POSTE
CREATE TABLE POSTE (
    id_post INT PRIMARY KEY AUTO_INCREMENT,
    fonction VARCHAR(100) NOT NULL,
    departement VARCHAR(100),
    specialite VARCHAR(100),
    niveauRequis VARCHAR(100),
    description TEXT,
    nombrePostesDisponibles INT DEFAULT 1,
    dureeContratPrevu VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_fonction (fonction),
    INDEX idx_departement (departement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : TYPE_EVENEMENT
CREATE TABLE TYPE_EVENEMENT (
    id_type INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nom (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : STATUT_ANNONCE
CREATE TABLE STATUT_ANNONCE (
    id_statut INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : STATUT_CANDIDATURE
CREATE TABLE STATUT_CANDIDATURE (
    id_statut INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : STATUT_CONTRAT
CREATE TABLE STATUT_CONTRAT (
    id_statut INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SECTION 2 : TABLE CENTRALE - PERSONNEL/UTILISATEUR (FUSIONNÉ)
-- ============================================================================

CREATE TABLE PERSONNEL (
    id_personnel INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    numeroTelephone VARCHAR(20),
    telephone VARCHAR(50), -- Pour compatibilité avec présence
    adresse VARCHAR(255),
    codePostal VARCHAR(10),
    ville VARCHAR(100),
    niveauEtudeEleve VARCHAR(50),
    photo VARCHAR(255),
    dateNaissance DATE,
    dateEmbauche DATE,
    actif BOOLEAN DEFAULT true,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_telephone (numeroTelephone),
    INDEX idx_actif (actif),
    UNIQUE KEY uk_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : PERSONNEL_ROLE (Rôles assignés aux personnes)
CREATE TABLE PERSONNEL_ROLE (
    id_personnel_role INT PRIMARY KEY AUTO_INCREMENT,
    id_personnel INT NOT NULL,
    id_role INT NOT NULL,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP NULL,
    CONSTRAINT fk_personnel_role_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_role_role FOREIGN KEY (id_role) 
        REFERENCES ROLE(id_role) ON DELETE CASCADE,
    UNIQUE KEY uk_personnel_role (id_personnel, id_role),
    INDEX idx_personnel (id_personnel),
    INDEX idx_role (id_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : PERSONNEL_DIPLOME
CREATE TABLE PERSONNEL_DIPLOME (
    id_personnel_diplome INT PRIMARY KEY AUTO_INCREMENT,
    id_personnel INT NOT NULL,
    id_diplome INT NOT NULL,
    dateObtention DATE,
    institution VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personnel_diplome_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_diplome_diplome FOREIGN KEY (id_diplome) 
        REFERENCES DIPLOME(id_diplome) ON DELETE RESTRICT,
    INDEX idx_personnel (id_personnel),
    INDEX idx_diplome (id_diplome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SECTION 3 : GESTION DES POSTES ET AFFECTATIONS
-- ============================================================================

-- TABLE : PERSONNE_POSTE
CREATE TABLE PERSONNE_POSTE (
    id_personneposte INT PRIMARY KEY AUTO_INCREMENT,
    id_personnel INT NOT NULL,
    id_post INT NOT NULL,
    datePriseService DATE NOT NULL,
    dateFinService DATE NULL,
    statut VARCHAR(50) DEFAULT 'actif',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personne_poste_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personne_poste_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE CASCADE,
    INDEX idx_personnel (id_personnel),
    INDEX idx_poste (id_post)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SECTION 4 : GESTION DU RECRUTEMENT
-- ============================================================================

-- TABLE : ANNONCE
CREATE TABLE ANNONCE (
    id_annonce INT PRIMARY KEY AUTO_INCREMENT,
    datePublication DATE NOT NULL,
    dateCloturePostulation DATE NOT NULL,
    dateClotureAnnonce DATE NULL,
    nombrePostes INT DEFAULT 1,
    id_post INT NOT NULL,
    id_statut INT DEFAULT 1,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_annonce_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE RESTRICT,
    CONSTRAINT fk_annonce_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_ANNONCE(id_statut) ON DELETE RESTRICT,
    INDEX idx_poste (id_post),
    INDEX idx_statut (id_statut),
    INDEX idx_date (datePublication)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : CANDIDATURE
CREATE TABLE CANDIDATURE (
    id_candidature INT PRIMARY KEY AUTO_INCREMENT,
    cv LONGBLOB,
    lettreMotivation LONGBLOB,
    cheminCv VARCHAR(255),
    cheminLettreMotivation VARCHAR(255),
    dateCandidature TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_annonce INT NOT NULL,
    id_personnel INT NOT NULL,
    id_statut INT DEFAULT 1,
    dateExamen DATE NULL,
    observations TEXT,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_candidature_annonce FOREIGN KEY (id_annonce) 
        REFERENCES ANNONCE(id_annonce) ON DELETE CASCADE,
    CONSTRAINT fk_candidature_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_candidature_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_CANDIDATURE(id_statut) ON DELETE RESTRICT,
    INDEX idx_annonce (id_annonce),
    INDEX idx_personnel (id_personnel),
    INDEX idx_statut (id_statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : CONTRAT
CREATE TABLE CONTRAT (
    id_contrat INT PRIMARY KEY AUTO_INCREMENT,
    typeContrat VARCHAR(50) NOT NULL,
    montantSalaire DECIMAL(10, 2) NOT NULL,
    typeRemuneration VARCHAR(100),
    dateDebut DATE NOT NULL,
    dateFin DATE NULL,
    id_personnel INT NOT NULL,
    id_statut INT DEFAULT 1,
    dureeHebrdo DECIMAL(5, 2),
    avantages TEXT,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_contrat_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_contrat_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_CONTRAT(id_statut) ON DELETE RESTRICT,
    INDEX idx_personnel (id_personnel),
    INDEX idx_statut (id_statut),
    INDEX idx_date (dateDebut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SECTION 5 : GESTION DES ÉVÉNEMENTS ET PRÉSENCE
-- ============================================================================

-- TABLE : EVENEMENT
CREATE TABLE EVENEMENT (
    id_evenement INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(100) NOT NULL,
    description TEXT,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    date_evenement DATE NOT NULL,
    id_type INT NOT NULL,
    id_post INT NULL, -- Lien optionnel à un poste
    id_contrat INT NULL, -- Lien optionnel à un contrat
    lieu VARCHAR(255),
    capacite INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_evenement_type FOREIGN KEY (id_type) 
        REFERENCES TYPE_EVENEMENT(id_type) ON DELETE RESTRICT,
    CONSTRAINT fk_evenement_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE SET NULL,
    CONSTRAINT fk_evenement_contrat FOREIGN KEY (id_contrat) 
        REFERENCES CONTRAT(id_contrat) ON DELETE SET NULL,
    INDEX idx_type (id_type),
    INDEX idx_poste (id_post),
    INDEX idx_date (date_evenement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : INSCRIPTION (Inscription aux événements)
CREATE TABLE INSCRIPTION (
    id_inscription INT PRIMARY KEY AUTO_INCREMENT,
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_desistement TIMESTAMP NULL,
    statut VARCHAR(50) DEFAULT 'inscrit', -- 'inscrit', 'desisté', 'annulé'
    CONSTRAINT fk_inscription_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_inscription_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    UNIQUE KEY uk_personnel_evenement (id_personnel, id_evenement),
    INDEX idx_personnel (id_personnel),
    INDEX idx_evenement (id_evenement),
    INDEX idx_date (date_inscription)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : PRESENCE (Enregistrement de présence)
CREATE TABLE PRESENCE (
    id_presence INT PRIMARY KEY AUTO_INCREMENT,
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_scan TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    heure_arrivee TIME NULL,
    heure_depart TIME NULL,
    CONSTRAINT fk_presence_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_presence_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    UNIQUE KEY uk_personnel_evenement (id_personnel, id_evenement),
    INDEX idx_personnel (id_personnel),
    INDEX idx_evenement (id_evenement),
    INDEX idx_date (date_scan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLE : QR_CODE (QR Codes pour scannage)
CREATE TABLE QR_CODE (
    id_qr INT PRIMARY KEY AUTO_INCREMENT,
    id_evenement INT NOT NULL,
    chemin_image VARCHAR(500) NOT NULL,
    code_activation VARCHAR(100) NOT NULL UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP NULL,
    CONSTRAINT fk_qr_code_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    INDEX idx_evenement (id_evenement),
    INDEX idx_activation (code_activation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SECTION 6 : DONNÉES DE DÉMONSTRATION
-- ============================================================================

-- Insérer les rôles
INSERT INTO ROLE (nom, description, type_role) VALUES
    ('Admin', 'Administrateur système', 'general'),
    ('RH', 'Gestionnaire RH', 'recrutement'),
    ('Superviseur', 'Superviseur événement', 'evenement'),
    ('Manager', 'Manager de projet', 'recrutement'),
    ('Participant', 'Participant', 'evenement'),
    ('Visiteur', 'Visiteur', 'evenement');

-- Insérer les diplômes
INSERT INTO DIPLOME (libelle, description) VALUES
    ('Bac+2', 'Diplôme de niveau Bac+2'),
    ('Licence', 'Diplôme de niveau Licence (Bac+3)'),
    ('Master', 'Diplôme de niveau Master (Bac+5)'),
    ('Doctorat', 'Diplôme de niveau Doctorat (Bac+8)'),
    ('Certification', 'Certification professionnelle');

-- Insérer les postes
INSERT INTO POSTE (fonction, departement, specialite, niveauRequis, description) VALUES
    ('Développeur Python', 'Informatique', 'Backend', 'Bac+2', 'Développeur Backend Python'),
    ('Développeur JavaScript', 'Informatique', 'Frontend', 'Bac+2', 'Développeur Frontend JavaScript'),
    ('Chef de Projet', 'Management', 'Gestion de Projet', 'Bac+3', 'Chef de Projet IT'),
    ('Data Scientist', 'Data', 'Data Science', 'Master', 'Spécialiste en Data Science'),
    ('Responsable RH', 'RH', 'Ressources Humaines', 'Bac+3', 'Gestionnaire des Ressources Humaines');

-- Insérer les types d'événement
INSERT INTO TYPE_EVENEMENT (nom, description) VALUES
    ('Conférence', 'Conférence ou séminaire'),
    ('Atelier', 'Atelier de formation'),
    ('Réunion', 'Réunion de travail'),
    ('Formation obligatoire', 'Formation obligatoire pour les salariés'),
    ('Événement social', 'Événement social ou networking');

-- Insérer les statuts
INSERT INTO STATUT_ANNONCE (libelle, description) VALUES
    ('Actif', 'Annonce active et en recherche'),
    ('Clôturée', 'Annonce clôturée'),
    ('Brouillon', 'Annonce en brouillon');

INSERT INTO STATUT_CANDIDATURE (libelle, description) VALUES
    ('En attente', 'En attente de traitement'),
    ('Acceptée', 'Candidature acceptée'),
    ('Refusée', 'Candidature refusée'),
    ('En entretien', 'Candidature en phase d\'entretien');

INSERT INTO STATUT_CONTRAT (libelle, description) VALUES
    ('Actif', 'Contrat actif'),
    ('Résilié', 'Contrat résilié'),
    ('Complété', 'Contrat complété');

-- Insérer le personnel
INSERT INTO PERSONNEL (nom, prenom, email, numeroTelephone, telephone, adresse, codePostal, ville, dateEmbauche, actif) VALUES
    ('Dupont', 'Jean', 'jean.dupont@example.com', '06 12 34 56 78', '06 12 34 56 78', '123 Rue de Paris', '75000', 'Paris', '2023-01-15', true),
    ('Martin', 'Marie', 'marie.martin@example.com', '06 23 45 67 89', '06 23 45 67 89', '456 Avenue Lyon', '69000', 'Lyon', '2023-02-20', true),
    ('Bernard', 'Pierre', 'pierre.bernard@example.com', '06 34 56 78 90', '06 34 56 78 90', '789 Boulevard Marseille', '13000', 'Marseille', '2023-03-10', true),
    ('Durand', 'Sophie', 'sophie.durand@example.com', '06 45 67 89 01', '06 45 67 89 01', '321 Rue Toulouse', '31000', 'Toulouse', '2023-04-05', true),
    ('Moreau', 'Luc', 'luc.moreau@example.com', '06 56 78 90 12', '06 56 78 90 12', '654 Route Lille', '59000', 'Lille', '2023-05-12', true);

-- Assigner les rôles au personnel
INSERT INTO PERSONNEL_ROLE (id_personnel, id_role) VALUES
    (1, 1), -- Dupont = Admin
    (2, 2), -- Martin = RH
    (3, 4), -- Bernard = Manager
    (4, 3), -- Durand = Superviseur
    (5, 5); -- Moreau = Participant

-- Assigner des postes au personnel
INSERT INTO PERSONNE_POSTE (id_personnel, id_post, datePriseService, statut) VALUES
    (1, 1, '2023-01-15', 'actif'),
    (2, 1, '2023-02-20', 'actif'),
    (3, 2, '2023-03-10', 'actif'),
    (4, 3, '2023-04-05', 'actif'),
    (5, 5, '2023-05-12', 'actif');

-- Insérer des contrats
INSERT INTO CONTRAT (typeContrat, montantSalaire, typeRemuneration, dateDebut, id_personnel, id_statut) VALUES
    ('CDI', 2500.00, 'Mensuel', '2023-01-15', 1, 1),
    ('CDI', 2300.00, 'Mensuel', '2023-02-20', 2, 1),
    ('CDI', 2200.00, 'Mensuel', '2023-03-10', 3, 1),
    ('CDI', 2600.00, 'Mensuel', '2023-04-05', 4, 1),
    ('CDI', 2100.00, 'Mensuel', '2023-05-12', 5, 1);

-- Insérer des annonces
INSERT INTO ANNONCE (datePublication, dateCloturePostulation, nombrePostes, id_post, id_statut) VALUES
    ('2025-12-15', '2026-01-22', 2, 1, 1),
    ('2025-12-16', '2026-01-23', 1, 2, 1),
    ('2025-12-17', '2026-01-24', 1, 3, 1);

-- Insérer des événements
INSERT INTO EVENEMENT (titre, description, heure_debut, heure_fin, date_evenement, id_type, id_post, lieu, capacite) VALUES
    ('Conférence Python 2026', 'Conférence sur les meilleures pratiques Python', '09:00:00', '11:00:00', '2026-01-20', 1, 1, 'Salle A', 50),
    ('Atelier Web Development', 'Formation Frontend avec React', '14:00:00', '17:00:00', '2026-01-21', 2, 2, 'Salle B', 30),
    ('Réunion Q1 2025', 'Planification du Q1', '10:00:00', '12:00:00', '2026-01-22', 3, NULL, 'Salle Réunion', 20),
    ('Formation Obligatoire Sécurité', 'Formation obligatoire sécurité', '09:00:00', '10:30:00', '2026-01-23', 4, NULL, 'Amphithéâtre', 100);

-- Insérer des inscriptions aux événements
INSERT INTO INSCRIPTION (id_personnel, id_evenement, statut) VALUES
    (1, 1, 'inscrit'),
    (2, 1, 'inscrit'),
    (3, 2, 'inscrit'),
    (4, 3, 'inscrit'),
    (5, 4, 'inscrit');

-- Insérer des présences
INSERT INTO PRESENCE (id_personnel, id_evenement, date_scan, heure_arrivee) VALUES
    (1, 1, NOW(), '08:55:00'),
    (2, 1, NOW(), '09:00:00'),
    (3, 2, NOW(), '14:05:00'),
    (4, 3, NOW(), '10:00:00'),
    (5, 4, NOW(), '09:02:00');

-- ============================================================================
-- FIN DU SCHÉMA FUSIONNÉ (MYSQL)
-- ============================================================================
