# 🐘 PGADMIN4 - GUIDE D'UTILISATION

## ✅ Installation Complète

pgAdmin4 a été installé et est **en marche** via Docker.

---

## 🌐 Accès Immédiat

- **URL** : http://localhost:5050
- **Email** : admin@example.com
- **Mot de passe** : admin123

---

## 🔌 Connecter PostgreSQL à pgAdmin

### Étape 1 : Accéder à pgAdmin

1. Ouvrez http://localhost:5050 dans votre navigateur
2. Connectez-vous avec vos identifiants

### Étape 2 : Ajouter un Serveur PostgreSQL

1. Clic droit sur **Servers** (à gauche)
2. Sélectionnez **Register → Server**
3. Remplissez les informations :

#### Onglet "General"
- **Name** : PostgreSQL Local (ou le nom que vous préférez)

#### Onglet "Connection"
- **Host name/address** : `localhost` (ou `172.17.0.1` si problème)
- **Port** : `5432`
- **Maintenance database** : `postgres`
- **Username** : `postgres`
- **Password** : (Laissez vide si pas de mot de passe, ou entrez le vôtre)
- **Save password?** : ✓ (optionnel)

#### Onglet "Advanced"
- **DB restriction** : (optionnel, laissez vide)

4. Clic sur **Save**

### Étape 3 : Vérifier la Connexion

Une fois sauvegardé, vous devriez voir :
```
Servers
└── PostgreSQL Local
    └── Databases
        ├── postgres
        ├── presence_db (✓ celle-ci !)
        └── ...
```

---

## 🎯 Utilisation Courante

### Consulter les Tables

1. Naviguez dans : **Servers → PostgreSQL Local → Databases → presence_db → Schemas → public → Tables**
2. Clic droit sur une table → **View/Edit Data → All Rows**

### Exécuter une Requête SQL

1. Clic droit sur la base → **Query Tool**
2. Écrivez votre SQL
3. F5 ou bouton **Execute** pour exécuter

### Exemples de Requêtes

```sql
-- Voir tous les utilisateurs
SELECT * FROM UTILISATEUR;

-- Voir les événements
SELECT * FROM EVENEMENT;

-- Voir les présences
SELECT * FROM PRESENCE;

-- Compter les tables
SELECT COUNT(*) FROM UTILISATEUR;
```

### Importer un Fichier SQL

1. Clic droit sur la base → **Query Tool**
2. Ouvrez le fichier SQL
3. F5 pour exécuter

---

## 🔧 Commandes Docker Utiles

```bash
# Voir le statut
sudo docker ps | grep pgadmin

# Arrêter pgAdmin
sudo docker stop pgadmin

# Redémarrer pgAdmin
sudo docker restart pgadmin

# Voir les logs
sudo docker logs pgadmin

# Accéder au shell du container
sudo docker exec -it pgadmin bash
```

---

## 🚨 Dépannage

### Erreur : "Could not connect to server"

**Solution 1** : Changez le hostname en `172.17.0.1`
- Docker sur Linux utilise cette IP pour accéder à l'host

**Solution 2** : Vérifiez que PostgreSQL écoute sur 5432
```bash
sudo netstat -tuln | grep 5432
# ou
sudo ss -tuln | grep 5432
```

**Solution 3** : Redémarrez PostgreSQL
```bash
sudo systemctl restart postgresql
```

### Erreur : "Password authentication failed"

- Vérifiez le mot de passe PostgreSQL
- Essayez sans mot de passe (laissez vide)
- Vérifiez `/etc/postgresql/*/main/pg_hba.conf`

### pgAdmin ne charge pas

- Attendez 30-60 secondes au premier démarrage
- Rafraîchissez la page (F5)
- Vérifiez les logs : `sudo docker logs pgadmin`

---

## 📊 Vos Bases de Données Actuelles

### presence_db (PostgreSQL)
- **Tables** : 8
- **Données** : Présences, événements, utilisateurs
- **Créée par** : `presence_postgresql.sql`

### etablissement (MySQL - ancien système)
- **Tables** : 12
- **Données** : Personnel, postes, recrutement
- **Créée par** : `etablissement.sql`

### établissement_presence_fusionne
- **Base fusionnée** (optionnel)
- **Fichiers** :
  - `etablissement_presence_fusionne.sql` (PostgreSQL)
  - `etablissement_presence_fusionne_mysql.sql` (MySQL)

---

## 📚 Ressources

- [Documentation pgAdmin officielle](https://www.pgadmin.org/docs/)
- [Documentation PostgreSQL](https://www.postgresql.org/docs/)
- [Tutoriels pgAdmin](https://www.pgadmin.org/docs/pgadmin4/latest/)

---

## ✨ Prochaines Étapes

1. ✅ pgAdmin est installé et fonctionnel
2. ✅ Connectez votre base PostgreSQL (presence_db)
3. 📋 Consultez vos données via l'interface graphique
4. 🛠️ Gérez vos tables, index, et permissions
5. 📊 Créez des rapports et visualisations

---

**Bon travail avec pgAdmin ! 🐘**
