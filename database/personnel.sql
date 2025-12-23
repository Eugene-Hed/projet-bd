-- ============================================
-- MODULE GESTION DU PERSONNEL - ÉCOLE
-- ============================================

-- Suppression des tables si elles existent
DROP TABLE IF EXISTS enseignants_cours;
DROP TABLE IF EXISTS paiements_salaires;
DROP TABLE IF EXISTS contrats_travail;
DROP TABLE IF EXISTS enseignants;
DROP TABLE IF EXISTS personnel_administratif;
DROP TABLE IF EXISTS personnel_autres;
DROP TABLE IF EXISTS utilisateurs;

-- Table des utilisateurs (base commune)
CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricule VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    date_naissance DATE,
    date_embauche DATE NOT NULL,
    type_personnel ENUM('enseignant', 'administratif', 'autre') NOT NULL,
    statut ENUM('actif', 'inactif', 'congé', 'licencié') DEFAULT 'actif',
    photo_profil VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des enseignants
CREATE TABLE enseignants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT UNIQUE NOT NULL,
    specialite VARCHAR(100) NOT NULL,
    niveau_etude VARCHAR(100),
    diplome VARCHAR(100),
    heures_semaine INT DEFAULT 20,
    taux_horaire DECIMAL(10,2),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    INDEX idx_specialite (specialite)
);

-- Table des affectations enseignants-cours
CREATE TABLE enseignants_cours (
    id INT PRIMARY KEY AUTO_INCREMENT,
    enseignant_id INT NOT NULL,
    cours_id INT NOT NULL,
    annee_scolaire VARCHAR(9) NOT NULL, -- Ex: 2024-2025
    semestre ENUM('1', '2') NOT NULL,
    heures_assignees INT DEFAULT 0,
    date_debut DATE NOT NULL,
    date_fin DATE,
    FOREIGN KEY (enseignant_id) REFERENCES enseignants(id) ON DELETE CASCADE,
    UNIQUE KEY uk_enseignant_cours (enseignant_id, cours_id, annee_scolaire, semestre)
);

-- Table du personnel administratif
CREATE TABLE personnel_administratif (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT UNIQUE NOT NULL,
    poste VARCHAR(100) NOT NULL,
    departement VARCHAR(100),
    bureau VARCHAR(50),
    responsable_id INT,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (responsable_id) REFERENCES personnel_administratif(id),
    INDEX idx_poste (poste),
    INDEX idx_departement (departement)
);

-- Table des autres membres du personnel
CREATE TABLE personnel_autres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT UNIQUE NOT NULL,
    fonction VARCHAR(100) NOT NULL,
    service VARCHAR(100),
    horaires_travail TEXT,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
);

-- Table des contrats de travail
CREATE TABLE contrats_travail (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    type_contrat ENUM('CDI', 'CDD', 'Stage', 'Temporaire') NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE,
    salaire_base DECIMAL(10,2) NOT NULL,
    mode_paiement ENUM('virement', 'cheque', 'especes') DEFAULT 'virement',
    banque VARCHAR(100),
    rib VARCHAR(34),
    details_contrat TEXT,
    statut ENUM('actif', 'expiré', 'résilié') DEFAULT 'actif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    INDEX idx_type_contrat (type_contrat),
    INDEX idx_statut_contrat (statut)
);

-- Table des paiements de salaires
CREATE TABLE paiements_salaires (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    mois INT NOT NULL,
    annee INT NOT NULL,
    date_paiement DATE NOT NULL,
    salaire_net DECIMAL(10,2) NOT NULL,
    salaire_brut DECIMAL(10,2) NOT NULL,
    heures_supp DECIMAL(5,2) DEFAULT 0,
    montant_heures_supp DECIMAL(10,2) DEFAULT 0,
    primes DECIMAL(10,2) DEFAULT 0,
    retenues DECIMAL(10,2) DEFAULT 0,
    details_retinues TEXT,
    mode_paiement ENUM('virement', 'cheque', 'especes') DEFAULT 'virement',
    statut ENUM('payé', 'en attente', 'annulé') DEFAULT 'en attente',
    commentaires TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    UNIQUE KEY uk_paiement_mois (utilisateur_id, mois, annee),
    INDEX idx_date_paiement (date_paiement),
    INDEX idx_statut_paiement (statut)
);

