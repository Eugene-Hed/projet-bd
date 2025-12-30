-- ============================================================================
-- Base de données : Gestion des Événements et de la Présence
-- SGBD : PostgreSQL 12+
-- ============================================================================

-- Créer la base de données (optionnel)
-- CREATE DATABASE presence_db;

-- ============================================================================
-- TABLE : UTILISATEUR
-- ============================================================================
CREATE TABLE UTILISATEUR (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    telephone VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_utilisateur_email UNIQUE (email)
);

CREATE INDEX idx_email ON UTILISATEUR(email);
CREATE INDEX idx_telephone ON UTILISATEUR(telephone);

-- ============================================================================
-- TABLE : TYPE_EVENEMENT
-- ============================================================================
CREATE TABLE TYPE_EVENEMENT (
    id_type SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- TABLE : EVENEMENT
-- ============================================================================
CREATE TABLE EVENEMENT (
    id_evenement SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    id_type INTEGER NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evenement_type FOREIGN KEY (id_type) 
        REFERENCES TYPE_EVENEMENT(id_type) ON DELETE RESTRICT
);

CREATE INDEX idx_evenement_type ON EVENEMENT(id_type);

-- Trigger pour mettre à jour date_modification
CREATE OR REPLACE FUNCTION update_evenement_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_evenement_timestamp
BEFORE UPDATE ON EVENEMENT
FOR EACH ROW
EXECUTE FUNCTION update_evenement_timestamp();

-- ============================================================================
-- TABLE : PRESENCE
-- ============================================================================
CREATE TABLE PRESENCE (
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    date_scan TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_utilisateur, id_evenement),
    CONSTRAINT fk_presence_utilisateur FOREIGN KEY (id_utilisateur) 
        REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_presence_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE
);

CREATE INDEX idx_presence_evenement ON PRESENCE(id_evenement);
CREATE INDEX idx_presence_date_scan ON PRESENCE(date_scan);

-- ============================================================================
-- TABLE : INSCRIPTION
-- ============================================================================
CREATE TABLE INSCRIPTION (
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_utilisateur, id_evenement),
    CONSTRAINT fk_inscription_utilisateur FOREIGN KEY (id_utilisateur) 
        REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_inscription_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE
);

CREATE INDEX idx_inscription_evenement ON INSCRIPTION(id_evenement);

-- ============================================================================
-- TABLE : ROLE
-- ============================================================================
CREATE TABLE ROLE (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- TABLE : UTILISATEUR_ROLE
-- ============================================================================
CREATE TABLE UTILISATEUR_ROLE (
    id_utilisateur INTEGER NOT NULL,
    id_role INTEGER NOT NULL,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id_utilisateur, id_role),
    CONSTRAINT fk_utilisateur_role_utilisateur FOREIGN KEY (id_utilisateur) 
        REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_utilisateur_role_role FOREIGN KEY (id_role) 
        REFERENCES ROLE(id_role) ON DELETE CASCADE
);

CREATE INDEX idx_utilisateur_role_role ON UTILISATEUR_ROLE(id_role);

-- ============================================================================
-- TABLE : QR_CODE
-- ============================================================================
CREATE TABLE QR_CODE (
    id_qr SERIAL PRIMARY KEY,
    id_evenement INTEGER NOT NULL,
    chemin_image VARCHAR(500) NOT NULL,
    code_activation VARCHAR(100) NOT NULL UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_qr_code_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    CONSTRAINT uk_qr_code_activation UNIQUE (code_activation)
);

CREATE INDEX idx_qr_code_evenement ON QR_CODE(id_evenement);
CREATE INDEX idx_qr_code_activation ON QR_CODE(code_activation);

-- ============================================================================
-- DONNÉES DE DÉMONSTRATION (Optionnel)
-- ============================================================================

-- Insérer les rôles
INSERT INTO ROLE (nom, description) VALUES
    ('Admin', 'Administrateur système'),
    ('Superviseur', 'Superviseur événement'),
    ('Participant', 'Participant'),
    ('Visiteur', 'Visiteur');

-- Insérer les types d'événement
INSERT INTO TYPE_EVENEMENT (nom, description) VALUES
    ('Conférence', 'Conférence ou séminaire'),
    ('Atelier', 'Atelier de formation'),
    ('Réunion', 'Réunion de travail'),
    ('Événement social', 'Événement social ou networking');

-- Insérer des utilisateurs de test
INSERT INTO UTILISATEUR (nom, telephone, email) VALUES
    ('Dupont Jean', '06 12 34 56 78', 'jean.dupont@example.com'),
    ('Martin Marie', '06 23 45 67 89', 'marie.martin@example.com'),
    ('Bernard Pierre', '06 34 56 78 90', 'pierre.bernard@example.com'),
    ('Durand Sophie', '06 45 67 89 01', 'sophie.durand@example.com'),
    ('Moreau Luc', '06 56 78 90 12', 'luc.moreau@example.com');

-- Insérer des événements de test
INSERT INTO EVENEMENT (titre, heure_debut, heure_fin, id_type) VALUES
    ('Conférence Python', '09:00:00', '11:00:00', 1),
    ('Atelier Web Development', '14:00:00', '17:00:00', 2),
    ('Réunion Q1 2025', '10:00:00', '12:00:00', 3);

-- Assigner des rôles
INSERT INTO UTILISATEUR_ROLE (id_utilisateur, id_role) VALUES
    (1, 1),  -- Dupont = Admin
    (2, 2),  -- Martin = Superviseur
    (3, 3),  -- Bernard = Participant
    (4, 3),  -- Durand = Participant
    (5, 4);  -- Moreau = Visiteur

-- ============================================================================
-- FIN DU SCHÉMA
-- ============================================================================
