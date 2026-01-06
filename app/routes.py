from flask import Blueprint, render_template, request, jsonify
from app import db
from app.models import Personne, Poste, Annonce, Contrat, PersonnePoste
from datetime import datetime

# Blueprints
main_bp = Blueprint('main', __name__)
admin_bp = Blueprint('admin', __name__)
job_seeker_bp = Blueprint('job_seeker', __name__)

# ==================== ROUTES PRINCIPALES ====================
@main_bp.route('/')
def index():
    """Page d'accueil avec les 2 boutons"""
    return render_template('index.html')

# ==================== ROUTES ADMIN ====================
@admin_bp.route('/dashboard')
def dashboard():
    """Dashboard admin"""
    total_postes = Poste.query.count()
    total_annonces = Annonce.query.count()
    total_candidatures = Contrat.query.count()
    total_personnels = PersonnePoste.query.count()
    
    stats = {
        'total_postes': total_postes,
        'total_annonces': total_annonces,
        'total_candidatures': total_candidatures,
        'total_personnels': total_personnels
    }
    return render_template('admin/dashboard.html', stats=stats)

# Gestion des postes
@admin_bp.route('/postes')
def list_postes():
    """Liste des postes"""
    postes = Poste.query.all()
    return render_template('admin/postes.html', postes=postes)

@admin_bp.route('/postes/create', methods=['GET', 'POST'])
def create_poste():
    """Créer un poste"""
    if request.method == 'POST':
        data = request.json
        poste = Poste(
            fonction=data.get('fonction'),
            niveau_etude_requis=data.get('niveau_etude_requis'),
            description_tache=data.get('description_tache')
        )
        db.session.add(poste)
        db.session.commit()
        return jsonify({'success': True, 'message': 'Poste créé avec succès'}), 201
    return render_template('admin/create_poste.html')

@admin_bp.route('/postes/<int:id>/edit', methods=['GET', 'POST'])
def edit_poste(id):
    """Modifier un poste"""
    poste = Poste.query.get_or_404(id)
    if request.method == 'POST':
        data = request.json
        poste.fonction = data.get('fonction', poste.fonction)
        poste.niveau_etude_requis = data.get('niveau_etude_requis', poste.niveau_etude_requis)
        poste.description_tache = data.get('description_tache', poste.description_tache)
        db.session.commit()
        return jsonify({'success': True, 'message': 'Poste modifié avec succès'}), 200
    return render_template('admin/edit_poste.html', poste=poste)

@admin_bp.route('/postes/<int:id>/delete', methods=['DELETE'])
def delete_poste(id):
    """Supprimer un poste"""
    poste = Poste.query.get_or_404(id)
    db.session.delete(poste)
    db.session.commit()
    return jsonify({'success': True, 'message': 'Poste supprimé'}), 200

# Gestion des annonces
@admin_bp.route('/annonces')
def list_annonces():
    """Liste des annonces"""
    annonces = Annonce.query.all()
    return render_template('admin/annonces.html', annonces=annonces)

@admin_bp.route('/annonces/create', methods=['GET', 'POST'])
def create_annonce():
    """Créer une annonce"""
    postes = Poste.query.all()
    if request.method == 'POST':
        data = request.json
        annonce = Annonce(
            DatePubliation=datetime.strptime(data.get('date_publication'), '%Y-%m-%d').date(),
            DelaiDepotCandidature=datetime.strptime(data.get('delai_depot'), '%Y-%m-%d').date(),
            IdPoste=data.get('id_poste')
        )
        db.session.add(annonce)
        db.session.commit()
        return jsonify({'success': True, 'message': 'Annonce créée'}), 201
    return render_template('admin/create_annonce.html', postes=postes)

@admin_bp.route('/annonces/<int:id>/edit', methods=['GET', 'POST'])
def edit_annonce(id):
    """Modifier une annonce"""
    annonce = Annonce.query.get_or_404(id)
    postes = Poste.query.all()
    if request.method == 'POST':
        data = request.json
        annonce.DatePubliation = datetime.strptime(data.get('date_publication'), '%Y-%m-%d').date()
        annonce.DelaiDepotCandidature = datetime.strptime(data.get('delai_depot'), '%Y-%m-%d').date()
        annonce.IdPoste = data.get('id_poste')
        db.session.commit()
        return jsonify({'success': True, 'message': 'Annonce modifiée'}), 200
    return render_template('admin/edit_annonce.html', annonce=annonce, postes=postes)

@admin_bp.route('/annonces/<int:id>/delete', methods=['DELETE'])
def delete_annonce(id):
    """Supprimer une annonce"""
    annonce = Annonce.query.get_or_404(id)
    db.session.delete(annonce)
    db.session.commit()
    return jsonify({'success': True, 'message': 'Annonce supprimée'}), 200

