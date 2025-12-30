from flask import Blueprint, request, jsonify
from models import Candidature

candidature_bp = Blueprint('candidature', __name__, url_prefix='/api/candidature')

@candidature_bp.route('', methods=['GET'])
def get_candidatures():
    """Récupérer toutes les candidatures"""
    try:
        candidatures = Candidature.get_all()
        return jsonify({
            'success': True,
            'data': candidatures,
            'count': len(candidatures)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@candidature_bp.route('/<int:id_candidature>', methods=['GET'])
def get_candidature_by_id(id_candidature):
    """Récupérer une candidature par ID"""
    try:
        candidature = Candidature.get_by_id(id_candidature)
        if not candidature:
            return jsonify({
                'success': False,
                'error': 'Candidature non trouvée'
            }), 404
        return jsonify({
            'success': True,
            'data': candidature
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@candidature_bp.route('/annonce/<int:id_annonce>', methods=['GET'])
def get_candidatures_by_annonce(id_annonce):
    """Récupérer les candidatures pour une annonce"""
    try:
        candidatures = Candidature.get_by_annonce(id_annonce)
        return jsonify({
            'success': True,
            'data': candidatures,
            'count': len(candidatures)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@candidature_bp.route('', methods=['POST'])
def create_candidature():
    """Créer une nouvelle candidature"""
    try:
        data = request.get_json()
        
        if not data.get('id_annonce') or not data.get('id_personnel'):
            return jsonify({
                'success': False,
                'error': 'Les champs id_annonce et id_personnel sont obligatoires'
            }), 400
        
        Candidature.create(
            id_annonce=data['id_annonce'],
            id_personnel=data['id_personnel'],
            cheminCv=data.get('cheminCv'),
            cheminLettreMotivation=data.get('cheminLettreMotivation'),
            id_statut=data.get('id_statut', 1),
            observations=data.get('observations')
        )
        
        return jsonify({
            'success': True,
            'message': 'Candidature créée avec succès'
        }), 201
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@candidature_bp.route('/<int:id_candidature>', methods=['PUT'])
def update_candidature(id_candidature):
    """Mettre à jour une candidature"""
    try:
        candidature = Candidature.get_by_id(id_candidature)
        if not candidature:
            return jsonify({
                'success': False,
                'error': 'Candidature non trouvée'
            }), 404
        
        data = request.get_json()
        Candidature.update(id_candidature, **data)
        
        return jsonify({
            'success': True,
            'message': 'Candidature mise à jour avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@candidature_bp.route('/<int:id_candidature>', methods=['DELETE'])
def delete_candidature(id_candidature):
    """Supprimer une candidature"""
    try:
        candidature = Candidature.get_by_id(id_candidature)
        if not candidature:
            return jsonify({
                'success': False,
                'error': 'Candidature non trouvée'
            }), 404
        
        Candidature.delete(id_candidature)
        
        return jsonify({
            'success': True,
            'message': 'Candidature supprimée avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