-- ============================================
-- DONNÉES DE TEST
-- ============================================

-- Insertion d'utilisateurs
INSERT INTO utilisateurs (matricule, nom, prenom, email, telephone, date_embauche, type_personnel, statut) VALUES
('EMP001', 'Dupont', 'Marie', 'marie.dupont@ecole.fr', '0612345678', '2020-09-01', 'enseignant', 'actif'),
('EMP002', 'Martin', 'Pierre', 'pierre.martin@ecole.fr', '0623456789', '2021-01-15', 'administratif', 'actif'),
('EMP003', 'Bernard', 'Sophie', 'sophie.bernard@ecole.fr', '0634567890', '2019-03-10', 'enseignant', 'actif'),
('EMP004', 'Petit', 'Luc', 'luc.petit@ecole.fr', '0645678901', '2022-11-01', 'autre', 'actif'),
('EMP005', 'Durand', 'Julie', 'julie.durand@ecole.fr', '0656789012', '2023-02-15', 'enseignant', 'congé');

-- Insertion d'enseignants
INSERT INTO enseignants (utilisateur_id, specialite, niveau_etude, diplome, heures_semaine, taux_horaire) VALUES
(1, 'Mathématiques', 'Doctorat', 'PhD Mathématiques', 18, 45.50),
(3, 'Physique-Chimie', 'Master', 'Master Physique', 20, 42.00),
(5, 'Français', 'Master', 'Master Lettres', 15, 40.00);

-- Insertion de personnel administratif
INSERT INTO personnel_administratif (utilisateur_id, poste, departement, bureau) VALUES
(2, 'Secrétaire de direction', 'Direction', 'Bureau 101');

-- Insertion d'autres membres du personnel
INSERT INTO personnel_autres (utilisateur_id, fonction, service, horaires_travail) VALUES
(4, 'Agent d entretien', 'Maintenance', 'Lundi-Vendredi 8h-17h');

-- Insertion de contrats
INSERT INTO contrats_travail (utilisateur_id, type_contrat, date_debut, salaire_base, mode_paiement) VALUES
(1, 'CDI', '2020-09-01', 2800.00, 'virement'),
(2, 'CDI', '2021-01-15', 2200.00, 'virement'),
(3, 'CDD', '2019-03-10', 2600.00, 'virement'),
(4, 'CDI', '2022-11-01', 1800.00, 'virement'),
(5, 'CDI', '2023-02-15', 2400.00, 'virement');

-- Insertion de paiements de salaires (exemple)
INSERT INTO paiements_salaires (utilisateur_id, mois, annee, date_paiement, salaire_net, salaire_brut, statut) VALUES
(1, 10, 2024, '2024-10-31', 2450.00, 2800.00, 'payé'),
(2, 10, 2024, '2024-10-31', 1950.00, 2200.00, 'payé');

-- ============================================
-- VUES UTILES
-- ============================================

-- Vue pour liste complète du personnel
CREATE OR REPLACE VIEW vue_personnel_complet AS
SELECT 
    u.id,
    u.matricule,
    u.nom,
    u.prenom,
    u.email,
    u.telephone,
    u.type_personnel,
    u.statut,
    u.date_embauche,
    CASE 
        WHEN u.type_personnel = 'enseignant' THEN e.specialite
        WHEN u.type_personnel = 'administratif' THEN pa.poste
        WHEN u.type_personnel = 'autre' THEN po.fonction
    END as poste_fonction,
    ct.type_contrat,
    ct.salaire_base
