#!/bin/bash
# Script d'installation pour Windows (via Git Bash ou WSL)
# Usage: ./install.bat (sur Windows) ou bash install.sh (sur Linux/Mac)

echo "================================"
echo "📦 Installation du Projet"
echo "================================"
echo ""

# Créer l'environnement virtuel
echo "🔧 Création de l'environnement virtuel..."
python -m venv venv

# Activer l'environnement (pour Linux/Mac)
if [ -f venv/bin/activate ]; then
    source venv/bin/activate
fi

# Installer les dépendances
echo "📚 Installation des dépendances..."
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "✅ Installation terminée!"
echo ""
echo "Prochaines étapes:"
echo "1. Configurez votre .env si nécessaire"
echo "2. Lancez: python app.py"
echo "3. Ouvrez: http://localhost:5000"
