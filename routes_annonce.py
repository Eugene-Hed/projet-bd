from flask import Blueprint, request, jsonify
from models import Annonce

annonce_bp = Blueprint('annonce', __name__, url_prefix='/api/annonce')

@annonce_bp.route('', methods=['GET'])
def get_annonces():
    """Récupérer toutes les annonces"""
    try:
        annonces = Annonce.get_all()
        return jsonify({
            'success': True,
            'data': annonces,
            'count': len(annonces)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@annonce_bp.route('/active', methods=['GET'])
def get_active_annonces():
    """Récupérer les annonces actives"""
    try:
        annonces = Annonce.get_active()
        return jsonify({
            'success': True,
            'data': annonces,
            'count': len(annonces)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@annonce_bp.route('/<int:id_annonce>', methods=['GET'])
def get_annonce_by_id(id_annonce):
    """Récupérer une annonce par ID"""
    try:
        annonce = Annonce.get_by_id(id_annonce)
        if not annonce:
            return jsonify({
                'success': False,
                'error': 'Annonce non trouvée'
            }), 404
        return jsonify({
            'success': True,
            'data': annonce
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@annonce_bp.route('', methods=['POST'])
def create_annonce():
    """Créer une nouvelle annonce"""
    try:
        data = request.get_json()
        
        # Valider les champs obligatoires
        required_fields = ['datePublication', 'dateCloturePostulation', 'id_post']
        if not all(data.get(field) for field in required_fields):
            return jsonify({
                'success': False,
                'error': f'Les champs suivants sont obligatoires: {", ".join(required_fields)}'
            }), 400
        
        # Créer l'annonce
        result = Annonce.create(
            datePublication=data['datePublication'],
            dateCloturePostulation=data['dateCloturePostulation'],
            id_post=int(data['id_post']),
            dateClotureAnnonce=data.get('dateClotureAnnonce'),
            nombrePostes=int(data.get('nombrePostes', 1)),
            id_statut=int(data.get('id_statut', 1))
        )
        
        if result:
            return jsonify({
                'success': True,
                'message': 'Annonce créée avec succès'
            }), 201
        else:
            return jsonify({
                'success': False,
                'error': 'Erreur lors de la création de l\'annonce'
            }), 500
            
    except ValueError as e:
        return jsonify({
            'success': False,
            'error': f'Erreur de conversion de données: {str(e)}'
        }), 400
    except Exception as e:
        print(f"Erreur création annonce: {str(e)}")
        return jsonify({
            'success': False,
            'error': f'Erreur serveur: {str(e)}'
        }), 500

@annonce_bp.route('/<int:id_annonce>', methods=['PUT'])
def update_annonce(id_annonce):
    """Mettre à jour une annonce"""
    try:
        annonce = Annonce.get_by_id(id_annonce)
        if not annonce:
            return jsonify({
                'success': False,
                'error': 'Annonce non trouvée'
            }), 404
        
        data = request.get_json()
        Annonce.update(id_annonce, **data)
        
        return jsonify({
            'success': True,
            'message': 'Annonce mise à jour avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@annonce_bp.route('/<int:id_annonce>', methods=['DELETE'])
def delete_annonce(id_annonce):
    """Supprimer une annonce"""
    try:
        annonce = Annonce.get_by_id(id_annonce)
        if not annonce:
            return jsonify({
                'success': False,
                'error': 'Annonce non trouvée'
            }), 404
        
        Annonce.delete(id_annonce)
        
        return jsonify({
            'success': True,
            'message': 'Annonce supprimée avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
