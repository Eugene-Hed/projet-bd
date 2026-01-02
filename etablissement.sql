-- SECTION 1 : TABLES DE RÉFÉRENCE / STATUTS

CREATE TABLE ROLE (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    type_role VARCHAR(50) DEFAULT 'general', -- 'recrutement', 'evenement', 'general'
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DIPLOME (
    id_diplome SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE POSTE (
    id_post SERIAL PRIMARY KEY,
    fonction VARCHAR(100) NOT NULL,
    departement VARCHAR(100),
    specialite VARCHAR(100),
    niveauRequis VARCHAR(100),
    description TEXT,
    nombrePostesDisponibles INT DEFAULT 1,
    dureeContratPrevu VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TYPE_EVENEMENT (
    id_type SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE STATUT_ANNONCE (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE STATUT_CANDIDATURE (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE STATUT_CONTRAT (
    id_statut SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SECTION 2 : TABLE CENTRALE - PERSONNEL/UTILISATEUR

CREATE TABLE PERSONNEL (
    id_personnel SERIAL PRIMARY KEY,
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
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_personnel_email ON PERSONNEL(email);
CREATE INDEX idx_personnel_telephone ON PERSONNEL(numeroTelephone);
CREATE INDEX idx_personnel_actif ON PERSONNEL(actif);

CREATE TABLE PERSONNEL_ROLE (
    id_personnel_role SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_role INT NOT NULL,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP,
    CONSTRAINT fk_personnel_role_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_role_role FOREIGN KEY (id_role) 
        REFERENCES ROLE(id_role) ON DELETE CASCADE,
    UNIQUE(id_personnel, id_role)
);

CREATE INDEX idx_personnel_role_personnel ON PERSONNEL_ROLE(id_personnel);
CREATE INDEX idx_personnel_role_role ON PERSONNEL_ROLE(id_role);

CREATE TABLE PERSONNEL_DIPLOME (
    id_personnel_diplome SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_diplome INT NOT NULL,
    dateObtention DATE,
    institution VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personnel_diplome_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personnel_diplome_diplome FOREIGN KEY (id_diplome) 
        REFERENCES DIPLOME(id_diplome) ON DELETE RESTRICT
);

CREATE INDEX idx_personnel_diplome_personnel ON PERSONNEL_DIPLOME(id_personnel);
CREATE INDEX idx_personnel_diplome_diplome ON PERSONNEL_DIPLOME(id_diplome);

-- SECTION 3 : GESTION DES POSTES ET AFFECTATIONS

CREATE TABLE PERSONNE_POSTE (
    id_personneposte SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_post INT NOT NULL,
    datePriseService DATE NOT NULL,
    dateFinService DATE,
    statut VARCHAR(50) DEFAULT 'actif',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personne_poste_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_personne_poste_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE CASCADE
);

CREATE INDEX idx_personne_poste_personnel ON PERSONNE_POSTE(id_personnel);
CREATE INDEX idx_personne_poste_poste ON PERSONNE_POSTE(id_post);

-- SECTION 4 : GESTION DU RECRUTEMENT

CREATE TABLE ANNONCE (
    id_annonce SERIAL PRIMARY KEY,
    datePublication DATE NOT NULL,
    dateCloturePostulation DATE NOT NULL,
    dateClotureAnnonce DATE,
    nombrePostes INT DEFAULT 1,
    id_post INT NOT NULL,
    id_statut INT DEFAULT 1,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_annonce_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE RESTRICT,
    CONSTRAINT fk_annonce_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_ANNONCE(id_statut) ON DELETE RESTRICT
);

CREATE INDEX idx_annonce_poste ON ANNONCE(id_post);
CREATE INDEX idx_annonce_statut ON ANNONCE(id_statut);
CREATE INDEX idx_annonce_date ON ANNONCE(datePublication);

CREATE TABLE CANDIDATURE (
    id_candidature SERIAL PRIMARY KEY,
    cv BYTEA,
    lettreMotivation BYTEA,
    cheminCv VARCHAR(255),
    cheminLettreMotivation VARCHAR(255),
    dateCandidature TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_annonce INT NOT NULL,
    id_personnel INT NOT NULL,
    id_statut INT DEFAULT 1,
    dateExamen DATE,
    observations TEXT,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_candidature_annonce FOREIGN KEY (id_annonce) 
        REFERENCES ANNONCE(id_annonce) ON DELETE CASCADE,
    CONSTRAINT fk_candidature_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_candidature_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_CANDIDATURE(id_statut) ON DELETE RESTRICT
);

CREATE INDEX idx_candidature_annonce ON CANDIDATURE(id_annonce);
CREATE INDEX idx_candidature_personnel ON CANDIDATURE(id_personnel);
CREATE INDEX idx_candidature_statut ON CANDIDATURE(id_statut);

CREATE TABLE CONTRAT (
    id_contrat SERIAL PRIMARY KEY,
    typeContrat VARCHAR(50) NOT NULL,
    montantSalaire DECIMAL(10, 2) NOT NULL,
    typeRemuneration VARCHAR(100),
    dateDebut DATE NOT NULL,
    dateFin DATE,
    id_personnel INT NOT NULL,
    id_statut INT DEFAULT 1,
    dureeHebrdo DECIMAL(5, 2),
    avantages TEXT,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dateModification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_contrat_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_contrat_statut FOREIGN KEY (id_statut) 
        REFERENCES STATUT_CONTRAT(id_statut) ON DELETE RESTRICT
);

CREATE INDEX idx_contrat_personnel ON CONTRAT(id_personnel);
CREATE INDEX idx_contrat_statut ON CONTRAT(id_statut);
CREATE INDEX idx_contrat_date ON CONTRAT(dateDebut);

-- SECTION 5 : GESTION DES ÉVÉNEMENTS ET PRÉSENCE

CREATE TABLE EVENEMENT (
    id_evenement SERIAL PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    description TEXT,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    date_evenement DATE NOT NULL,
    id_type INT NOT NULL,
    id_post INT, -- Lien optionnel à un poste (formation par poste)
    id_contrat INT, -- Lien optionnel à un contrat (formation obligatoire)
    lieu VARCHAR(255),
    capacite INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evenement_type FOREIGN KEY (id_type) 
        REFERENCES TYPE_EVENEMENT(id_type) ON DELETE RESTRICT,
    CONSTRAINT fk_evenement_poste FOREIGN KEY (id_post) 
        REFERENCES POSTE(id_post) ON DELETE SET NULL,
    CONSTRAINT fk_evenement_contrat FOREIGN KEY (id_contrat) 
        REFERENCES CONTRAT(id_contrat) ON DELETE SET NULL
);

CREATE INDEX idx_evenement_type ON EVENEMENT(id_type);
CREATE INDEX idx_evenement_poste ON EVENEMENT(id_post);
CREATE INDEX idx_evenement_date ON EVENEMENT(date_evenement);

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

CREATE TABLE INSCRIPTION (
    id_inscription SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_desistement TIMESTAMP,
    statut VARCHAR(50) DEFAULT 'inscrit', -- 'inscrit', 'desisté', 'annulé'
    CONSTRAINT fk_inscription_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_inscription_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    UNIQUE(id_personnel, id_evenement)
);

CREATE INDEX idx_inscription_personnel ON INSCRIPTION(id_personnel);
CREATE INDEX idx_inscription_evenement ON INSCRIPTION(id_evenement);
CREATE INDEX idx_inscription_date ON INSCRIPTION(date_inscription);

CREATE TABLE PRESENCE (
    id_presence SERIAL PRIMARY KEY,
    id_personnel INT NOT NULL,
    id_evenement INT NOT NULL,
    date_scan TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    heure_arrivee TIME,
    heure_depart TIME,
    CONSTRAINT fk_presence_personnel FOREIGN KEY (id_personnel) 
        REFERENCES PERSONNEL(id_personnel) ON DELETE CASCADE,
    CONSTRAINT fk_presence_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    UNIQUE(id_personnel, id_evenement)
);

CREATE INDEX idx_presence_personnel ON PRESENCE(id_personnel);
CREATE INDEX idx_presence_evenement ON PRESENCE(id_evenement);
CREATE INDEX idx_presence_date ON PRESENCE(date_scan);

CREATE TABLE QR_CODE (
    id_qr SERIAL PRIMARY KEY,
    id_evenement INT NOT NULL,
    chemin_image VARCHAR(500) NOT NULL,
    code_activation VARCHAR(100) NOT NULL UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    CONSTRAINT fk_qr_code_evenement FOREIGN KEY (id_evenement) 
        REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE
);

CREATE INDEX idx_qr_code_evenement ON QR_CODE(id_evenement);
CREATE INDEX idx_qr_code_activation ON QR_CODE(code_activation);

-- SECTION 6 : DONNÉES DE DÉMONSTRATION

INSERT INTO ROLE (nom, description, type_role) VALUES
    ('Admin', 'Administrateur système', 'general'),
    ('RH', 'Gestionnaire RH', 'recrutement'),
    ('Superviseur', 'Superviseur événement', 'evenement'),
    ('Manager', 'Manager de projet', 'recrutement'),
    ('Participant', 'Participant', 'evenement'),
    ('Visiteur', 'Visiteur', 'evenement');

INSERT INTO DIPLOME (libelle, description) VALUES
    ('Bac+2', 'Diplôme de niveau Bac+2'),
    ('Licence', 'Diplôme de niveau Licence (Bac+3)'),
    ('Master', 'Diplôme de niveau Master (Bac+5)'),
    ('Doctorat', 'Diplôme de niveau Doctorat (Bac+8)'),
    ('Certification', 'Certification professionnelle');

INSERT INTO POSTE (fonction, departement, specialite, niveauRequis, description) VALUES
    ('Développeur Python', 'Informatique', 'Backend', 'Bac+2', 'Développeur Backend Python'),
    ('Développeur JavaScript', 'Informatique', 'Frontend', 'Bac+2', 'Développeur Frontend JavaScript'),
    ('Chef de Projet', 'Management', 'Gestion de Projet', 'Bac+3', 'Chef de Projet IT'),
    ('Data Scientist', 'Data', 'Data Science', 'Master', 'Spécialiste en Data Science'),
    ('Responsable RH', 'RH', 'Ressources Humaines', 'Bac+3', 'Gestionnaire des Ressources Humaines');

INSERT INTO TYPE_EVENEMENT (nom, description) VALUES
    ('Conférence', 'Conférence ou séminaire'),
    ('Atelier', 'Atelier de formation'),
    ('Réunion', 'Réunion de travail'),
    ('Formation obligatoire', 'Formation obligatoire pour les salariés'),
    ('Événement social', 'Événement social ou networking');

INSERT INTO STATUT_ANNONCE (libelle, description) VALUES
    ('Actif', 'Annonce active et en recherche'),
    ('Clôturée', 'Annonce clôturée'),
    ('Brouillon', 'Annonce en brouillon');

INSERT INTO STATUT_CANDIDATURE (libelle, description) VALUES
    ('En attente', 'En attente de traitement'),
    ('Acceptée', 'Candidature acceptée'),
    ('Refusée', 'Candidature refusée'),
    ('En entretien', 'Candidature en phase d''entretien');

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
    (1, 1),
    (2, 2),
    (3, 4),
    (4, 3),
    (5, 5);

-- Assigner des postes au personnel
INSERT INTO PERSONNE_POSTE (id_personnel, id_post, datePriseService, statut) VALUES
    (1, 1, '2023-01-15', 'actif'),
    (2, 1, '2023-02-20', 'actif'),
    (3, 2, '2023-03-10', 'actif'),
    (4, 3, '2023-04-05', 'actif'),
    (5, 5, '2023-05-12', 'actif');

INSERT INTO CONTRAT (typeContrat, montantSalaire, typeRemuneration, dateDebut, id_personnel, id_statut) VALUES
    ('CDI', 2500.00, 'Mensuel', '2023-01-15', 1, 1),
    ('CDI', 2300.00, 'Mensuel', '2023-02-20', 2, 1),
    ('CDI', 2200.00, 'Mensuel', '2023-03-10', 3, 1),
    ('CDI', 2600.00, 'Mensuel', '2023-04-05', 4, 1),
    ('CDI', 2100.00, 'Mensuel', '2023-05-12', 5, 1);

INSERT INTO ANNONCE (datePublication, dateCloturePostulation, nombrePostes, id_post, id_statut) VALUES
    ('2025-12-15', '2026-01-22', 2, 1, 1),
    ('2025-12-16', '2026-01-23', 1, 2, 1),
    ('2025-12-17', '2026-01-24', 1, 3, 1);

INSERT INTO EVENEMENT (titre, description, heure_debut, heure_fin, date_evenement, id_type, id_post, lieu, capacite) VALUES
    ('Conférence Python 2026', 'Conférence sur les meilleures pratiques Python', '09:00:00', '11:00:00', '2026-01-20', 1, 1, 'Salle A', 50),
    ('Atelier Web Development', 'Formation Frontend avec React', '14:00:00', '17:00:00', '2026-01-21', 2, 2, 'Salle B', 30),
    ('Réunion Q1 2025', 'Planification du Q1', '10:00:00', '12:00:00', '2026-01-22', 3, NULL, 'Salle Réunion', 20),
    ('Formation Obligatoire Sécurité', 'Formation obligatoire sécurité', '09:00:00', '10:30:00', '2026-01-23', 4, NULL, 'Amphithéâtre', 100);

INSERT INTO INSCRIPTION (id_personnel, id_evenement, statut) VALUES
    (1, 1, 'inscrit'),
    (2, 1, 'inscrit'),
    (3, 2, 'inscrit'),
    (4, 3, 'inscrit'),
    (5, 4, 'inscrit');

INSERT INTO PRESENCE (id_personnel, id_evenement, date_scan, heure_arrivee) VALUES
    (1, 1, CURRENT_TIMESTAMP, '08:55:00'),
    (2, 1, CURRENT_TIMESTAMP, '09:00:00'),
    (3, 2, CURRENT_TIMESTAMP, '14:05:00'),
    (4, 3, CURRENT_TIMESTAMP, '10:00:00'),
    (5, 4, CURRENT_TIMESTAMP, '09:02:00');

-- SECTION 7 : VUES UTILES

CREATE VIEW v_personnel_detail AS
SELECT 
    p.id_personnel,
    CONCAT(p.nom, ' ', p.prenom) AS nom_complet,
    p.email,
    p.numeroTelephone,
    po.fonction AS poste_actuel,
    GROUP_CONCAT(r.nom, ', ') AS roles,
    c.typeContrat,
    c.montantSalaire,
    c.dateDebut
FROM PERSONNEL p
LEFT JOIN PERSONNE_POSTE pp ON p.id_personnel = pp.id_personnel AND pp.statut = 'actif'
LEFT JOIN POSTE po ON pp.id_post = po.id_post
LEFT JOIN PERSONNEL_ROLE pr ON p.id_personnel = pr.id_personnel
LEFT JOIN ROLE r ON pr.id_role = r.id_role
LEFT JOIN CONTRAT c ON p.id_personnel = c.id_personnel AND c.id_statut = 1
GROUP BY p.id_personnel, p.nom, p.prenom, p.email, p.numeroTelephone, po.fonction, c.typeContrat, c.montantSalaire, c.dateDebut;

CREATE VIEW v_evenement_presences AS
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
FROM EVENEMENT e
JOIN TYPE_EVENEMENT te ON e.id_type = te.id_type
LEFT JOIN INSCRIPTION i ON e.id_evenement = i.id_evenement
LEFT JOIN PRESENCE pr ON e.id_evenement = pr.id_evenement
GROUP BY e.id_evenement, e.titre, e.date_evenement, e.heure_debut, e.heure_fin, te.nom;

