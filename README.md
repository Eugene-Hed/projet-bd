# SGE Flask CRUD Tester

Simple Flask app to test CRUD operations for tables defined in `sql/sge.sql`.

Setup

1. Create the PostgreSQL database `sge` and run `sql/sge.sql` to create schema and seed data.
2. (Optional) set environment variables `SGE_DB_USER`, `SGE_DB_PASS`, `SGE_DB_HOST`, `SGE_DB_NAME`.
3. Install dependencies:

```
pip install -r requirements.txt
```

Run

```
python app.py
```

Open http://localhost:5000 and test CRUD for each table.

# Système de gestion d'établissement

Ce dépôt contient le projet d'un Système de Gestion d'Établissement (SGE) visant à gérer les ressources humaines et autres ressources de l'établissement (personnel, étudiants, locaux, matériel, etc.)

Référence du fichier principal : [`README.md`](c:\Users\BEXAO\Desktop\projet-bd\README.md)

## Objectifs

- Gérer les ressources humaines : employés, postes, contrats, congés.
- Gérer les ressources matérielles : salles, équipements, inventaires.
- Gérer les entités liées : départements, services, étudiants, cours.
- Fournir API et interface utilisateur pour administration et consultation.
- Authentification, rôles et permissions (admin, RH, enseignant, étudiant).

## Fonctionnalités principales

- CRUD pour employés, étudiants, salles, équipements.
- Gestion des contrats, planning et congés.
- Affectation de ressources (salles, équipements) et réservations.
- Rapports et export (CSV/PDF) des données RH et inventaire.
- Notifications et workflow d'approbation des demandes.

## Modèle de données (extrait)

- Employé(id, nom, prénom, email, poste_id, date_embauche, statut)
- Poste(id, titre, département_id)
- Département(id, nom)
- Salle(id, code, capacité, équipement)
- Équipement(id, nom, type, état, localisation)
- Contrat(id, employe_id, type, début, fin, salaire)

## Architecture suggérée

- Backend : API RESTful (Node.js/Express, ou Django/DRF)
- Base de données : PostgreSQL
- Frontend : React, Vue ou Angular
- Auth : JWT + gestion des rôles
- Déploiement : Docker / docker-compose

## Installation (exemple)

1. Cloner le dépôt.
2. Configurer la base de données et les variables d'environnement.
3. Lancer les services (backend, frontend, base) via docker-compose.
4. Exécuter les migrations et charger les jeux de données de test.
5. Démarrer l'application.

## API & UI (exemples d'endpoints)

- POST /api/auth/login
- GET /api/employes
- POST /api/employes
- GET /api/salles
- POST /api/reservations

## Tests et qualité

- Tests unitaires pour la logique métier.
- Tests d'intégration pour les endpoints API.
- CI : linting, tests automatiques sur push/PR.

## Roadmap / Tâches

- Modèle complet des données
- Authentification et gestion des rôles
- API CRUD pour toutes les entités
- Interface admin basique
- Tests et déploiement Docker

## Contribution

- Ouvrir des issues pour chaque fonctionnalité ou bug.
- Utiliser des branches feature et PRs pour les changements.
