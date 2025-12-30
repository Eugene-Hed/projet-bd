CREATE TABLE UTILISATEUR (
    id_utilisateur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    telephone VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_telephone (telephone)
);

CREATE TABLE TYPE_EVENEMENT (
    id_type INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE EVENEMENT (
    id_evenement INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(100) NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    id_type INT NOT NULL,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_type) REFERENCES TYPE_EVENEMENT(id_type) ON DELETE RESTRICT,
    INDEX idx_type (id_type)
);

CREATE TABLE PRESENCE (
    id_utilisateur INT NOT NULL,
    id_evenement INT NOT NULL,
    date_scan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur, id_evenement),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_evenement) REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    INDEX idx_evenement (id_evenement),
    INDEX idx_date_scan (date_scan)
);

CREATE TABLE INSCRIPTION (
    id_utilisateur INT NOT NULL,
    id_evenement INT NOT NULL,
    date_inscription DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur, id_evenement),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_evenement) REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    INDEX idx_evenement (id_evenement)
);

CREATE TABLE ROLE (
    id_role INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UTILISATEUR_ROLE (
    id_utilisateur INT NOT NULL,
    id_role INT NOT NULL,
    date_attribution DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_utilisateur, id_role),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_role) REFERENCES ROLE(id_role) ON DELETE CASCADE,
    INDEX idx_role (id_role)
);

CREATE TABLE QR_CODE (
    id_qr INT PRIMARY KEY AUTO_INCREMENT,
    id_evenement INT NOT NULL,
    chemin_image VARCHAR(500) NOT NULL,
    code_activation VARCHAR(100) NOT NULL UNIQUE,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_evenement) REFERENCES EVENEMENT(id_evenement) ON DELETE CASCADE,
    INDEX idx_evenement (id_evenement),
    INDEX idx_code_activation (code_activation)
);