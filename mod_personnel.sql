-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 23 déc. 2025 à 20:06
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `mod_personnel`
--

-- --------------------------------------------------------

--
-- Structure de la table `annonce`
--

CREATE TABLE `annonce` (
  `IdAnnonce` int(11) NOT NULL,
  `DatePubliation` date NOT NULL,
  `DelaiDepotCandidature` date NOT NULL,
  `IdPoste` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contrat`
--

CREATE TABLE `contrat` (
  `IdCandidature` int(11) NOT NULL,
  `cv` varchar(255) DEFAULT NULL,
  `lettremotivation` text DEFAULT NULL,
  `IdAnnonce` int(11) NOT NULL,
  `IdPersonne` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

CREATE TABLE `personne` (
  `IdPersonne` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `niveauEtudeMax` varchar(100) DEFAULT NULL,
  `statu_Matrimonial` varchar(50) DEFAULT NULL,
  `numero_telephone` varchar(20) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personneposte`
--

CREATE TABLE `personneposte` (
  `IdPersonnePoste` int(11) NOT NULL,
  `DatePriseService` date NOT NULL,
  `IdPersonne` int(11) NOT NULL,
  `IdPoste` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `poste`
--

CREATE TABLE `poste` (
  `IdPoste` int(11) NOT NULL,
  `fonction` varchar(100) NOT NULL,
  `niveau_etude_requis` varchar(100) DEFAULT NULL,
  `description_tache` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `annonce`
--
ALTER TABLE `annonce`
  ADD PRIMARY KEY (`IdAnnonce`),
  ADD KEY `fk_annonce_poste` (`IdPoste`);

--
-- Index pour la table `contrat`
--
ALTER TABLE `contrat`
  ADD PRIMARY KEY (`IdCandidature`),
  ADD KEY `fk_contrat_annonce` (`IdAnnonce`),
  ADD KEY `fk_contrat_personne` (`IdPersonne`);

--
-- Index pour la table `personne`
--
ALTER TABLE `personne`
  ADD PRIMARY KEY (`IdPersonne`);

--
-- Index pour la table `personneposte`
--
ALTER TABLE `personneposte`
  ADD PRIMARY KEY (`IdPersonnePoste`),
  ADD KEY `fk_personneposte_personne` (`IdPersonne`),
  ADD KEY `fk_personneposte_poste` (`IdPoste`);

--
-- Index pour la table `poste`
--
ALTER TABLE `poste`
  ADD PRIMARY KEY (`IdPoste`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `annonce`
--
ALTER TABLE `annonce`
  MODIFY `IdAnnonce` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `contrat`
--
ALTER TABLE `contrat`
  MODIFY `IdCandidature` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `IdPersonne` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `personneposte`
--
ALTER TABLE `personneposte`
  MODIFY `IdPersonnePoste` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `poste`
--
ALTER TABLE `poste`
  MODIFY `IdPoste` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `annonce`
--
ALTER TABLE `annonce`
  ADD CONSTRAINT `fk_annonce_poste` FOREIGN KEY (`IdPoste`) REFERENCES `poste` (`IdPoste`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `contrat`
--
ALTER TABLE `contrat`
  ADD CONSTRAINT `fk_contrat_annonce` FOREIGN KEY (`IdAnnonce`) REFERENCES `annonce` (`IdAnnonce`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_contrat_personne` FOREIGN KEY (`IdPersonne`) REFERENCES `personne` (`IdPersonne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `personneposte`
--
ALTER TABLE `personneposte`
  ADD CONSTRAINT `fk_personneposte_personne` FOREIGN KEY (`IdPersonne`) REFERENCES `personne` (`IdPersonne`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_personneposte_poste` FOREIGN KEY (`IdPoste`) REFERENCES `poste` (`IdPoste`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
