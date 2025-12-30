import os
from flask import Flask, jsonify, render_template
from database import db
from config import config
from routes_personnel import personnel_bp
from routes_poste import poste_bp
from routes_annonce import annonce_bp
from routes_candidature import candidature_bp
from routes_contrat import contrat_bp

def create_app(config_name='development'):
    """Factory function pour créer l'application Flask"""
    
    app = Flask(__name__, 
                template_folder='templates',
                static_folder='static',
                static_url_path='/static')
    
    # Charger la configuration
    app.config.from_object(config[config_name])
    
    # Initialiser la base de données
    try:
        db.connect()
    except Exception as e:
        print(f"Erreur lors de la connexion à la base de données: {e}")
        return None
    
    # Enregistrer les blueprints
    app.register_blueprint(personnel_bp)
    app.register_blueprint(poste_bp)
    app.register_blueprint(annonce_bp)
    app.register_blueprint(candidature_bp)
    app.register_blueprint(contrat_bp)
    
    # Routes principales
    @app.route('/', methods=['GET'])
    def index():
        return render_template('index.html')
    
    @app.route('/api', methods=['GET'])
    def api_info():
        return jsonify({
            'message': 'Bienvenue dans l\'API de Gestion des Recrutements',
            'version': '1.0.0',
            'endpoints': {
                'personnel': '/api/personnel',
                'poste': '/api/poste',
                'annonce': '/api/annonce',
                'candidature': '/api/candidature',
                'contrat': '/api/contrat'
            }
        }), 200
    
    @app.route('/health', methods=['GET'])
    def health():
        return jsonify({
            'status': 'healthy',
            'message': 'API opérationnelle'
        }), 200
    
    # Gestion des erreurs
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            'success': False,
            'error': 'Ressource non trouvée'
        }), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({
            'success': False,
            'error': 'Erreur interne du serveur'
        }), 500
    
    # Fermer la connexion à la base de données à l'arrêt
    @app.teardown_appcontext
    def close_connection(exception):
        if db.connection:
            db.disconnect()
    
    return app

if __name__ == '__main__':
    app = create_app('development')
    if app:
        app.run(debug=True, host='0.0.0.0', port=5000)
