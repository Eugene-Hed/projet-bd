from flask import Blueprint, request, jsonify
from models import Poste

poste_bp = Blueprint('poste', __name__, url_prefix='/api/poste')

@poste_bp.route('', methods=['GET'])
def get_postes():
    """Récupérer tous les postes"""
    try:
        postes = Poste.get_all()
        return jsonify({
            'success': True,
            'data': postes,
            'count': len(postes)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@poste_bp.route('/<int:id_post>', methods=['GET'])
def get_poste_by_id(id_post):
    """Récupérer un poste par ID"""
    try:
        poste = Poste.get_by_id(id_post)
        if not poste:
            return jsonify({
                'success': False,
                'error': 'Poste non trouvé'
            }), 404
        return jsonify({
            'success': True,
            'data': poste
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@poste_bp.route('', methods=['POST'])
def create_poste():
    """Créer un nouveau poste"""
    try:
        data = request.get_json()
        
        if not data.get('fonction'):
            return jsonify({
                'success': False,
                'error': 'Le champ fonction est obligatoire'
            }), 400
        
        Poste.create(
            fonction=data['fonction'],
            departement=data.get('departement'),
            specialite=data.get('specialite'),
            niveauRequis=data.get('niveauRequis'),
            description=data.get('description'),
            nombrePostesDisponibles=data.get('nombrePostesDisponibles', 1),
            dureeContratPrevu=data.get('dureeContratPrevu')
        )
        
        return jsonify({
            'success': True,
            'message': 'Poste créé avec succès'
        }), 201
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@poste_bp.route('/<int:id_post>', methods=['PUT'])
def update_poste(id_post):
    """Mettre à jour un poste"""
    try:
        poste = Poste.get_by_id(id_post)
        if not poste:
            return jsonify({
                'success': False,
                'error': 'Poste non trouvé'
            }), 404
        
        data = request.get_json()
        Poste.update(id_post, **data)
        
        return jsonify({
            'success': True,
            'message': 'Poste mis à jour avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@poste_bp.route('/<int:id_post>', methods=['DELETE'])
def delete_poste(id_post):
    """Supprimer un poste"""
    try:
        poste = Poste.get_by_id(id_post)
        if not poste:
            return jsonify({
                'success': False,
                'error': 'Poste non trouvé'
            }), 404
        
        Poste.delete(id_post)
        
        return jsonify({
            'success': True,
            'message': 'Poste supprimé avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