FROM utilisateurs u
LEFT JOIN enseignants e ON u.id = e.utilisateur_id AND u.type_personnel = 'enseignant'
LEFT JOIN personnel_administratif pa ON u.id = pa.utilisateur_id AND u.type_personnel = 'administratif'
LEFT JOIN personnel_autres po ON u.id = po.utilisateur_id AND u.type_personnel = 'autre'
LEFT JOIN contrats_travail ct ON u.id = ct.utilisateur_id AND ct.statut = 'actif';

-- Vue pour les enseignants avec leurs cours
CREATE OR REPLACE VIEW vue_enseignants_cours AS
SELECT 
    e.id as enseignant_id,
    u.nom,
    u.prenom,
    e.specialite,
    ec.cours_id,
    ec.annee_scolaire,
    ec.semestre,
    ec.heures_assignees
FROM enseignants e
JOIN utilisateurs u ON e.utilisateur_id = u.id
LEFT JOIN enseignants_cours ec ON e.id = ec.enseignant_id;

-- ============================================
-- PROCÉDURES STOCKÉES
-- ============================================

-- Procédure pour ajouter un nouveau membre du personnel
DELIMITER $$
CREATE PROCEDURE ajouter_personnel(
    IN p_matricule VARCHAR(20),
    IN p_nom VARCHAR(50),
    IN p_prenom VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_telephone VARCHAR(20),
    IN p_type_personnel ENUM('enseignant', 'administratif', 'autre'),
    IN p_date_embauche DATE,
    IN p_details_specifiques JSON
)
BEGIN
    DECLARE v_user_id INT;
    
    -- Insertion dans utilisateurs
    INSERT INTO utilisateurs (matricule, nom, prenom, email, telephone, type_personnel, date_embauche)
    VALUES (p_matricule, p_nom, p_prenom, p_email, p_telephone, p_type_personnel, p_date_embauche);
    
    SET v_user_id = LAST_INSERT_ID();
    
    -- Insertion dans la table spécifique selon le type
    IF p_type_personnel = 'enseignant' THEN
        INSERT INTO enseignants (utilisateur_id, specialite, heures_semaine)
        VALUES (v_user_id, 
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.specialite')),
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.heures_semaine')));
    ELSEIF p_type_personnel = 'administratif' THEN
        INSERT INTO personnel_administratif (utilisateur_id, poste, departement)
        VALUES (v_user_id,
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.poste')),
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.departement')));
    ELSEIF p_type_personnel = 'autre' THEN
        INSERT INTO personnel_autres (utilisateur_id, fonction, service)
        VALUES (v_user_id,
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.fonction')),
                JSON_UNQUOTE(JSON_EXTRACT(p_details_specifiques, '$.service')));
    END IF;
    
    SELECT CONCAT('Personnel ajouté avec ID: ', v_user_id) as message;
END$$
DELIMITER ;

-- ============================================
-- DÉCLENCHEURS (TRIGGERS)
-- ============================================

-- Trigger pour mettre à jour la date de modification
DELIMITER $$
CREATE TRIGGER before_utilisateurs_update
BEFORE UPDATE ON utilisateurs
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END$$
DELIMITER ;

-- Trigger pour vérifier l'unicité du matricule
DELIMITER $$
CREATE TRIGGER before_utilisateurs_insert
BEFORE INSERT ON utilisateurs
FOR EACH ROW
BEGIN
    IF NEW.matricule IN (SELECT matricule FROM utilisateurs) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le matricule existe déjà';
    END IF;
END$$
DELIMITER ;

-- ============================================
-- INDEX SUPPLEMENTAIRES
-- ============================================

CREATE INDEX idx_utilisateurs_nom_prenom ON utilisateurs(nom, prenom);
CREATE INDEX idx_utilisateurs_type ON utilisateurs(type_personnel);
CREATE INDEX idx_utilisateurs_statut ON utilisateurs(statut);
CREATE INDEX idx_enseignants_utilisateur ON enseignants(utilisateur_id);
CREATE INDEX idx_paiements_periode ON paiements_salaires(mois, annee);
CREATE INDEX idx_contrats_utilisateur ON contrats_travail(utilisateur_id);

-- ============================================
-- FIN DU SCRIPT
-- ============================================