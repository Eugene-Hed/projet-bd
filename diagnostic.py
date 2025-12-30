#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script de vérification et diagnostique de l'application
Vérifie que tous les fichiers sont présents et la configuration est correcte
"""

import os
import sys
from pathlib import Path

def check_environment():
    """Vérifier l'environnement Python"""
    print("=" * 60)
    print("🔍 DIAGNOSTIC - Gestion des Recrutements")
    print("=" * 60)
    
    print(f"\n📍 Version Python: {sys.version}")
    
    # Vérifier les modules
    required_modules = ['flask', 'pymysql', 'dotenv']
    print("\n📦 Modules requis:")
    
    for module in required_modules:
        try:
            __import__(module)
            print(f"  ✅ {module}")
        except ImportError:
            print(f"  ❌ {module} - À installer: pip install {module}")

def check_files():
    """Vérifier la présence des fichiers"""
    print("\n📁 Structure des fichiers:")
    
    base_path = Path(__file__).parent
    
    files_to_check = [
        # Python files
        ('app.py', 'Application principale'),
        ('config.py', 'Configuration'),
        ('database.py', 'Gestion BD'),
        ('models.py', 'Modèles'),
        ('routes_personnel.py', 'Routes Personnel'),
        ('routes_poste.py', 'Routes Poste'),
        ('routes_annonce.py', 'Routes Annonce'),
        ('routes_candidature.py', 'Routes Candidature'),
        ('routes_contrat.py', 'Routes Contrat'),
        
        # Frontend files
        ('templates/index.html', 'Page HTML'),
        ('static/css/style.css', 'Styles CSS'),
        ('static/js/api.js', 'Client API'),
        ('static/js/ui.js', 'Gestion UI'),
        ('static/js/app.js', 'Logique App'),
        
        # Configuration
        ('requirements.txt', 'Dépendances'),
        ('README.md', 'Documentation'),
        ('INTERFACE_README.md', 'Doc Interface'),
        ('INTERFACE_GUIDE.md', 'Guide Utilisation'),
    ]
    
    for file_path, description in files_to_check:
        full_path = base_path / file_path
        status = "✅" if full_path.exists() else "❌"
        print(f"  {status} {file_path:30} - {description}")

def check_database():
    """Vérifier la configuration BD"""
    print("\n🗄️ Configuration Base de Données:")
    
    try:
        from config import Config
        print(f"  ✅ Host: {Config.MYSQL_HOST}")
        print(f"  ✅ User: {Config.MYSQL_USER}")
        print(f"  ✅ Database: {Config.MYSQL_DB}")
        print(f"  ✅ Port: {Config.MYSQL_PORT}")
        
        # Tester la connexion
        try:
            import pymysql
            conn = pymysql.connect(
                host=Config.MYSQL_HOST,
                user=Config.MYSQL_USER,
                password=Config.MYSQL_PASSWORD,
                database=Config.MYSQL_DB,
                port=Config.MYSQL_PORT
            )
            print(f"  ✅ Connexion MySQL: RÉUSSIE")
            conn.close()
        except Exception as e:
            print(f"  ❌ Connexion MySQL: ÉCHOUÉE - {str(e)[:50]}")
    except Exception as e:
        print(f"  ❌ Erreur de configuration: {e}")

def check_api_endpoints():
    """Afficher les endpoints API"""
    print("\n🔌 Endpoints API:")
    
    endpoints = {
        'Personnel': [
            'GET /api/personnel',
            'POST /api/personnel',
            'GET /api/personnel/<id>',
            'PUT /api/personnel/<id>',
            'DELETE /api/personnel/<id>'
        ],
        'Poste': [
            'GET /api/poste',
            'POST /api/poste',
            'GET /api/poste/<id>',
            'PUT /api/poste/<id>',
            'DELETE /api/poste/<id>'
        ],
        'Annonce': [
            'GET /api/annonce',
            'GET /api/annonce/active',
            'POST /api/annonce',
            'GET /api/annonce/<id>',
            'PUT /api/annonce/<id>',
            'DELETE /api/annonce/<id>'
        ],
        'Candidature': [
            'GET /api/candidature',
            'POST /api/candidature',
            'GET /api/candidature/<id>',
            'GET /api/candidature/annonce/<id>',
            'PUT /api/candidature/<id>',
            'DELETE /api/candidature/<id>'
        ],
        'Contrat': [
            'GET /api/contrat',
            'POST /api/contrat',
            'GET /api/contrat/<id>',
            'PUT /api/contrat/<id>',
            'DELETE /api/contrat/<id>'
        ]
    }
    
    for entity, routes in endpoints.items():
        print(f"\n  {entity}:")
        for route in routes:
            print(f"    • {route}")

def print_startup_instructions():
    """Afficher les instructions de démarrage"""
    print("\n" + "=" * 60)
    print("🚀 INSTRUCTIONS DE DÉMARRAGE")
    print("=" * 60)
    
    print("""
1. Assurez-vous que MySQL est en cours d'exécution
2. Lancez l'application:
   
   python app.py
   
3. Ouvrez votre navigateur:
   
   http://localhost:5000

4. Vérifiez l'API directement:
   
   http://localhost:5000/api

5. Explorez l'interface:
   - Tableau de Bord (Dashboard)
   - Gestion du Personnel
   - Gestion des Postes
   - Gestion des Annonces
   - Suivi des Candidatures
   - Gestion des Contrats
""")

def main():
    """Exécuter tous les diagnostics"""
    try:
        check_environment()
        check_files()
        check_database()
        check_api_endpoints()
        print_startup_instructions()
        
        print("\n" + "=" * 60)
        print("✅ Diagnostique terminé!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ Erreur lors du diagnostic: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
