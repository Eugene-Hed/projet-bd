-- phpMyAdmin SQL Dump
-- version 5.2.3deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 23, 2025 at 06:38 PM
-- Server version: 11.8.3-MariaDB-1+b1 from Debian
-- PHP Version: 8.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `etablissement`
--

-- --------------------------------------------------------

--
-- Table structure for table `statut_candidature`
--

CREATE TABLE `statut_candidature` (
  `id_statut` int(11) NOT NULL,
  `libelle` varchar(50) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `statut_annonce`
--

CREATE TABLE `statut_annonce` (
  `id_statut` int(11) NOT NULL,
  `libelle` varchar(50) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `annonce`
--

CREATE TABLE `annonce` (
  `id_annonce` int(11) NOT NULL,
  `datePublication` date NOT NULL,
  `dateCloturePostulation` date NOT NULL,
  `dateClotureAnnonce` date DEFAULT NULL,
  `nombrePostes` int(11) DEFAULT 1,
  `id_post` int(11) NOT NULL,
  `id_statut` int(11) DEFAULT 1,
  `dateCreation` timestamp DEFAULT CURRENT_TIMESTAMP,
  `dateModification` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidature`
--

CREATE TABLE `candidature` (
  `id_candidature` int(11) NOT NULL,
  `cv` longblob DEFAULT NULL,
  `lettreMotivation` longblob DEFAULT NULL,
  `cheminCv` varchar(255) DEFAULT NULL,
  `cheminLettreMotivation` varchar(255) DEFAULT NULL,
  `dateCandidature` timestamp DEFAULT CURRENT_TIMESTAMP,
  `id_annonce` int(11) NOT NULL,
  `id_personnel` int(11) NOT NULL,
  `id_statut` int(11) DEFAULT 1,
  `dateExamen` date DEFAULT NULL,
  `observations` text,
  `dateModification` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `statut_contrat`
--

CREATE TABLE `statut_contrat` (
  `id_statut` int(11) NOT NULL,
  `libelle` varchar(50) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contrat`
--

CREATE TABLE `contrat` (
  `id_contrat` int(11) NOT NULL,
  `typeContrat` varchar(50) NOT NULL,
  `montantSalaire` decimal(10, 2) NOT NULL,
  `typeRemuneration` varchar(100),
  `dateDebut` date NOT NULL,
  `dateFin` date DEFAULT NULL,
  `id_personnel` int(11) NOT NULL,
  `id_statut` int(11) DEFAULT 1,
  `dureeHebrdo` decimal(5, 2),
  `avantages` text,
  `dateCreation` timestamp DEFAULT CURRENT_TIMESTAMP,
  `dateModification` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diplome`
--

CREATE TABLE `diplome` (
  `id_diplome` int(11) NOT NULL,
  `libelle` varchar(100) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel`
--

CREATE TABLE `personnel` (
  `id_personnel` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(100) UNIQUE,
  `numeroTelephone` varchar(20),
  `adresse` varchar(255),
  `codePostal` varchar(10),
  `ville` varchar(100),
  `niveauEtudeEleve` varchar(50),
  `photo` varchar(255),
  `dateNaissance` date,
  `dateEmbauche` date,
  `actif` boolean DEFAULT true,
  `dateCreation` timestamp DEFAULT CURRENT_TIMESTAMP,
  `dateModification` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personnel_diplome`
--

CREATE TABLE `personnel_diplome` (
  `id_personnel_diplome` int(11) NOT NULL,
  `id_personnel` int(11) NOT NULL,
  `id_diplome` int(11) NOT NULL,
  `dateObtention` date,
  `institution` varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personne_poste`
--

CREATE TABLE `personne_poste` (
  `id_personneposte` int(11) NOT NULL,
  `id_personnel` int(11) NOT NULL,
  `id_post` int(11) NOT NULL,
  `datePriseService` date NOT NULL,
  `dateFinService` date DEFAULT NULL,
  `statut` varchar(50) DEFAULT 'actif',
  `dateCreation` timestamp DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `poste`
--

CREATE TABLE `poste` (
  `id_post` int(11) NOT NULL,
  `fonction` varchar(100) NOT NULL,
  `departement` varchar(100),
  `specialite` varchar(100),
  `niveauRequis` varchar(100),
  `description` text,
  `nombrePostesDisponibles` int(11) DEFAULT 1,
  `dureeContratPrevu` varchar(100),
  `dateCreation` timestamp DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `statut_candidature`
--
ALTER TABLE `statut_candidature`
  ADD PRIMARY KEY (`id_statut`);

--
-- Indexes for table `statut_annonce`
--
ALTER TABLE `statut_annonce`
  ADD PRIMARY KEY (`id_statut`);

--
-- Indexes for table `statut_contrat`
--
ALTER TABLE `statut_contrat`
  ADD PRIMARY KEY (`id_statut`);

--
-- Indexes for table `diplome`
--
ALTER TABLE `diplome`
  ADD PRIMARY KEY (`id_diplome`);

--
-- Indexes for table `annonce`
--
ALTER TABLE `annonce`
  ADD PRIMARY KEY (`id_annonce`),
  ADD KEY `id_post` (`id_post`),
  ADD KEY `id_statut` (`id_statut`);

--
-- Indexes for table `candidature`
--
ALTER TABLE `candidature`
  ADD PRIMARY KEY (`id_candidature`),
  ADD KEY `id_annonce` (`id_annonce`),
  ADD KEY `id_personnel` (`id_personnel`),
  ADD KEY `id_statut` (`id_statut`);

--
-- Indexes for table `contrat`
--
ALTER TABLE `contrat`
  ADD PRIMARY KEY (`id_contrat`),
  ADD KEY `id_personnel` (`id_personnel`),
  ADD KEY `id_statut` (`id_statut`);

--
-- Indexes for table `personnel`
--
ALTER TABLE `personnel`
  ADD PRIMARY KEY (`id_personnel`);
  
ALTER TABLE `personnel`
  ADD UNIQUE KEY `uk_email` (`email`);

--
-- Indexes for table `personnel_diplome`
--
ALTER TABLE `personnel_diplome`
  ADD PRIMARY KEY (`id_personnel_diplome`),
  ADD KEY `id_personnel` (`id_personnel`),
  ADD KEY `id_diplome` (`id_diplome`);

--
-- Indexes for table `personne_poste`
--
ALTER TABLE `personne_poste`
  ADD PRIMARY KEY (`id_personneposte`),
  ADD KEY `id_personnel` (`id_personnel`),
  ADD KEY `id_post` (`id_post`);

--
-- Indexes for table `poste`
--
ALTER TABLE `poste`
  ADD PRIMARY KEY (`id_post`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `statut_candidature`
--
ALTER TABLE `statut_candidature`
  MODIFY `id_statut` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `statut_annonce`
--
ALTER TABLE `statut_annonce`
  MODIFY `id_statut` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `statut_contrat`
--
ALTER TABLE `statut_contrat`
  MODIFY `id_statut` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `diplome`
--
ALTER TABLE `diplome`
  MODIFY `id_diplome` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `annonce`
--
ALTER TABLE `annonce`
  MODIFY `id_annonce` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `candidature`
--
ALTER TABLE `candidature`
  MODIFY `id_candidature` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contrat`
--
ALTER TABLE `contrat`
  MODIFY `id_contrat` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel`
--
ALTER TABLE `personnel`
  MODIFY `id_personnel` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personnel_diplome`
--
ALTER TABLE `personnel_diplome`
  MODIFY `id_personnel_diplome` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personne_poste`
--
ALTER TABLE `personne_poste`
  MODIFY `id_personneposte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `poste`
--
ALTER TABLE `poste`
  MODIFY `id_post` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `annonce`
--
ALTER TABLE `annonce`
  ADD CONSTRAINT `annonce_ibfk_1` FOREIGN KEY (`id_post`) REFERENCES `poste` (`id_post`),
  ADD CONSTRAINT `annonce_ibfk_2` FOREIGN KEY (`id_statut`) REFERENCES `statut_annonce` (`id_statut`);

--
-- Constraints for table `candidature`
--
ALTER TABLE `candidature`
  ADD CONSTRAINT `candidature_ibfk_1` FOREIGN KEY (`id_annonce`) REFERENCES `annonce` (`id_annonce`),
  ADD CONSTRAINT `candidature_ibfk_2` FOREIGN KEY (`id_personnel`) REFERENCES `personnel` (`id_personnel`),
  ADD CONSTRAINT `candidature_ibfk_3` FOREIGN KEY (`id_statut`) REFERENCES `statut_candidature` (`id_statut`);

--
-- Constraints for table `contrat`
--
ALTER TABLE `contrat`
  ADD CONSTRAINT `contrat_ibfk_1` FOREIGN KEY (`id_personnel`) REFERENCES `personnel` (`id_personnel`),
  ADD CONSTRAINT `contrat_ibfk_2` FOREIGN KEY (`id_statut`) REFERENCES `statut_contrat` (`id_statut`);

--
-- Constraints for table `personnel_diplome`
--
ALTER TABLE `personnel_diplome`
  ADD CONSTRAINT `personnel_diplome_ibfk_1` FOREIGN KEY (`id_personnel`) REFERENCES `personnel` (`id_personnel`) ON DELETE CASCADE,
  ADD CONSTRAINT `personnel_diplome_ibfk_2` FOREIGN KEY (`id_diplome`) REFERENCES `diplome` (`id_diplome`);

--
-- Constraints for table `personne_poste`
--
ALTER TABLE `personne_poste`
  ADD CONSTRAINT `personne_poste_ibfk_1` FOREIGN KEY (`id_personnel`) REFERENCES `personnel` (`id_personnel`),
  ADD CONSTRAINT `personne_poste_ibfk_2` FOREIGN KEY (`id_post`) REFERENCES `poste` (`id_post`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
