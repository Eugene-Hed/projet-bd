#!/bin/bash
# Script de démarrage de l'application
# Usage: ./start.sh

echo "================================"
echo "🚀 Démarrage de l'Application"
echo "================================"
echo ""

# Vérifier Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé"
    exit 1
fi

echo "✅ Python 3 trouvé"

# Vérifier l'environnement virtuel
if [ ! -d "venv" ]; then
    echo "📦 Création de l'environnement virtuel..."
    python3 -m venv venv
fi

# Activer l'environnement virtuel
echo "🔌 Activation de l'environnement virtuel..."
source venv/bin/activate

# Installer les dépendances
echo "📚 Installation des dépendances..."
pip install -r requirements.txt > /dev/null 2>&1

# Exécuter le diagnostic
echo ""
echo "🔍 Exécution du diagnostic..."
python diagnostic.py

echo ""
echo "================================"
echo "🎯 Démarrage de l'application..."
echo "================================"
echo ""

# Lancer l'application
python app.py
