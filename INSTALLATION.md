# Application Gestion du Personnel - Flask

Une application complète de gestion du personnel avec deux rôles : **Admin** et **Demandeur d'Emploi**.

## 📋 Fonctionnalités

### Pour l'Admin
- **Gestion des Postes** : Créer, modifier, supprimer des postes
- **Gestion des Annonces** : Publier et gérer les offres d'emploi
- **Gestion des Contrats** : Voir les candidatures reçues
- **Gestion du Personnel** : Gérer les employés embauchés

### Pour le Demandeur d'Emploi
- **Profil Personnel** : Gérer ses informations personnelles
- **Recherche de Postes** : Consulter les offres disponibles
- **Gestion des Candidatures** : Suivre ses candidatures

## 🚀 Installation et Démarrage

### 1. Prérequis
- Python 3.8+
- MySQL (XAMPP)
- Flask

### 2. Installation des dépendances
```bash
pip install -r requirements.txt
```

### 3. Configuration de la base de données
Assurez-vous que :
1. XAMPP MySQL est en cours d'exécution
2. La base de données `mod_personnel` existe (exécutez `mod_personnel.sql`)

### 4. Lancer l'application
```bash
python run.py
```

L'application sera accessible à : **http://localhost:5000**

## 📁 Structure du Projet

```
app/
├── __init__.py          # Initialisation Flask
├── models.py            # Modèles de données
├── routes.py            # Toutes les routes
├── templates/
│   ├── base.html                   # Template de base
│   ├── index.html                  # Page d'accueil
│   ├── admin/
│   │   ├── dashboard.html          # Dashboard admin
│   │   ├── postes.html             # Gestion des postes
│   │   ├── create_poste.html
│   │   ├── edit_poste.html
│   │   ├── annonces.html           # Gestion des annonces
│   │   ├── create_annonce.html
│   │   ├── edit_annonce.html
│   │   ├── contrats.html           # Gestion des contrats
│   │   ├── personnel.html          # Gestion du personnel
│   │   └── create_personnel.html
│   └── job_seeker/
│       ├── dashboard.html          # Dashboard demandeur
│       ├── profile.html            # Profil personnel
│       ├── postes.html             # Recherche de postes
│       └── candidatures.html       # Mes candidatures
│
config.py               # Configuration Flask
run.py                  # Point d'entrée
requirements.txt        # Dépendances Python
README.md               # Documentation
```

## 🎨 Interface Utilisateur

### Page d'Accueil
Une interface moderne avec deux boutons pour choisir son rôle :
- Demandeur d'Emploi
- Administrateur

### Dashboard Admin
Un tableau de bord professionnel avec :
- Statistiques en temps réel
- Navigation rapide vers les modules
- Interface intuitive et responsive

### Espace Demandeur d'Emploi
Interface dédiée avec :
- Gestion du profil
- Recherche d'offres
- Suivi des candidatures

## 🔧 Routes Principales

| Route | Description |
|-------|-------------|
| `/` | Page d'accueil |
| `/admin/dashboard` | Dashboard admin |
| `/admin/postes` | Gestion des postes |
| `/admin/annonces` | Gestion des annonces |
| `/admin/contrats` | Gestion des contrats |
| `/admin/personnel` | Gestion du personnel |
| `/job-seeker/dashboard` | Dashboard demandeur |
| `/job-seeker/profile` | Profil personnel |
| `/job-seeker/postes` | Recherche de postes |
| `/job-seeker/candidatures` | Mes candidatures |

## 💾 Base de Données

L'application utilise les tables suivantes :
- `personne` - Données personnelles
- `poste` - Définition des postes
- `annonce` - Offres d'emploi
- `contrat` - Candidatures
- `personneposte` - Personnel embauché

## 📝 Notes

- L'application est en mode DEBUG pour le développement
- Pas d'authentification implémentée (à ajouter selon vos besoins)
- Les fichiers sont sauvegardés en base de données

## 🔐 Sécurité

À améliorer :
- Ajouter l'authentification
- Valider les inputs côté serveur
- Implémenter les permissions par rôle
- Ajouter la protection CSRF

## 📞 Support

Pour toute question ou amélioration, consulter la documentation Flask officielle.

---
**Développé avec Flask et Bootstrap** ✨
