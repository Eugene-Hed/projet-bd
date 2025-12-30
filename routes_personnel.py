from flask import Blueprint, request, jsonify
from models import Personnel

personnel_bp = Blueprint('personnel', __name__, url_prefix='/api/personnel')

@personnel_bp.route('', methods=['GET'])
def get_personnel():
    """Récupérer tous les personnels"""
    try:
        personnels = Personnel.get_all()
        return jsonify({
            'success': True,
            'data': personnels,
            'count': len(personnels)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@personnel_bp.route('/<int:id_personnel>', methods=['GET'])
def get_personnel_by_id(id_personnel):
    """Récupérer un personnel par ID"""
    try:
        personnel = Personnel.get_by_id(id_personnel)
        if not personnel:
            return jsonify({
                'success': False,
                'error': 'Personnel non trouvé'
            }), 404
        return jsonify({
            'success': True,
            'data': personnel
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@personnel_bp.route('', methods=['POST'])
def create_personnel():
    """Créer un nouveau personnel"""
    try:
        data = request.get_json()
        
        # Validation
        if not data.get('nom') or not data.get('prenom') or not data.get('email'):
            return jsonify({
                'success': False,
                'error': 'Les champs nom, prenom et email sont obligatoires'
            }), 400
        
        # Vérifier si l'email existe déjà
        if Personnel.get_by_email(data['email']):
            return jsonify({
                'success': False,
                'error': 'Un personnel avec cet email existe déjà'
            }), 409
        
        Personnel.create(
            nom=data['nom'],
            prenom=data['prenom'],
            email=data['email'],
            numeroTelephone=data.get('numeroTelephone'),
            adresse=data.get('adresse'),
            codePostal=data.get('codePostal'),
            ville=data.get('ville'),
            niveauEtudeEleve=data.get('niveauEtudeEleve'),
            photo=data.get('photo'),
            dateNaissance=data.get('dateNaissance')
        )
        
        return jsonify({
            'success': True,
            'message': 'Personnel créé avec succès'
        }), 201
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@personnel_bp.route('/<int:id_personnel>', methods=['PUT'])
def update_personnel(id_personnel):
    """Mettre à jour un personnel"""
    try:
        personnel = Personnel.get_by_id(id_personnel)
        if not personnel:
            return jsonify({
                'success': False,
                'error': 'Personnel non trouvé'
            }), 404
        
        data = request.get_json()
        Personnel.update(id_personnel, **data)
        
        return jsonify({
            'success': True,
            'message': 'Personnel mis à jour avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@personnel_bp.route('/<int:id_personnel>', methods=['DELETE'])
def delete_personnel(id_personnel):
    """Supprimer un personnel (soft delete)"""
    try:
        personnel = Personnel.get_by_id(id_personnel)
        if not personnel:
            return jsonify({
                'success': False,
                'error': 'Personnel non trouvé'
            }), 404
        
        Personnel.delete(id_personnel)
        
        return jsonify({
            'success': True,
            'message': 'Personnel supprimé avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
