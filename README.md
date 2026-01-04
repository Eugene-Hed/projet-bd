# Système de gestion d'établissement (SGE)

Ce dépôt contient le projet d'un **Système de Gestion d'Établissement (SGE)** visant à gérer les ressources humaines et autres ressources de l'établissement (personnel, étudiants, locaux, matériel, etc.)

Référence du fichier principal : [`README.md`](README.md)

---

## Objectifs

- Gérer les ressources humaines : employés, postes, contrats, congés.
- Gérer les ressources matérielles : salles, équipements, inventaires.
- Gérer les entités liées : départements, services, étudiants, cours.
- Fournir API et interface utilisateur pour administration et consultation.
- Authentification, rôles et permissions (admin, RH, enseignant, étudiant).

---

## Fonctionnalités principales

- CRUD pour employés, étudiants, salles, équipements.
- Gestion des contrats, planning et congés.
- Affectation de ressources (salles, équipements) et réservations.
- Rapports et export (CSV/PDF) des données RH et inventaire.
- Notifications et workflow d'approbation des demandes.

---

## Modèle de données (extrait)

- Employé(id, nom, prénom, email, poste_id, date_embauche, statut)
- Poste(id, titre, département_id)
- Département(id, nom)
- Salle(id, code, capacité, équipement)
- Équipement(id, nom, type, état, localisation)
- Contrat(id, employe_id, type, début, fin, salaire)

---

## Architecture suggérée

- Backend : API RESTful (Node.js/Express, ou Django/DRF)
- Base de données : PostgreSQL
- Frontend : React, Vue ou Angular
- Auth : JWT + gestion des rôles
- Déploiement : Docker / docker-compose

---

## Installation (exemple)

1. Cloner le dépôt.

```bash
git clone <url_du_depot>
cd <nom_du_dossier>
```

2. Créer et activer un environnement virtuel :

- Windows

python -m venv venv
.\venv\Scripts\activate

- Linux / Mac

python -m venv venv
source venv/bin/activate
---


3. Installer les dépendances :

pip install -r requirements.txt

4. Configurer la base PostgreSQL et créer la base sge :

psql -U <utilisateur> -c "CREATE DATABASE sge;"

5. Exécuter le script SQL pour créer les tables et insérer les données de test :

psql -U <utilisateur> -d sge -f sge.sql

6. Vérifier la configuration de la base dans app.py :

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://user:password@localhost/sge'

7. Démarrer l'application :

python app.py

Ouvrir ensuite http://127.0.0.1:5000
dans un navigateur.

Tester le CRUD via app.py
