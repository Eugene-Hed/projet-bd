# 🚀 Interface Web - Guide d'Utilisation

## 📦 Installation et Démarrage

### 1. Vérifier les dépendances
L'interface web ne nécessite aucune dépendance supplémentaire. Assurez-vous que Flask est installé :

```bash
pip install -r requirements.txt
```

### 2. Lancer l'application

```bash
python app.py
```

L'application sera accessible à : `http://localhost:5000`

---

## 🎨 Structure de l'Interface

### Barre Latérale (Sidebar)
- **Logo** : Affiche le nom de l'application (RH Manager)
- **Menu de Navigation** : Permet de basculer entre les différentes sections
  - 📊 Tableau de Bord
  - 👥 Personnel
  - 💼 Postes
  - 📢 Annonces
  - 📝 Candidatures
  - 📄 Contrats

### En-tête (Header)
- Affiche le titre de la page actuelle
- Affiche l'heure actuelle (mise à jour en temps réel)

### Zone Principale
- Tableau de Bord : Statistiques et raccourcis rapides
- Sections de gestion : Tableaux de données pour chaque entité

---

## 📊 Tableau de Bord

Le tableau de bord affiche :
- **Nombre de Personnel** : Nombre total d'employés
- **Nombre de Postes** : Nombre total de postes disponibles
- **Annonces Actives** : Nombre d'annonces en cours
- **Candidatures** : Nombre total de candidatures

Chaque carte est cliquable pour accéder directement à la section correspondante.

---

## 👥 Gestion du Personnel

### Vue d'ensemble
Tableau affichant tous les employés avec les informations :
- ID, Nom, Prénom, Email, Téléphone, Ville, Niveau d'Étude

### Actions disponibles

#### ➕ Ajouter un Personnel
1. Cliquez sur le bouton **"➕ Ajouter Personnel"**
2. Remplissez le formulaire avec les informations :
   - **Nom** * (obligatoire)
   - **Prénom** * (obligatoire)
   - **Email** * (obligatoire)
   - Téléphone
   - Adresse
   - Code Postal
   - Ville
   - Niveau d'Étude
   - Date de Naissance
3. Cliquez sur **"Enregistrer"**

#### ✏️ Modifier un Personnel
1. Cliquez sur le bouton **"Modifier"** sur la ligne du personnel
2. Le formulaire se remplira avec les données actuelles
3. Modifiez les informations souhaitées
4. Cliquez sur **"Enregistrer"**

#### 🗑️ Supprimer un Personnel
1. Cliquez sur le bouton **"Supprimer"** sur la ligne du personnel
2. Confirmez la suppression dans la boîte de dialogue
3. Le personnel sera marqué comme inactif

---

## 💼 Gestion des Postes

### Voir tous les postes
Tableau affichant tous les postes avec :
- ID, Fonction, Département, Spécialité, Niveau Requis, Postes Disponibles

### Actions disponibles

#### ➕ Ajouter un Poste
1. Cliquez sur **"➕ Ajouter Poste"**
2. Remplissez les informations :
   - **Fonction** * (obligatoire)
   - Département
   - Spécialité
   - Niveau Requis
   - Description
   - Nombre de Postes Disponibles
   - Durée Contrat Prévue (en mois)
3. Cliquez sur **"Enregistrer"**

#### ✏️ Modifier un Poste
1. Cliquez sur **"Modifier"** sur la ligne du poste
2. Modifiez les informations
3. Cliquez sur **"Enregistrer"**

#### 🗑️ Supprimer un Poste
1. Cliquez sur **"Supprimer"**
2. Confirmez la suppression

---

## 📢 Gestion des Annonces

### Voir toutes les annonces
Tableau affichant les annonces avec :
- ID, Titre, Poste, Statut (Actif/Inactif), Date Publication

### Actions disponibles

#### ➕ Créer une Annonce
1. Cliquez sur **"➕ Ajouter Annonce"**
2. Remplissez les champs :
   - **Titre** * (obligatoire)
   - Description
   - ID Poste
   - Salaire
   - Date Publication
   - Date Expiration
3. Cliquez sur **"Enregistrer"**

#### ✏️ Modifier une Annonce
1. Cliquez sur **"Modifier"**
2. Mettez à jour les informations
3. Cliquez sur **"Enregistrer"**

#### 🗑️ Désactiver une Annonce
1. Cliquez sur **"Supprimer"**
2. Confirmez

---

## 📝 Gestion des Candidatures

### Voir toutes les candidatures
Tableau affichant :
- ID, Candidat, Annonce, Statut, Date Candidature

### Actions disponibles

#### Modifier une Candidature
1. Cliquez sur **"Modifier"**
2. Changez le statut ou les notes
3. Enregistrez

#### Supprimer une Candidature
1. Cliquez sur **"Supprimer"**
2. Confirmez

---

## 📄 Gestion des Contrats

### Voir tous les contrats
Tableau affichant :
- ID, Personnel, Poste, Date Début, Date Fin, Type Contrat

### Actions disponibles

#### ➕ Créer un Contrat
1. Cliquez sur **"➕ Ajouter Contrat"**
2. Remplissez les informations :
   - **ID Personnel** * (obligatoire)
   - **ID Poste**
   - **Date Début** * (obligatoire)
   - Date Fin
   - Type Contrat (CDI, CDD, Stage, etc.)
   - Salaire
3. Cliquez sur **"Enregistrer"**

---

## 🎨 Fonctionnalités de l'Interface

### 🔔 Notifications (Toast)
- **Succès** (vert) : Opération réussie
- **Erreur** (rouge) : Problème lors de l'opération
- **Avertissement** (orange) : Information importante

Les notifications disparaissent automatiquement après 3 secondes.

### 🔍 Formulaires Responsifs
- Les formulaires s'adaptent à tous les appareils
- Validation côté client pour les champs obligatoires
- Les erreurs sont clairement indiquées

### 📱 Responsive Design
L'interface s'adapte à tous les tailles d'écran :
- Ordinateur de bureau
- Tablette
- Mobile

---

## 🔧 Raccourcis Clavier

| Raccourci | Action |
|-----------|--------|
| `Échap` | Fermer la fenêtre modale |
| `Tab` | Naviguer entre les champs du formulaire |

---

## ⚠️ Notes Importantes

1. **Soft Delete** : La suppression d'une personne la marque comme inactif, elle n'est pas réellement supprimée de la base de données

2. **Email Unique** : Chaque personnel doit avoir une adresse email unique

3. **Champs Obligatoires** : Les champs marqués avec `*` sont obligatoires

4. **Horaire de Mise à Jour** : L'heure affichée dans l'en-tête se met à jour en temps réel

5. **Connexion à la Base de Données** : Assurez-vous que MySQL est en cours d'exécution et que les paramètres de configuration sont corrects

---

## 🐛 Dépannage

### L'interface ne se charge pas
- Vérifiez que le serveur Flask est démarré
- Vérifiez l'URL : `http://localhost:5000`
- Consultez la console du serveur pour les erreurs

### Les données ne s'affichent pas
- Vérifiez la connexion à la base de données
- Assurez-vous que les tables sont créées
- Vérifiez les identifiants de connexion dans `config.py`

### Les boutons ne fonctionnent pas
- Vérifiez la console du navigateur (F12) pour les erreurs JavaScript
- Assurez-vous que les fichiers statiques sont chargés correctement

---

## 📞 Support

Pour tout problème ou suggestion, consultez la documentation API dans le README.md principal.

---

**Version** : 1.0.0  
**Dernière mise à jour** : 23 Décembre 2025
