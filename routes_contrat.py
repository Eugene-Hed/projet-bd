from flask import Blueprint, request, jsonify
from models import Contrat

contrat_bp = Blueprint('contrat', __name__, url_prefix='/api/contrat')

@contrat_bp.route('', methods=['GET'])
def get_contrats():
    """Récupérer tous les contrats"""
    try:
        contrats = Contrat.get_all()
        return jsonify({
            'success': True,
            'data': contrats,
            'count': len(contrats)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@contrat_bp.route('/<int:id_contrat>', methods=['GET'])
def get_contrat_by_id(id_contrat):
    """Récupérer un contrat par ID"""
    try:
        contrat = Contrat.get_by_id(id_contrat)
        if not contrat:
            return jsonify({
                'success': False,
                'error': 'Contrat non trouvé'
            }), 404
        return jsonify({
            'success': True,
            'data': contrat
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@contrat_bp.route('/personnel/<int:id_personnel>', methods=['GET'])
def get_contrats_by_personnel(id_personnel):
    """Récupérer les contrats d'un personnel"""
    try:
        contrats = Contrat.get_by_personnel(id_personnel)
        return jsonify({
            'success': True,
            'data': contrats,
            'count': len(contrats)
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@contrat_bp.route('', methods=['POST'])
def create_contrat():
    """Créer un nouveau contrat"""
    try:
        data = request.get_json()
        
        if not data.get('id_personnel') or not data.get('typeContrat') or not data.get('montantSalaire') or not data.get('dateDebut'):
            return jsonify({
                'success': False,
                'error': 'Les champs id_personnel, typeContrat, montantSalaire et dateDebut sont obligatoires'
            }), 400
        
        Contrat.create(
            id_personnel=data['id_personnel'],
            typeContrat=data['typeContrat'],
            montantSalaire=data['montantSalaire'],
            dateDebut=data['dateDebut'],
            typeRemuneration=data.get('typeRemuneration'),
            dateFin=data.get('dateFin'),
            id_statut=data.get('id_statut', 1),
            dureeHebrdo=data.get('dureeHebrdo'),
            avantages=data.get('avantages')
        )
        
        return jsonify({
            'success': True,
            'message': 'Contrat créé avec succès'
        }), 201
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@contrat_bp.route('/<int:id_contrat>', methods=['PUT'])
def update_contrat(id_contrat):
    """Mettre à jour un contrat"""
    try:
        contrat = Contrat.get_by_id(id_contrat)
        if not contrat:
            return jsonify({
                'success': False,
                'error': 'Contrat non trouvé'
            }), 404
        
        data = request.get_json()
        Contrat.update(id_contrat, **data)
        
        return jsonify({
            'success': True,
            'message': 'Contrat mis à jour avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@contrat_bp.route('/<int:id_contrat>', methods=['DELETE'])
def delete_contrat(id_contrat):
    """Supprimer un contrat"""
    try:
        contrat = Contrat.get_by_id(id_contrat)
        if not contrat:
            return jsonify({
                'success': False,
                'error': 'Contrat non trouvé'
            }), 404
        
        Contrat.delete(id_contrat)
        
        return jsonify({
            'success': True,
            'message': 'Contrat supprimé avec succès'
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
