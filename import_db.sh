#!/bin/bash

# Script d'import de la base de données PostgreSQL

cd /home/hedric/Téléchargements/recrutement_app

# Créer le fichier .pgpass pour l'authentification silencieuse
cat > ~/.pgpass << 'PGPASS_EOF'
localhost:5432:*:hedric:Hedric&2002
PGPASS_EOF

chmod 600 ~/.pgpass

echo "✅ Fichier .pgpass créé"

# Créer la base de données
echo "📦 Création de la base de données établissement_presence..."
psql -U hedric -h localhost -c "CREATE DATABASE etablissement OWNER hedric;" 2>&1 | grep -v "ATTENTION"

# Importer le schéma
echo "📥 Import du schéma dans PostgreSQL..."
psql -U hedric -h localhost -d etablissement -f etablissement.sql 2>&1 | grep -v "ATTENTION" | tail -20

echo "✅ Import terminé !"
echo ""
echo "📊 Vérification des tables créées..."
psql -U hedric -h localhost -d etablissement -c "\dt" 2>&1 | grep -v "ATTENTION"
