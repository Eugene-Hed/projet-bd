# API de Gestion des Recrutements - Documentation

## 📋 Structure du Projet

```
recrutement_app/
├── app.py                      # Application Flask principale
├── config.py                   # Configuration
├── database.py                 # Gestion de la base de données
├── models.py                   # Modèles de données
├── routes_personnel.py         # Routes API pour personnel
├── routes_poste.py            # Routes API pour poste
├── routes_annonce.py          # Routes API pour annonce
├── routes_candidature.py      # Routes API pour candidature
├── routes_contrat.py          # Routes API pour contrat
├── requirements.txt           # Dépendances Python
├── .env.example               # Variables d'environnement (exemple)
└── README.md                  # Cette documentation
```

## 🚀 Installation

### Prérequis
- Python 3.8+
- MySQL 5.7+
- pip

### Étapes

1. **Cloner/Créer le projet**
```bash
cd /path/to/recrutement_app
```

2. **Créer un environnement virtuel**
```bash
python3 -m venv venv
source venv/bin/activate  # Sur Linux/Mac
# ou
venv\Scripts\activate  # Sur Windows
```

3. **Installer les dépendances**
```bash
pip install -r requirements.txt
```

4. **Configurer la base de données**
```bash
# Importer le fichier SQL
mysql -u root -p etablissement < /path/to/etablissement.sql
```

5. **Configurer les variables d'environnement**
```bash
cp .env.example .env
# Éditer .env avec vos paramètres MySQL
```

6. **Lancer l'application**
```bash
python app.py
```

L'API sera disponible à `http://localhost:5000`

## 📚 Endpoints API

### Personnel
- `GET /api/personnel` - Lister tous les personnels
- `GET /api/personnel/<id>` - Récupérer un personnel
- `POST /api/personnel` - Créer un personnel
- `PUT /api/personnel/<id>` - Mettre à jour un personnel
- `DELETE /api/personnel/<id>` - Supprimer un personnel

### Poste
- `GET /api/poste` - Lister tous les postes
- `GET /api/poste/<id>` - Récupérer un poste
- `POST /api/poste` - Créer un poste
- `PUT /api/poste/<id>` - Mettre à jour un poste
- `DELETE /api/poste/<id>` - Supprimer un poste

### Annonce
- `GET /api/annonce` - Lister toutes les annonces
- `GET /api/annonce/active` - Lister les annonces actives
- `GET /api/annonce/<id>` - Récupérer une annonce
- `POST /api/annonce` - Créer une annonce
- `PUT /api/annonce/<id>` - Mettre à jour une annonce
- `DELETE /api/annonce/<id>` - Supprimer une annonce

### Candidature
- `GET /api/candidature` - Lister toutes les candidatures
- `GET /api/candidature/<id>` - Récupérer une candidature
- `GET /api/candidature/annonce/<id>` - Lister les candidatures pour une annonce
- `POST /api/candidature` - Créer une candidature
- `PUT /api/candidature/<id>` - Mettre à jour une candidature
- `DELETE /api/candidature/<id>` - Supprimer une candidature

### Contrat
- `GET /api/contrat` - Lister tous les contrats
- `GET /api/contrat/<id>` - Récupérer un contrat
- `GET /api/contrat/personnel/<id>` - Lister les contrats d'un personnel
- `POST /api/contrat` - Créer un contrat
- `PUT /api/contrat/<id>` - Mettre à jour un contrat
- `DELETE /api/contrat/<id>` - Supprimer un contrat

## 📝 Exemples de Requêtes

### Créer un personnel
```bash
curl -X POST http://localhost:5000/api/personnel \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Dupont",
    "prenom": "Jean",
    "email": "jean.dupont@example.com",
    "numeroTelephone": "+33612345678",
    "ville": "Paris"
  }'
```

### Créer un poste
```bash
curl -X POST http://localhost:5000/api/poste \
  -H "Content-Type: application/json" \
  -d '{
    "fonction": "Professeur de Mathématiques",
    "departement": "Mathématiques",
    "specialite": "Algèbre",
    "niveauRequis": "Master",
    "description": "Enseignant chercheur en mathématiques",
    "nombrePostesDisponibles": 2
  }'
```

### Créer une annonce
```bash
curl -X POST http://localhost:5000/api/annonce \
  -H "Content-Type: application/json" \
  -d '{
    "datePublication": "2025-12-23",
    "dateCloturePostulation": "2026-01-23",
    "id_post": 1,
    "nombrePostes": 2
  }'
```

### Créer une candidature
```bash
curl -X POST http://localhost:5000/api/candidature \
  -H "Content-Type: application/json" \
  -d '{
    "id_annonce": 1,
    "id_personnel": 1,
    "cheminCv": "/uploads/cv_dupont.pdf",
    "observations": "Excellent candidat"
  }'
```

### Créer un contrat
```bash
curl -X POST http://localhost:5000/api/contrat \
  -H "Content-Type: application/json" \
  -d '{
    "id_personnel": 1,
    "typeContrat": "CDI",
    "montantSalaire": 2500.00,
    "dateDebut": "2026-01-01",
    "dateFin": null,
    "dureeHebrdo": 35,
    "typeRemuneration": "Mensuel"
  }'
```

## 🔄 Cycle de Recrutement Typique

1. **Créer un poste**
   - `POST /api/poste` avec les informations du poste

2. **Publier une annonce**
   - `POST /api/annonce` pour le poste créé

3. **Gérer les candidatures**
   - `GET /api/annonce/active` pour voir les annonces ouvertes
   - `POST /api/candidature` quand un candidat postule
   - `GET /api/candidature/annonce/<id>` pour voir les candidatures

4. **Évaluer les candidatures**
   - `PUT /api/candidature/<id>` pour mettre à jour le statut (en attente → acceptée/rejetée)

5. **Créer les contrats**
   - `POST /api/contrat` pour les candidats acceptés

## 🔐 Notes de Sécurité

- Toujours utiliser HTTPS en production
- Gérer les variables sensibles avec des fichiers `.env`
- Implémenter l'authentification/autorisation
- Valider et nettoyer toutes les entrées utilisateur
- Utiliser des prepared statements (déjà implémenté)

## 📄 Licence

MIT

## 👨‍💻 Support

Pour toute question ou bug, créez une issue dans le dépôt.