# Gestion des contrats
@admin_bp.route('/contrats')
def list_contrats():
    """Liste des contrats/candidatures"""
    contrats = Contrat.query.all()
    return render_template('admin/contrats.html', contrats=contrats)

@admin_bp.route('/contrats/<int:id>/delete', methods=['DELETE'])
def delete_contrat(id):
    """Supprimer un contrat"""
    contrat = Contrat.query.get_or_404(id)
    db.session.delete(contrat)
    db.session.commit()
    return jsonify({'success': True, 'message': 'Candidature supprimée'}), 200

# Gestion du personnel embauché
@admin_bp.route('/personnel')
def list_personnel():
    """Liste du personnel embauché"""
    personnels = PersonnePoste.query.all()
    return render_template('admin/personnel.html', personnels=personnels)

@admin_bp.route('/personnel/create', methods=['GET', 'POST'])
def create_personnel():
    """Ajouter un personnel"""
    personnes = Personne.query.all()
    postes = Poste.query.all()
    if request.method == 'POST':
        data = request.json
        personnel = PersonnePoste(
            DatePriseService=datetime.strptime(data.get('date_prise_service'), '%Y-%m-%d').date(),
            IdPersonne=data.get('id_personne'),
            IdPoste=data.get('id_poste')
        )
        db.session.add(personnel)
        db.session.commit()
        return jsonify({'success': True, 'message': 'Personnel ajouté'}), 201
    return render_template('admin/create_personnel.html', personnes=personnes, postes=postes)

# ==================== ROUTES JOB SEEKER ====================
@job_seeker_bp.route('/dashboard')
def job_seeker_dashboard():
    """Dashboard demandeur d'emploi"""
    annonces = Annonce.query.all()
    return render_template('job_seeker/dashboard.html', annonces=annonces)

@job_seeker_bp.route('/profile', methods=['GET', 'POST'])
def manage_profile():
    """Gérer le profil personnel"""
    if request.method == 'POST':
        data = request.json
        # Pour la démo, créer ou mettre à jour
        personne = Personne.query.first()
        if not personne:
            personne = Personne(
                nom=data.get('nom'),
                age=data.get('age'),
                niveauEtudeMax=data.get('niveau_etude'),
                statu_Matrimonial=data.get('statut_matrimonial'),
                numero_telephone=data.get('numero_telephone')
            )
            db.session.add(personne)
        else:
            personne.nom = data.get('nom', personne.nom)
            personne.age = data.get('age', personne.age)
            personne.niveauEtudeMax = data.get('niveau_etude', personne.niveauEtudeMax)
            personne.statu_Matrimonial = data.get('statut_matrimonial', personne.statu_Matrimonial)
            personne.numero_telephone = data.get('numero_telephone', personne.numero_telephone)
        
        db.session.commit()
        return jsonify({'success': True, 'message': 'Profil mis à jour'}), 200
    
    personne = Personne.query.first()
    return render_template('job_seeker/profile.html', personne=personne)

@job_seeker_bp.route('/candidatures')
def my_applications():
    """Mes candidatures"""
    contrats = Contrat.query.all()
    return render_template('job_seeker/candidatures.html', contrats=contrats)

@job_seeker_bp.route('/postes')
def search_jobs():
    """Rechercher des postes/annonces"""
    annonces = Annonce.query.all()
    return render_template('job_seeker/postes.html', annonces=annonces)

@job_seeker_bp.route('/postes/<int:id>/apply', methods=['POST'])
def apply_job(id):
    """Candidater à une annonce"""
    data = request.json
    
    # Obtenir ou créer une personne pour la démo
    personne = Personne.query.first()
    if not personne:
        personne = Personne(nom='Candidat')
        db.session.add(personne)
        db.session.flush()
    
    contrat = Contrat(
        cv=data.get('cv'),
        lettremotivation=data.get('lettre_motivation'),
        status='En attente',
        IdAnnonce=id,
        IdPersonne=personne.IdPersonne
    )
    db.session.add(contrat)
    db.session.commit()
    return jsonify({'success': True, 'message': 'Candidature envoyée'}), 201


# Route pour que l'employeur/admin prenne une décision sur une candidature
@admin_bp.route('/contrats/<int:id>/decision', methods=['POST'])
def decision_contrat(id):
    data = request.json
    statut = data.get('status')
    if statut not in ['Accepté', 'Refusé', 'En attente']:
        return jsonify({'success': False, 'message': 'Statut invalide'}), 400

    contrat = Contrat.query.get_or_404(id)
    contrat.status = statut
    db.session.commit()
    return jsonify({'success': True, 'message': f'Candidature mise à "{statut}"'}), 200
